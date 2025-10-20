vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("n", "<Leader>so", ":source %<CR>", { silent = true, noremap = true, desc = "source the current buffer"})

function toggle_raw_view()
	if vim.o.relativenumber then
		-- Disable line numbers and other gutters
		vim.opt.relativenumber = false
		vim.opt.number = false
		vim.opt.wrap = true
		vim.opt.list = false
		vim.opt.signcolumn = "no"
		vim.diagnostic.enable(false)
		vim.diagnostic.hide()
		vim.opt.list = false
	else
		-- Enable line numbers and other gutters
		vim.opt.relativenumber = true
		vim.opt.number = true
		vim.opt.wrap = false
		vim.opt.list = true
		vim.opt.signcolumn = "yes"
		vim.diagnostic.enable(true)
		vim.diagnostic.show()
		vim.opt.list = true
		vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	end
end
vim.api.nvim_set_keymap("n", "<F3>", ":lua toggle_raw_view()<CR>", { silent = true, noremap = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("trironkk.plugins.blink")
require("trironkk.plugins.oil")
require("trironkk.plugins.smear_cursor")
require("trironkk.plugins.mini_icons")
require("trironkk.plugins.mini_clue")
require("trironkk.plugins.mini_pick")
require("trironkk.plugins.tokyonight")

require("trironkk.opt")
require("trironkk.google")


