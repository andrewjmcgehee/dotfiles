local icons = require("icons")

return {
  "saghen/blink.cmp",
  version = "1.*",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  dependencies = { "rafamadriz/friendly-snippets" },
  event = { "InsertEnter", "CmdlineEnter" },
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
      ["<right>"] = { "accept", "snippet_forward", "fallback" },
      ["<left>"] = { "hide", "fallback" },
      ["<tab>"] = { "accept", "snippet_forward", "fallback" },
      ["<s-tab>"] = { "snippet_backward", "fallback" },
      ["<up>"] = { "select_prev", "fallback" },
      ["<down>"] = { "select_next", "fallback" },
    },
    signature = { enabled = true },
    snippets = {
      -- expand = function(snippet, _)
      -- 	return Zim.cmp.expand(snippet)
      -- end,
    },
    sources = {
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
  config = function(_, opts)
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
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, icons.kinds)
    require("blink.cmp").setup(opts)
  end,
}
