vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.api.nvim_create_user_command("ReloadMyConfig", function()
	for name, _ in pairs(package.loaded) do
		if name:find("^" .. "trironkk") == 1 then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
end, {})

vim.keymap.set("n", "<leader>sv", ":ReloadMyConfig<CR>", { desc = "[S]ource [V]im config" })

local function toggle_raw_view()
	if vim.o.relativenumber then
		-- Disable line numbers and other gutters
		vim.opt.relativenumber = false
		vim.opt.number = false
		vim.opt.wrap = true
		vim.opt.list = false
		vim.opt.signcolumn = "no"
		vim.diagnostic.enable(false)
		vim.diagnostic.hide()
		vim.opt.list = false
	else
		-- Enable line numbers and other gutters
		vim.opt.relativenumber = true
		vim.opt.number = true
		vim.opt.wrap = false
		vim.opt.list = true
		vim.opt.signcolumn = "yes"
		vim.diagnostic.enable(true)
		vim.diagnostic.show()
		vim.opt.list = true
		vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	end
end
vim.keymap.set("n", "<F3>", toggle_raw_view, { silent = true, noremap = true, desc = "Toggle Raw View" })

local function toggle_showcase_view()
	local minianimate = require("mini.animate")
	local screenkey = require("screenkey")
	local smear_cursor = require("smear_cursor")
	if minianimate.is_active then
		-- Disable animations
		vim.g.minianimate_disable = true
		if screenkey.is_active() then
			screenkey.toggle()
		end
		smear_cursor.enabled = false
	else
		-- Enable animations
		vim.g.minianimate_disable = false
		if not screenkey.is_active() then
			screenkey.toggle()
		end
		smear_cursor.enabled = true
	end
end
vim.keymap.set("n", "<F12>", toggle_showcase_view, { silent = true, noremap = true, desc = "Toggle Showcase View" })

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local success, _ = pcall(require, "trironkk.google")
if success == false then
	vim.notify_once("Warning: Could not load 'trironkk.google'.", vim.log.levels.INFO,
		{ title = "Neovim Config Load" })
end

require("trironkk.opt")
require("trironkk.plugins.blink")
require("trironkk.plugins.oil")
require("trironkk.plugins.mini_animate")
require("trironkk.plugins.mini_clue")
require("trironkk.plugins.mini_diff")
require("trironkk.plugins.mini_icons")
require("trironkk.plugins.mini_pick")
require("trironkk.plugins.tokyonight")
require("trironkk.plugins.treesitter")
require("trironkk.plugins.screenkey")
require("trironkk.plugins.smear_cursor")

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server",
		"kotlin-language-server",
	},
})
require("lazydev").setup({
	library = {
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
require("fidget").setup({})

local on_attach = function(client, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })

	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "[L]sp [R]ename" })
	vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "[L]sp [C]ode [A]ction" })

	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = require('blink.cmp').get_lsp_capabilities(),
	filetypes = { "lua" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				ignoreDir = { "undo", "spell", "backups", ".git" },
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME .. "/lua" },
			},
			telemetry = { enable = false },
			hover = {
				expandAlias = true,
				previewLines = 20,
			},
		},
	},
})
vim.lsp.config("kotlin_language_server", {
	on_attach = on_attach,
	capabilities = require('blink.cmp').get_lsp_capabilities(),
	root_markers = { ".git", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml" },
	settings = {
		kotlin = {
			gradle = {
				enabled = true,
			},
			externalDestinations = { enabled = true },
			downloadSources = true,
			updateCheck = { enabled = true },
		},
	},
	init_options = {
		storagePath = vim.fn.stdpath("cache") .. "/kotlin_lsp",
		includeScripts = true,
		autoIndex = true,
	},
})

vim.lsp.enable("kotlin_language_server")

vim.lsp.enable({ "lua_ls", "kotlin_language_server" })

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Custom prefix symbol
		format = function(diagnostic)
			return string.format([[ %s: %s ]], diagnostic.source, diagnostic.message)
		end,
	},
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "[L]sp [F]ormat" })

vim.keymap.set("n", "<leader>ld", function()
	vim.diagnostic.open_float(nil, { scope = "cursor" })
end, { desc = "[L]sp [D]iagnostics" })
vim.keymap.set("n", "<leader>li", function()
	-- Close open :LspInfo buffers before opening a new one.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "lspinfo" then
			vim.api.nvim_win_close(win, true)
		end
	end
	-- Open a fresh copy
	vim.cmd("LspInfo")
end, { desc = "[L]sp [I]nfo" })
vim.keymap.set("n", "<leader>ll", function()
	-- Close open :LspLog buffers before opening a new one.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "lsplog" then
			vim.api.nvim_win_close(win, true)
		end
	end
	-- Open a fresh copy
	vim.cmd("LspLog")
end, { desc = "[L]sp [L]og" })
