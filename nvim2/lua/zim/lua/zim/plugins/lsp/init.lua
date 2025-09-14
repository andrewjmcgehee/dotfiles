-- TODO: maybe merge keymaps and make this a single file

return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {},
		opts = function()
			---@class PluginLspOpts
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					severity_sort = true,
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = Zim.config.icons.diagnostics.Error,
							[vim.diagnostic.severity.WARN] = Zim.config.icons.diagnostics.Warn,
							[vim.diagnostic.severity.HINT] = Zim.config.icons.diagnostics.Hint,
							[vim.diagnostic.severity.INFO] = Zim.config.icons.diagnostics.Info,
						},
					},
				},
				inlay_hints = {
					enabled = true,
					exclude = { "vue" },
				},
				codelens = { enabled = false },
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
				format = {
					formatting_options = nil,
					timeout_ms = nil,
				},
				-- lsp server settings
				servers = {
					-- docker
					dockerls = {},
					-- docker-compose
					docker_compose_language_service = {},
					-- go
					gopls = {
						settings = {
							gopls = {
								gofumpt = true,
								codelenses = {
									gc_details = false,
									generate = true,
									regenerate_cgo = true,
									run_govulncheck = true,
									test = true,
									tidy = true,
									upgrade_dependency = true,
									vendor = true,
								},
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									compositeLiteralTypes = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
								analyses = {
									nilness = true,
									unusedparams = true,
									unusedwrite = true,
									useany = true,
								},
								usePlaceholders = true,
								completeUnimported = true,
								staticcheck = true,
								directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
								semanticTokens = true,
							},
						},
					},
					-- lua
					lua_ls = {
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					},
					-- markdown
					marksman = {},
					-- prisma
					prismals = {},
					-- python
					basedpyright = {},
					ruff = {},
					-- tailwind
					tailwindcss = {
						filetypes_exclude = { "markdown" },
					},
					-- terraform
					terraformls = {},
					-- typescript
					vtsls = {
						-- explicitly add default filetypes, so that we can extend
						-- them in related extras
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
						},
						settings = {
							complete_function_calls = true,
							vtsls = {
								enableMoveToFileCodeAction = true,
								autoUseWorkspaceTsdk = true,
								experimental = {
									maxInlayHintLength = 30,
									completion = {
										enableServerSideFuzzyMatch = true,
									},
								},
							},
							typescript = {
								updateImportsOnFileMove = { enabled = "always" },
								suggest = {
									completeFunctionCalls = true,
								},
								inlayHints = {
									enumMemberValues = { enabled = true },
									functionLikeReturnTypes = { enabled = true },
									parameterNames = { enabled = "literals" },
									parameterTypes = { enabled = true },
									propertyDeclarationTypes = { enabled = true },
									variableTypes = { enabled = false },
								},
							},
						},
						keys = {
							{
								"gD",
								function()
									local params = vim.lsp.util.make_position_params()
									Zim.lsp.execute({
										command = "typescript.goToSourceDefinition",
										arguments = { params.textDocument.uri, params.position },
										open = true,
									})
								end,
								desc = "Goto Source Definition",
							},
							{
								"gR",
								function()
									Zim.lsp.execute({
										command = "typescript.findAllFileReferences",
										arguments = { vim.uri_from_bufnr(0) },
										open = true,
									})
								end,
								desc = "File References",
							},
							{
								"<leader>co",
								Zim.lsp.action["source.organizeImports"],
								desc = "Organize Imports",
							},
							{
								"<leader>cM",
								Zim.lsp.action["source.addMissingImports.ts"],
								desc = "Add missing imports",
							},
							{
								"<leader>cu",
								Zim.lsp.action["source.removeUnused.ts"],
								desc = "Remove unused imports",
							},
							{
								"<leader>cD",
								Zim.lsp.action["source.fixAll.ts"],
								desc = "Fix all diagnostics",
							},
							{
								"<leader>cV",
								function()
									Zim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
								end,
								desc = "Select TS workspace version",
							},
						},
					},
					-- yaml
					yamlls = {
						-- have to add this for yamlls to understand that we support line folding
						capabilities = {
							textDocument = {
								foldingRange = {
									dynamicRegistration = false,
									lineFoldingOnly = true,
								},
							},
						},
						-- lazy-load schemastore when needed
						-- on_new_config = function(new_config)
						-- 	new_config.settings.yaml.schemas = vim.tbl_deep_extend(
						-- 		"force",
						-- 		new_config.settings.yaml.schemas or {},
						-- 		require("schemastore").yaml.schemas()
						-- 	)
						-- end,
						settings = {
							redhat = { telemetry = { enabled = false } },
							yaml = {
								keyOrdering = false,
								format = {
									enable = true,
								},
								validate = true,
								schemaStore = {
									-- disable in favor or schemastore.nvim
									enable = false,
									-- avoid typeerror: cannot read properties of undefined (reading 'length')
									url = "",
								},
							},
						},
					},
				},
				setup = {
					gopls = function(_, _)
						Zim.lsp.on_attach(function(client, _)
							if not client.server_capabilities.semanticTokensProvider then
								local semantic = client.config.capabilities.textDocument.semanticTokens
								client.server_capabilities.semanticTokensProvider = {
									full = true,
									legend = {
										tokenTypes = semantic.tokenTypes,
										tokenModifiers = semantic.tokenModifiers,
									},
									range = true,
								}
							end
						end, "gopls")
					end,
					ruff = function()
						Zim.lsp.on_attach(function(client, _)
							client.server_capabilities.hoverProvider = false
						end)
					end,
					tailwindcss = function(_, opts)
						local tw = Zim.lsp.get_raw_config("tailwindcss")
						opts.filetypes = opts.filetypes or {}
						-- add default file types
						vim.list_extend(opts.filetypes, tw.default_config.filetypes)
						-- exclude user file types
						opts.filetypes = vim.tbl_filter(function(ft)
							return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
						end, opts.filetypes)
					end,
					vtsls = function(_, opts)
						Zim.lsp.on_attach(function(client, buffer)
							client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
								---@type string, string, lsp.Range
								local action, uri, range = unpack(command.arguments)

								local function move(newf)
									client.request("workspace/executeCommand", {
										command = command.command,
										arguments = { action, uri, range, newf },
									})
								end

								local fname = vim.uri_to_fname(uri)
								client.request("workspace/executeCommand", {
									command = "typescript.tsserverRequest",
									arguments = {
										"getMoveToRefactoringFileSuggestions",
										{
											file = fname,
											startLine = range.start.line + 1,
											startOffset = range.start.character + 1,
											endLine = range["end"].line + 1,
											endOffset = range["end"].character + 1,
										},
									},
								}, function(_, result)
									---@type string[]
									local files = result.body.files
									table.insert(files, 1, "Enter new path...")
									vim.ui.select(files, {
										prompt = "Select move destination:",
										format_item = function(f)
											return vim.fn.fnamemodify(f, ":~:.")
										end,
									}, function(f)
										if f and f:find("^Enter new path") then
											vim.ui.input({
												prompt = "Enter move destination:",
												default = vim.fn.fnamemodify(fname, ":h") .. "/",
												completion = "file",
											}, function(newf)
												return newf and move(newf)
											end)
										elseif f then
											move(f)
										end
									end)
								end)
							end
						end, "vtsls")
						-- copy typescript settings to javascript
						opts.settings.javascript =
							vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
					end,
				},
			}
			return ret
		end,
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- setup autoformat
			-- Zim.format.register(Zim.lsp.formatter())
			-- setup keymaps
			Zim.lsp.on_attach(function(client, buffer)
				require("zim.plugins.lsp.keymaps").on_attach(client, buffer)
			end)
			Zim.lsp.setup()
			Zim.lsp.on_dynamic_capability(require("zim.plugins.lsp.keymaps").on_attach)
			-- inlay hints
			if opts.inlay_hints.enabled then
				Zim.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end
			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				Zim.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
			-- extend server capabilities with blink capabilities
			local servers = opts.servers
			local blink = require("blink.cmp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				blink.get_lsp_capabilities() or {},
				opts.capabilities or {}
			)
			-- manual server setup function
			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if server_opts.enabled == false then
					return
				end
				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end
			-- setup each server specified in the opts
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						setup(server)
					end
				end
			end
		end,
	},
}
