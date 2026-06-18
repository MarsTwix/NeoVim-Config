vim.o.termguicolors = true
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.wrap = false -- Don't wrap lines
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.tabstop = 2 -- A tab is two spaces
vim.o.shiftwidth = 2 -- An indent is two spaces
vim.o.smartindent = true -- Smart auto-indenting
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true -- Unless uppercase is used in the search
vim.o.scrolloff = 8 -- Keep 8 lines above/below cursor when scrolling
vim.o.sidescrolloff = 8 -- Keep 8 columns left/right of cursor when scrolling
vim.o.mouse = "a" -- Enable mouse support
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.backup = false -- No backup files
vim.o.writebackup = false -- No backup files during write
vim.o.swapfile = false -- No swap files
vim.o.undofile = true -- Persistent undo
vim.o.updatetime = 300 -- Faster completion
vim.o.timeoutlen = 500 -- By default timeoutlen is 1000 ms
vim.o.signcolumn = "yes" -- Always show the signcolumn

-- Enable CursorLine to make it possible to change color
vim.o.cursorline = true
-- Make Every line number white
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#D3D3D3" })
-- Make cursor line yellow and remove background
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFEE00" })

vim.opt.spell = true
vim.opt.spelllang = "en,nl"

-- theme

vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#89CFF0" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#89CFF0" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#89CFF0" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#89CFF0" })
