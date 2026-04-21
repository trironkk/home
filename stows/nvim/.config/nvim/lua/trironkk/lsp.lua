vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = { "lua-language-server", "kotlin-language-server" },
})
require("lazydev").setup({
	library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
})
require("fidget").setup()

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function on_attach(client, bufnr)
	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
	end
	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gr", vim.lsp.buf.references, "Go to references")
	map("K", vim.lsp.buf.hover, "Hover documentation")
	map("<leader>lr", vim.lsp.buf.rename, "[L]sp [R]ename")
	map("<leader>lca", vim.lsp.buf.code_action, "[L]sp [C]ode [A]ction")
	map("<leader>ld", function() vim.diagnostic.open_float(nil, { scope = "cursor" }) end, "[L]sp [D]iagnostics")

	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
		})
	end
end

vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME .. "/lua" } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("kotlin_language_server", {
	on_attach = on_attach,
	capabilities = capabilities,
	root_markers = { ".git", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml" },
})

vim.lsp.enable({ "lua_ls", "kotlin_language_server" })

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		format = function(d) return string.format(" %s: %s ", d.source, d.message) end,
	},
	float = { border = "rounded", source = "always" },
})
