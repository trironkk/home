vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.animate" },
})
local minianimate = require('mini.animate')
require("mini.animate").setup({
    cursor = {
	    -- use smear_cursor
	    enabled = false,
    },
    scroll = {
      timing = minianimate.gen_timing.linear({ duration = 50, unit = 'total' })
    },
    open = {
	    enabled = false,
    },
    closed = {
	    enabled = false,
    },
})
