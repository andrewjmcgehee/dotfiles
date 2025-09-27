return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = function(_, opts)
    opts.icons = {
      rules = {
        { pattern = "rest", icon = "󰖟 ", color = "blue" },
        { pattern = "note", icon = "󰙏 ", color = "green" },
      },
    }
    return {
      preset = "helix",
      defaults = {},
      icons = opts.icons,
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "File" },
          { "<leader>g", group = "Git", icon = LazyVim.config.icons.ft.octo },
          { "<leader>o", group = "Octo", icon = LazyVim.config.icons.ft.octo },
          { "<leader>oa", group = "Assignee", icon = LazyVim.config.icons.ft.octo },
          { "<leader>oc", group = "Comment", icon = LazyVim.config.icons.ft.octo },
          { "<leader>od", group = "Discussion", icon = LazyVim.config.icons.ft.octo },
          { "<leader>oe", group = "Emoji", icon = LazyVim.config.icons.ft.octo },
          { "<leader>oi", group = "Issue", icon = LazyVim.config.icons.ft.octo },
          { "<leader>ol", group = "Label", icon = LazyVim.config.icons.ft.octo },
          { "<leader>op", group = "PR", icon = LazyVim.config.icons.ft.octo },
          { "<leader>or", group = "Review", icon = LazyVim.config.icons.ft.octo },
          { "<leader>r", group = "Rest" },
          { "<leader>s", group = "Search" },
          { "<leader>u", group = "UI" },
          { "<leader>x", group = "Quickfix" },
          { "[", group = "Prev" },
          { "]", group = "Next" },
          { "g", group = "Goto" },
          { "gs", group = "Surround" },
          { "z", group = "Fold" },
          {
            "<leader>w",
            group = "Windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with System App" },
        },
      },
    }
  end,
  keys = {
    { "<leader>?", false },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
