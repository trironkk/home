vim.pack.add({
	{ src = "https://github.com/nvzone/showkeys" },
})
require("showkeys").setup({
	timeout = 3,
	maxkeys = 7,
	position = "top-right",
	excluded_modes = {"i", "r"},
	winhl = "FloatBorder:Comment,Normal:Normal",
})

vim.keymap.set('n', '<F12>', ':ShowkeysToggle<CR>', { desc = 'Toggle Showkeys' })
