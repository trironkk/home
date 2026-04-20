vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require("trironkk.opt")
require("trironkk.keymaps")
require("trironkk.plugins.blink")
require("trironkk.plugins.oil")
require("trironkk.plugins.mini_animate")
require("trironkk.plugins.mini_clue")
require("trironkk.plugins.mini_diff")
require("trironkk.plugins.mini_icons")
require("trironkk.plugins.mini_pick")
require("trironkk.plugins.tokyonight")
require("trironkk.plugins.treesitter")
require("trironkk.plugins.screenkey")
require("trironkk.plugins.smear_cursor")
require("trironkk.lsp")

pcall(require, "trironkk.google")
