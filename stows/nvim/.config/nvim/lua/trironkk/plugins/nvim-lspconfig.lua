return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim",       opts = {} },

		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		{ "folke/neodev.nvim",       opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Create a function to more easily define mappings specific for LSP related items.
				local map = function(mode, keys, func, desc)
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = { "*" },
					callback = function()
						vim.lsp.buf.format({ async = false }) -- Format with LSP
					end,
				})
				map("n", "<leader>f", vim.lsp.buf.format, "[F]ormat")

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor.
				map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("n", "gI", require("telescope.builtin").lsp_implementations,
					"[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("n", "<leader>D", require("telescope.builtin").lsp_type_definitions,
					"Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols,
					"[D]ocument [S]ymbols")

				-- Diagnostic keymaps
				map("n", "[d", vim.diagnostic.goto_prev, "Go to previous [D]iagnostic message")
				map("n", "]d", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
				map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")
				map("n", "<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")


				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap.
				map("n", "K", vim.lsp.buf.hover, "[K]eyword Documentation")
				map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
				map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup =
					    vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach",
							{ clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({
								group = "kickstart-lsp-highlight",
								buffer =
								    event2.buf
							})
						end,
					})
				end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua", -- Used to format Lua code
			}
		})
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup(opts or {})

					require("trironkk.google").setup_lsp_for_server(server_name, opts)
				end,
			},
		})
	end,
}
