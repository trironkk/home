vim.pack.add({
	{ src="https://github.com/sphamba/smear-cursor.nvim" }
})
require("smear_cursor").setup({
	smear_between_buffers = true,
	enabled = false
})
