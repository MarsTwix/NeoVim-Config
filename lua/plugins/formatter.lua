return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "prettierd", "eslint_d" },
			html = { "prettierd" },
			htmlangular = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			json = { "prettierd" },
			python = { "black" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
