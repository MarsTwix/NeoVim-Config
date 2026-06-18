return {
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			automatic_enable = true,
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function(_, opts)
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			local dotnet8_paths = vim.fn.glob(vim.fn.expand("~/.asdf/installs/dotnet/8.*"), false, true)
			table.sort(dotnet8_paths)
			local dotnet8_path = dotnet8_paths[#dotnet8_paths]

			if dotnet8_path and vim.fn.isdirectory(dotnet8_path) == 1 then
				vim.lsp.config("csharp_ls", {
					cmd_env = {
						DOTNET_ROOT = dotnet8_path,
						DOTNET_ROOT_X64 = dotnet8_path,
						PATH = dotnet8_path .. ":" .. vim.env.PATH,
					},
				})
			end

			require("mason-lspconfig").setup(opts)
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
		},
		opts = {
			ensure_installed = {
				-- Lua
				"lua_ls",
				"stylua",
				"luacheck",
				-- Markdown
				"vale",
				-- Typescript
				"ts_ls",
				-- HTML
				"html",
				"markuplint",
				-- CSS, SCSS
				"cssls",
				"stylelint",
				-- Frontend
				"prettierd",
				"eslint_d",
				-- C#
				"csharp-language-server",
				-- Python
				"pyright",
				"black",
				-- Angular
				"angularls",
			},
		},
	},
}
