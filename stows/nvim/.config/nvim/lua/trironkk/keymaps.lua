vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Oil" })
vim.keymap.set("n", "_", ":vsplit | Oil<CR>", { desc = "Oil (in a new vertical split)" })

vim.api.nvim_set_keymap("i", "<leader><CR>", "<C-y>", { noremap = true })
