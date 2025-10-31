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
vim.keymap.set("n", "<F3>", ":lua toggle_raw_view()<CR>", { silent = true, noremap = true, desc = "Toggle Raw View"})

-- Highlight when yanking text
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
require("trironkk.plugins.treesitter")
require("trironkk.plugins.showkeys")

require("trironkk.opt")
require("trironkk.google")

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

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.diff" },
})
require("mini.diff").setup({
	-- Options for how hunks are visualized
	view = {
		-- Visualization style. Possible values are 'sign' and 'number'.
		-- Default: 'number' if line numbers are enabled, 'sign' otherwise.
		style = vim.go.number and 'number' or 'sign',

		-- Signs used for hunks with 'sign' view
		signs = { add = '▒', change = '▒', delete = '▒' },

		-- Priority of used visualization extmarks
		priority = 199,
	},
	-- Various options
	options = {
		-- Diff algorithm. See `:h vim.diff()`.
		algorithm = 'histogram',

		-- Whether to use "indent heuristic". See `:h vim.diff()`.
		indent_heuristic = true,

		-- The amount of second-stage diff to align lines
		linematch = 60,

		-- Whether to wrap around edges during hunk navigation
		wrap_goto = false,
	},
})
vim.keymap.set('n', '<F10>', ':lua MiniDiff.toggle()<CR>', { desc = "Toggle MiniDiff" })
vim.keymap.set('n', '<F11>', ':lua MiniDiff.toggle_overlay()<CR>', { desc = "Toggle MiniDiff Overlay" })
