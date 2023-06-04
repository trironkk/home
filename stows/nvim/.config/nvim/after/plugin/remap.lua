vim.g.mapleader = " "

vim.keymap.set("n", "<leader>fd", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>F", function()
    vim.lsp.buf.format()
end)

-- Toggle relative line numbers and other gutters
function toggle_raw_view()
    local current_value = vim.fn.getwinvar(0, '&relativenumber')
    if current_value == 0 then
        -- Enable line numbers and other gutters
        vim.cmd('set number')
        vim.cmd('set relativenumber')
        vim.cmd('set nowrap')
        vim.diagnostic.enable()
        vim.diagnostic.show()
    else
        -- Disable line numbers and other gutters
        vim.cmd('set nonumber')
        vim.cmd('set norelativenumber')
        vim.cmd('set wrap')
        vim.diagnostic.disable()
        vim.diagnostic.hide()
    end
end

-- Keybinding to toggle gutters
vim.api.nvim_set_keymap('n', '<F3>', ':lua toggle_raw_view()<CR>', { silent = true, noremap = true })
