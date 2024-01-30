return {
	"akinsho/bufferline.nvim",
	depends = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup()
		vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
		vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
		vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { silent = true })
	end,
}