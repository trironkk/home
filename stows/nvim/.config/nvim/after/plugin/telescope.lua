local builtin = require('telescope.builtin')
local file_browser = require("telescope").extensions.file_browser

-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', file_browser.file_browser, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', ":SearchSession<CR>", {})
vim.keymap.set('n', '<leader>fv',
    function() return builtin.find_files({
            find_command = {
                'rg',
                '--files',
                '--iglob',
                '!.git',
                '--hidden',
                '-L',
                vim.env.HOME .. '/.config/nvim'
            },
        })
    end, {})

local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
            },
            n = {
            },
        },
    },
    pickers = {
        find_files = {
            mappings = {
                i = {
                    ['<C-j>'] = actions.move_selection_next,
                    ['<C-k>'] = actions.move_selection_previous,
                },
                n = {
                },
            },
        },
    },
    extensions = {
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                },
                ["n"] = {
                    ["<leader>fb"] = ".Telescope file_browser",
                },
            },
        },
    },
}
