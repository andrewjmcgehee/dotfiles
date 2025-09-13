return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = { nerd_font_variant = "mono" },
			cmdline = {
				completion = {
					menu = { auto_show = true },
					list = { selection = { preselect = true, auto_insert = true } },
					ghost_text = { enabled = true },
				},
				keymap = {
					preset = "none",
					["<right>"] = { "accept", "fallback" },
					["<left>"] = { "cancel", "fallback" },
					["<esc>"] = { "cancel", "fallback" },
					["<tab>"] = { "show", "accept", "fallback" },
					["<up>"] = { "select_prev", "fallback" },
					["<down>"] = { "select_next", "fallback" },
				},
			},
			completion = {
				accept = { auto_brackets = { enabled = false } },
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				ghost_text = { enabled = true },
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				menu = {
					draw = {
						-- TODO: revisit this once stable
						--
						-- columns = {
						-- 	{ "label", "source_name", gap = 1 },
						-- 	{ "kind_icon", "kind", gap = 1 },
						-- },
						-- components = {
						-- 	kind_icon = {
						-- 		text = function(ctx)
						-- 			local icon = ctx.kind_icon
						-- 			local dev_icon, _ = icons.get_icon(ctx.label)
						-- 			if dev_icon then
						-- 				icon = dev_icon
						-- 			end
						-- 			return icon .. ctx.icon_gap
						-- 		end,
						-- 		highlight = function(ctx)
						-- 			local hl = ctx.kind_hl
						-- 			if vim.tbl_contains({ "Path" }, ctx.source_name) then
						-- 				local dev_icon, dev_hl = icons.get_icon(ctx.label)
						-- 				if dev_icon then
						-- 					hl = dev_hl
						-- 				end
						-- 			end
						-- 			return hl
						-- 		end,
						-- 	},
						-- 	label_description = { width = { max = 50 } },
						-- },
						treesitter = { "lsp" },
					},
				},
			},
			fuzzy = { implementation = "prefer_rust" },
			keymap = {
				preset = "none",
				["<tab>"] = { "accept", "snippet_forward", "fallback" },
				["<s-tab>"] = { "snippet_backward", "fallback" },
				["<up>"] = { "select_prev", "fallback" },
				["<down>"] = { "select_next", "fallback" },
				["<left>"] = { "hide", "fallback" },
			},
			signature = { enabled = true },
			snippets = {
				-- expand = function(snippet, _)
				-- 	return Zim.cmp.expand(snippet)
				-- end,
			},
			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				default = { "lsp", "path", "snippets", "buffer", "cmdline" },
				providers = {
					cmdline = {
						min_keyword_length = function(ctx)
							if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
								return 2
							end
							return 0
						end,
					},
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						score_offset = 95,
					},
					snippets = {
						name = "snippets",
						enabled = true,
						module = "blink.cmp.sources.snippets",
						min_keyword_length = 2,
						score_offset = 90,
						max_items = 3,
					},
				},
			},
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			-- local enabled = opts.sources.default
			-- for _, source in ipairs(opts.sources.compat or {}) do
			-- 	opts.sources.providers[source] = vim.tbl_deep_extend(
			-- 		"force",
			-- 		{ name = source, module = "blink.compat.source" },
			-- 		opts.sources.providers[source] or {}
			-- 	)
			-- 	if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
			-- 		table.insert(enabled, source)
			-- 	end
			-- end

			-- add ai_accept to <Tab> key
			-- if not opts.keymap["<Tab>"] then
			-- 	if opts.keymap.preset == "super-tab" then -- super-tab
			-- 		opts.keymap["<Tab>"] = {
			-- 			require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
			-- 			LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
			-- 			"fallback",
			-- 		}
			-- 	else -- other presets
			-- 		opts.keymap["<Tab>"] = {
			-- 			LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
			-- 			"fallback",
			-- 		}
			-- 	end
			-- end

			-- Unset custom prop to pass blink.cmp validation
			opts.sources.compat = nil
			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1

					CompletionItemKind[kind_idx] = provider.kind
					---@diagnostic disable-next-line: no-unknown
					CompletionItemKind[provider.kind] = kind_idx

					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = kind_idx or item.kind
							item.kind_icon = Zim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
						end
						return items
					end

					-- Unset custom prop to pass blink.cmp validation
					provider.kind = nil
				end
			end
			opts.appearance = opts.appearance or {}
			opts.appearance.kind_icons =
				vim.tbl_extend("force", opts.appearance.kind_icons or {}, Zim.config.icons.kinds)
			require("blink.cmp").setup(opts)
		end,
	},
}
