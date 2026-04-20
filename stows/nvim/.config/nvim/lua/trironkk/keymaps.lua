local map = vim.keymap.set

map("n", "<leader>sv", function()
	for name, _ in pairs(package.loaded) do
		if name:find("^trironkk") then package.loaded[name] = nil end
	end
	dofile(vim.env.MYVIMRC)
end, { desc = "[S]ource [V]im config" })

-- Toggle distraction-free view.
local raw = false
map("n", "<F3>", function()
	raw = not raw
	vim.opt.number = not raw
	vim.opt.relativenumber = not raw
	vim.opt.wrap = raw
	vim.opt.list = not raw
	vim.opt.signcolumn = raw and "no" or "yes"
	vim.diagnostic.enable(not raw)
end, { silent = true, desc = "Toggle raw view" })

-- Toggle showcase view (animations + keystroke display).
map("n", "<F12>", function()
	local ok_anim, mini_animate = pcall(require, "mini.animate")
	local ok_key, screenkey = pcall(require, "screenkey")
	local ok_smear, smear = pcall(require, "smear_cursor")
	if not (ok_anim and ok_key and ok_smear) then return end
	local active = not vim.g.minianimate_disable
	vim.g.minianimate_disable = active
	smear.enabled = not active
	if screenkey.is_active() ~= (not active) then screenkey.toggle() end
end, { silent = true, desc = "Toggle showcase view" })

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})

-- Markdown formatting.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.formatprg = "mdformat --wrap 100 -"
		vim.opt_local.textwidth = 100
		vim.bo.formatexpr = ""
	end,
})
