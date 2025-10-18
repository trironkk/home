--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("trironkk.options")
require("trironkk.keymaps")
require("trironkk.autocmds")

require("trironkk.lazy-bootstrap")
require("lazy").setup("trironkk.plugins")

require("trironkk.google")

function toggle_raw_view()
	if vim.o.relativenumber then
		-- Disable line numbers and other gutters
		vim.o.relativenumber = false
		vim.o.number = false
		vim.o.wrap = true
		vim.o.list = false
		vim.o.signcolumn = "no"
		vim.diagnostic.enable(false)
		vim.diagnostic.hide()
	else
		-- Enable line numbers and other gutters
		vim.o.relativenumber = true
		vim.o.number = true
		vim.o.wrap = false
		vim.o.list = true
		vim.o.signcolumn = "yes"
		vim.diagnostic.enable(true)
		vim.diagnostic.show()
	end
end

vim.api.nvim_set_keymap("n", "<F3>", ":lua toggle_raw_view()<CR>", { silent = true, noremap = true })
