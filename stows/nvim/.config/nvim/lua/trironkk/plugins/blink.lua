vim.pack.add({
	{ src="https://github.com/Saghen/blink.cmp", version = "v1.7.0"},
})
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" }
})
