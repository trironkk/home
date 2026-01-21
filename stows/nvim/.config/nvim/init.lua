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
		screenkey.toggle(false)
		smear_cursor.enabled = false
	else
		-- Enable animations
		vim.g.minianimate_disable = false
		screenkey.toggle(true)
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

vim.lsp.config("kotlin_language_server", { enabled = false })
vim.g.lspconfig_manual_setup = 1

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
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			-- Default handler for all other servers
			require("lspconfig")[server_name].setup({ on_attach = on_attach })
		end,
		["kotlin_language_server"] = function()
			-- Do NOTHING here. This prevents the default lspconfig
			-- script from running for Kotlin.
		end,
	},
})
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"kotlin_language_server",
	},
})

require("fidget").setup({})

local on_attach = function(client, bufnr)
	-- 1. Helper for cleaner keymap definitions
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local opts = { noremap = true, silent = true }

	-- 2. Standard LSP Keymaps
	-- Jumping to definition/references
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })

	-- Actions
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })

	-- 3. Document Highlighting (Optional)
	-- Highlights the symbol under the cursor
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

	-- 4. Format on Save (Optional)
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
				},
			},
			workspace = {
				ignoreDir = { "undo", "spell", "backups", ".git" },
				library = { vim.env.VIMRUNTIME .. "/lua" },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			hover = {
				expandAlias = true,
				previewLines = 20,
			},
		},
	},
})
require("lspconfig").kotlin_language_server.setup({
	on_attach = on_attach,
	root_dir = require("lspconfig").util.root_pattern(
		"settings.gradle.kts",
		"settings.gradle",
		"build.gradle.kts",
		"build.gradle",
		".git"
	),
	on_init = function(client)
		local root = client.config.root_dir
		if root then
			-- Tell KLS to use the gradlew file found at the root
			client.config.settings.kotlin = {
				gradle = {
					enabled = true,
					-- This dynamically points KLS to the project's own wrapper
					gradlePath = root .. "/gradlew",
				},
				externalDestinations = {
					enabled = true, -- Helps with resolving libraries/URIs outside the immediate src folder
				},
			}
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
	init_options = {
		storagePath = vim.fn.stdpath("cache") .. "/kotlin_lsp",
		-- Force the server to handle build scripts
		includeScripts = true,
	},
})

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
