vim.pack.add({ { src = "https://github.com/stevearc/oil.nvim" } })
require("oil").setup()

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "_", "<cmd>vsplit | Oil<CR>", { desc = "Oil (vsplit)" })
