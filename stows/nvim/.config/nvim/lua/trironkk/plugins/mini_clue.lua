vim.pack.add({ { src = "https://github.com/nvim-mini/mini.clue" } })

local clue = require("mini.clue")
clue.setup({
	window = { config = { border = "double", width = 100 }, delay = 200 },
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "g" }, { mode = "x", keys = "g" },
		{ mode = "n", keys = "'" }, { mode = "n", keys = "`" },
		{ mode = "x", keys = "'" }, { mode = "x", keys = "`" },
		{ mode = "n", keys = '"' }, { mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" }, { mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" }, { mode = "x", keys = "z" },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.marks(),
		clue.gen_clues.registers(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
		{ mode = "n", keys = "<Leader>f", desc = "[F]ind..." },
		{ mode = "n", keys = "<Leader>s", desc = "[S]ource..." },
		{ mode = "n", keys = "<Leader>l", desc = "[L]sp..." },
		{ mode = "n", keys = "<Leader>?", desc = "[?] Explore keymaps" },
	},
})
