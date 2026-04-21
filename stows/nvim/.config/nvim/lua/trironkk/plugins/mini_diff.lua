vim.pack.add({ { src = "https://github.com/nvim-mini/mini.diff" } })

local diff = require("mini.diff")
diff.setup({
	source = { diff.gen_source.git(), diff.gen_source.save() },
	view = { signs = { add = "▒", change = "▒", delete = "▒" } },
	options = { algorithm = "histogram", indent_heuristic = true, linematch = 60 },
})

vim.keymap.set("n", "<leader><F11>", function() diff.toggle_overlay() end,
	{ desc = "Toggle MiniDiff overlay" })
