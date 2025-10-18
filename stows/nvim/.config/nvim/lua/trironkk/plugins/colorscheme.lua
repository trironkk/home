return {
	"catppuccin/nvim",
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
	transparent_background = true,
	float = {
		transparent = true,
	},
}
