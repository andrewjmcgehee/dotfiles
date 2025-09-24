return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = function(_, opts)
    -- opts as a function overwrites lazyvim opts completely
    opts.icons = {
      rules = {
        { pattern = "^help$", icon = LazyVim.config.icons.diagnostics.Hint, color = "green" },
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
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
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
    {
      "<leader>h",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Help",
    },
    { "<leader>?", false },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
