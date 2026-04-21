vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "v0.10.0" },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "vimdoc", "markdown", "markdown_inline" },
	auto_install = true,
	highlight = {
		enable = true,
		disable = function(_, buf)
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			return ok and stats and stats.size > 100 * 1024
		end,
		additional_vim_regex_highlighting = false,
	},
})
