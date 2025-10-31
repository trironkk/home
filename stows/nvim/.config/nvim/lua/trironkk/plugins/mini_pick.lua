vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pick" },
})
local minipick = require('mini.pick')
minipick.setup( -- No need to copy this inside `setup()`. Will be used automatically.
	{
		-- Delays (in ms; should be at least 1)
		delay = {
			-- Delay between forcing asynchronous behavior
			async = 10,

			-- Delay between computation start and visual feedback about it
			busy = 50,
		},

		-- Keys for performing actions. See `:h MiniPick-actions`.
		mappings = {
			caret_left        = '<Left>',
			caret_right       = '<Right>',

			choose            = '<CR>',
			choose_in_split   = '<C-s>',
			choose_in_tabpage = '<C-t>',
			choose_in_vsplit  = '<C-v>',
			choose_marked     = '<M-CR>',

			delete_char       = '<BS>',
			delete_char_right = '<Del>',
			delete_left       = '<C-u>',
			delete_word       = '<C-w>',

			mark              = '<C-x>',
			mark_all          = '<C-a>',

			move_down         = '<C-n>',
			move_start        = '<C-g>',
			move_up           = '<C-p>',

			paste             = '<C-r>',

			refine            = '<C-Space>',
			refine_marked     = '<M-Space>',

			scroll_down       = '<C-f>',
			scroll_left       = '<C-h>',
			scroll_right      = '<C-l>',
			scroll_up         = '<C-b>',

			stop              = '<Esc>',

			toggle_info       = '<S-Tab>',
			toggle_preview    = '<Tab>',
		},

		-- General options
		options = {
			-- Whether to show content from bottom to top
			content_from_bottom = false,

			-- Whether to cache matches (more speed and memory on repeated prompts)
			use_cache = false,
		},

		-- Source definition. See `:h MiniPick-source`.
		source = {
			items         = nil,
			name          = nil,
			cwd           = nil,

			match         = nil,
			show          = nil,
			preview       = nil,

			choose        = nil,
			choose_marked = nil,
		},

		-- Window related options
		window = {
			-- Float window config (table or callable returning it)
			config = nil,

			-- String to use as caret in prompt
			prompt_caret = '▏',

			-- String to use as prefix in prompt
			prompt_prefix = '> ',
		},
	})

-- Common Functions
local get_current_buffer_dir = function()
	if vim.bo.filetype == 'oil' then
		return vim.fs.dirname(require('oil').get_current_dir())
	end

	local buffer_name = vim.api.nvim_buf_get_name(0)

	if buffer_name == '' then
		-- For temporary buffers, fall back to the current working directory.
		return vim.fn.getcwd()
	end

	return vim.fs.dirname(buffer_name)
end


-- Find files
vim.keymap.set("n", "<leader>ff", function()
	require("mini.pick").builtin.cli({
		command = { "rg", "--files", "--follow", vim.fn.fnamemodify(get_current_buffer_dir(), ":.") },
	}
	)
end, { desc = "Find [F]iles in parent directory" })

-- Find vim configs
vim.keymap.set("n", "<leader>fv", function()
	require("mini.pick").builtin.cli({
		command = { "rg", "--files", "--follow", vim.fs.dirname(vim.env.MYVIMRC) },
	}
	)
end, { desc = "Find [V]im config files" })

-- Find keymaps
local function get_all_keymaps_source()
	local items = {}
	for _, mode in ipairs({ 'n', 'i', 'v', 'x', 's', 'o', 'l', 'c', 't' }) do
		local maps = vim.api.nvim_get_keymap(mode)
		for _, map in ipairs(maps) do
			if map.rhs and map.rhs ~= '' and map.silent ~= true then
				table.insert(items, {
					text = string.format('[%s] %-40s -> %s', mode, map.lhs,
						map.desc or 'No description'),
					value = map,
				})
			end
		end
	end
	table.sort(items, function(a, b) return a.text < b.text end)
	return { items = items, name = 'Keymaps', prompt = 'Search Mappings:' }
end

local _centered_window = function()
	local height = math.floor(0.618 * vim.o.lines)
	local width = math.floor(0.618 * vim.o.columns)
	return {
		anchor = 'NW',
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(0.5 * (vim.o.columns - width)),
		border = 'double',
	}
end
local function show_keymaps_picker()
	minipick.start({
		source = get_all_keymaps_source(),
		window = { config = _centered_window },
		action = function(item)
			vim.notify('Keys: ' .. item.value.lhs .. ', Maps to: ' .. item.value.rhs)
		end,
	})
end
vim.keymap.set('n', '<leader>?', show_keymaps_picker, { desc = 'Pick keymaps' })
