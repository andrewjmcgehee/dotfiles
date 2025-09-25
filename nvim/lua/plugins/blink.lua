return {
  "saghen/blink.cmp",
  opts = function()
    return {
      appearance = { nerd_font_variant = "mono", kind_icons = LazyVim.config.icons.kinds },
      cmdline = {
        enabled = true,
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = true, auto_insert = true } },
          ghost_text = { enabled = true },
        },
        keymap = {
          preset = "none",
          ["<right>"] = { "show", "accept", "fallback" },
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
            treesitter = { "lsp" },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust" },
      keymap = {
        preset = "super-tab",
        ["<right>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
        ["<left>"] = { "hide", "fallback" },
      },
      signature = { enabled = true },
      snippets = {
        expand = function(snippet, _)
          return LazyVim.cmp.expand(snippet)
        end,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "cmdline" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 2
              end
              return 0
            end,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
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
    }
  end,
}
