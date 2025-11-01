vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.diff" },
})

local minidiff = require("mini.diff")
minidiff.setup({
	source = {
		minidiff.gen_source.git(),
		minidiff.gen_source.save(),
	},
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
