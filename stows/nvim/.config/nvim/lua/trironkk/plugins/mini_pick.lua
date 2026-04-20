vim.pack.add({ { src = "https://github.com/nvim-mini/mini.pick" } })

local pick = require("mini.pick")
pick.setup({
	window = { prompt_caret = "▏", prompt_prefix = "> " },
})

local function buffer_dir()
	if vim.bo.filetype == "oil" then
		return vim.fs.dirname(require("oil").get_current_dir())
	end
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then return vim.fn.getcwd() end
	return vim.fs.dirname(name)
end

vim.keymap.set("n", "<leader>ff", function()
	pick.builtin.cli({
		command = { "rg", "--files", "--follow", vim.fn.fnamemodify(buffer_dir(), ":.") },
	})
end, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>fv", function()
	pick.builtin.cli({
		command = { "rg", "--files", "--follow", vim.fs.dirname(vim.env.MYVIMRC) },
	})
end, { desc = "[F]ind [V]im config" })

vim.keymap.set("n", "<leader>fr", function()
	pick.start({ source = { items = vim.v.oldfiles, name = "Recent Files" } })
end, { desc = "[F]ind [R]ecent files" })

vim.keymap.set("n", "<leader>?", function()
	local items = {}
	for _, mode in ipairs({ "n", "i", "v", "x", "s", "o", "l", "c", "t" }) do
		for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
			if m.rhs and m.rhs ~= "" and m.silent ~= true then
				table.insert(items, {
					text = string.format("[%s] %-40s -> %s", mode, m.lhs, m.desc or ""),
					value = m,
				})
			end
		end
	end
	table.sort(items, function(a, b) return a.text < b.text end)
	pick.start({
		source = { items = items, name = "Keymaps" },
		window = { config = function()
			local h = math.floor(0.618 * vim.o.lines)
			local w = math.floor(0.618 * vim.o.columns)
			return {
				anchor = "NW", height = h, width = w,
				row = math.floor(0.5 * (vim.o.lines - h)),
				col = math.floor(0.5 * (vim.o.columns - w)),
				border = "double",
			}
		end },
	})
end, { desc = "Pick keymaps" })
