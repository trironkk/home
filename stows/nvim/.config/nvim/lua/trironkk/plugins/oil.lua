vim.pack.add({
	{ src="https://github.com/stevearc/oil.nvim" },
})
require("oil").setup()

vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "_", ":vsplit | Oil<CR>", { desc = "Oil (in a new vertical split)" })
