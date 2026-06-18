return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release
	dependencies = {
		{
			-- `snacks.nvim` integration is recommended, but optional
			---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
			"folke/snacks.nvim",
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(picker)
							local items = vim.tbl_map(function(item)
								return item.file
										and require("opencode").format({
											path = item.file,
											from = item.pos,
											to = item.end_pos,
										})
									or item.text
							end, picker:selected({ fallback = true }))

							require("opencode").prompt(table.concat(items, ", ") .. " ")
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local opencode = require("opencode")
		local opencode_command = require("opencode.api.command").command
		local opencode_context = require("opencode.context")
		local opencode_prompt = require("opencode.api.prompt").prompt
		local opencode_ui_ask = require("opencode.ui.ask").ask
		local opencode_discovery = require("opencode.server.discovery")
		local opencode_select_session = require("opencode.ui.select_session").select_session
		local map = vim.keymap.set

		local function notify_opencode_error(err)
			if err then
				vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
			end
		end

		local function ask_prompt()
			local mode = vim.fn.mode(1):sub(1, 1)
			if mode == "v" or mode == "V" or mode == "\22" then
				return "@this: "
			end

			return ""
		end

		local opencode_term = Terminal:new({
			cmd = "opencode --port",
			direction = "vertical",
			hidden = true,
			close_on_exit = false,
			on_open = function(term)
				pcall(vim.keymap.del, "t", "<C-\\>", { buffer = term.bufnr })
				map("t", "<C-]>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
				vim.schedule(function()
					if term.window and vim.api.nvim_win_is_valid(term.window) then
						vim.wo[term.window].spell = false
						term:focus()
						vim.cmd.startinsert()
					end
				end)
			end,
		})

		local function focus_opencode_panel()
			if not opencode_term:is_open() then
				return false
			end

			opencode_term:focus()
			vim.cmd.startinsert()
			return true
		end

		local function show_opencode_panel()
			if not focus_opencode_panel() then
				opencode_term:open()
			end
		end

		local function toggle_opencode_panel()
			opencode_term:toggle()
			if opencode_term:is_open() then
				vim.schedule(focus_opencode_panel)
			end
		end

		local function with_opencode_server(action)
			return opencode_discovery.get():next(action):catch(notify_opencode_error)
		end

		local function ask_current_session(server)
			local context = opencode_context.new()
			return opencode_ui_ask(ask_prompt(), server, context)
				:next(function(input)
					return opencode_prompt(input, server, context)
				end)
				:next(function(result)
					show_opencode_panel()
					return result
				end)
		end

		local function ask_in_session(opts)
			return with_opencode_server(function(server)
				if opts and opts.new_session then
					return opencode_command("session.new", server):next(function()
						return ask_current_session(server)
					end)
				end

				return ask_current_session(server)
			end)
		end

		local function switch_session()
			return with_opencode_server(function(server)
				return opencode_select_session(server)
					:next(function(session)
						return server:select_session(session.id)
					end)
					:next(show_opencode_panel)
			end)
		end

		---@type opencode.Opts
		vim.g.opencode_opts = {
			server = {
				start = function()
					opencode_term:spawn()
				end,
			},
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		map({ "n", "x" }, "<leader>oa", function()
			ask_in_session()
		end, { desc = "Ask opencode" })
		map({ "n", "x" }, "<leader>oA", function()
			ask_in_session({ new_session = true })
		end, { desc = "Ask opencode in new session" })
		map({ "n", "x" }, "<leader>ox", opencode.select, { desc = "Opencode actions" })
		map("n", "<leader>oo", toggle_opencode_panel, { desc = "Toggle opencode" })
		map("n", "<leader>on", function()
			with_opencode_server(function(server)
				return opencode_command("session.new", server):next(show_opencode_panel)
			end)
		end, { desc = "New opencode session" })
		map("n", "<leader>os", function()
			switch_session()
		end, { desc = "Switch opencode session" })

		map({ "n", "x" }, "go", function()
			return opencode.operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		map("n", "goo", function()
			return opencode.operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		map("n", "<S-C-u>", function()
			opencode.command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		map("n", "<S-C-d>", function()
			opencode.command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
