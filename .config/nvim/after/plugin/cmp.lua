local cmp = require("cmp")
local compare = require("cmp.config.compare")
local luasnip = require("luasnip")

local icons = {
	Array = "󰅪",
	Boolean = "",
	Class = "󰠱",
	Color = "󰏘",
	Constant = "",
	Constructor = "",
	Default = " ",
	Enum = "󰅩",
	EnumMember = "󰈍",
	Event = "󰂚",
	Field = "󰓹",
	File = "󰈙",
	Folder = "󰉋",
	Function = "󰊕",
	Interface = "󰠱",
	Key = "󰌋",
	Keyword = "󰌋",
	Method = "󰆧",
	Module = "",
	Namespace = "",
	Null = "󰟢",
	Number = "󰎠",
	Object = "󰠱",
	Operator = "󰇔",
	Package = "",
	Property = "󰓹",
	Reference = "",
	Snippet = "",
	String = "󰊄",
	Struct = "󰅩",
	Text = "󰊄",
	TypeParameter = "󰅲",
	Unit = "",
	Value = "󱀍",
	Variable = "󰀫",
}

local py_score = function(text)
	local is_private = string.match(text, "^_[^_]+")
	local is_salted = string.match(text, "^__[^_].*[^__]$")
	local is_dunder = string.match(text, "^__.*__$")
	local score = 1
	if is_private then
		score = 2
	elseif is_dunder then
		score = 3
	elseif is_salted then
		score = 4
	end
	return score
end

local py_privacy = function(e1, e2)
	return py_score(e1.completion_item.label) < py_score(e2.completion_item.label)
end

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end),
		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local source_abbrev = {
				nvim_lua = "[lua]",
				nvim_lsp = "[lsp]",
				buffer = "[buff]",
				path = "[path]",
				luasnip = "[snip]",
			}
			vim_item.kind = " " .. (icons[vim_item.kind] or "") .. " "
			vim_item.menu = source_abbrev[entry.source.name]
			vim_item.dup = false
			return vim_item
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{ name = "path" },
		{ name = "nvim_lua" },
	},
	window = {
		completion = cmp.config.window.bordered({
			border = "none",
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuThumb,Search:None",
			side_padding = 0,
			col_offset = -3,
		}),
		documentation = cmp.config.window.bordered(),
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			compare.offset,
			compare.exact,
			compare.score,
			compare.recently_used,
			compare.locality,
			py_privacy,
			compare.kind,
			compare.length,
			compare.order,
		},
	},
})
