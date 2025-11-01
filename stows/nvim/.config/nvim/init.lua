vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0


vim.api.nvim_create_user_command('ReloadMyConfig', function()
  for name, _ in pairs(package.loaded) do
    if name:find('^' .. "trironkk") == 1 then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end, {})

vim.keymap.set('n', '<leader>sv', ':ReloadMyConfig<CR>', { desc = "[S]ource [V]im config" })

local function toggle_raw_view()
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
vim.keymap.set("n", "<F3>", toggle_raw_view, { silent = true, noremap = true, desc = "Toggle Raw View"})

local function toggle_showcase_view()
	local minianimate = require("mini.animate")
	local screenkey = require("screenkey")
	local smear_cursor = require("smear_cursor")
	if minianimate.is_active then
		-- Disable animations
		vim.g.minianimate_disable = true
		screenkey.toggle(false)
		smear_cursor.enabled = false
	else
		-- Enable animations
		vim.g.minianimate_disable = false
		screenkey.toggle(true)
		smear_cursor.enabled = true
	end
end
vim.keymap.set("n", "<F12>", toggle_showcase_view, { silent = true, noremap = true, desc = "Toggle Showcase View"})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

require("trironkk.google")
require("trironkk.opt")

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

vim.pack.add {
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
	}
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Custom prefix symbol
    format = function(diagnostic)
      return string.format([[ %s: %s ]], diagnostic.source, diagnostic.message)
    end,
  },
})
