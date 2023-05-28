require("telescope").load_extension("recent_files")

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.api.nvim_set_keymap("n", "<leader>fh",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  {noremap = true, silent = true})

require("telescope").setup {
  defaults = {
  },
  extensions = {
    recent_files = {
    }
  }
}
