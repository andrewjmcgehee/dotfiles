local api = vim.api
local buf = vim.lsp.buf
local km = vim.keymap

-- shorten diagnostic message inline
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		format = function(diagnostic)
			if string.len(diagnostic.message) >= 40 then
				return string.sub(diagnostic.message, 1, 40) .. "..."
			end
			return diagnostic.message
		end,
	},
})
-- mason
require("mason").setup({})
require("mason-lspconfig").setup()
-- lspconfig
local lspconfig = require("lspconfig")
local defaults = lspconfig.util.default_config
defaults.capabilities =
	vim.tbl_deep_extend("force", defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
-- general lsp commands
local on_attach = function(e)
	local opts = { buffer = e.buf }
	local diagnostic = vim.diagnostic
	km.set("n", "gd", buf.definition, opts)
	km.set("n", "K", buf.hover, opts)
	km.set("n", "[d", diagnostic.goto_prev, opts)
	km.set("n", "]d", diagnostic.goto_next, opts)
	km.set("n", "<leader>ca", buf.code_action, opts)
	km.set("n", "<leader>rn", buf.rename, opts)
	km.set("i", "<C-h>", buf.definition, opts)
end
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = on_attach,
})
-- sh
lspconfig.bashls.setup({})
-- c, c++, h
lspconfig.clangd.setup({
	filetypes = { "c", "cpp" },
})
-- css
lspconfig.cssls.setup({})
-- css, html, less, sass
local emmet_capabilities = vim.lsp.protocol.make_client_capabilities()
emmet_capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.emmet_ls.setup({
	capabilities = emmet_capabilities,
	filetypes = {
		"css",
		"less",
		"sass",
		"html",
	},
})
-- js, jsx, jsreact, ts, tsx, tsreact
lspconfig.eslint.setup({
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
})
-- go
lspconfig.gopls.setup({})
-- html
lspconfig.html.setup({})
-- java jdtls is configured elsewhere
-- py
lspconfig.jedi_language_server.setup({})
-- lua
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "use_rocks" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
-- tex
lspconfig.texlab.setup({})
-- tsserver
lspconfig.tsserver.setup({})
-- vim
lspconfig.vimls.setup({})
-- null ls
local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting
local lsp_formatting = function(bufnr)
	buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		fmt.buildifier,
		fmt.clang_format.with({
			filetypes = { "c", "cpp", "proto" },
			extra_args = { "--style", "{BasedOnStyle: Google}" },
		}),
		fmt.gofmt,
		fmt.goimports,
		fmt.google_java_format,
		fmt.isort,
		fmt.latexindent,
		fmt.prettierd,
		fmt.shfmt,
		fmt.sqlfmt,
		fmt.stylua,
		fmt.yapf,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})
