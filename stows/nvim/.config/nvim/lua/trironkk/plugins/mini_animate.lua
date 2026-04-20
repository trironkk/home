vim.pack.add({ { src = "https://github.com/nvim-mini/mini.animate" } })

local animate = require("mini.animate")
animate.setup({
	cursor = { enabled = false }, -- use smear_cursor
	scroll = { timing = animate.gen_timing.linear({ duration = 50, unit = "total" }) },
	open = { enabled = false },
	closed = { enabled = false },
})
