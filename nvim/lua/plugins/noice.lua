return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      -- skip msg_show patterns
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+.*lines" },
          },
        },
        opts = { skip = true },
      },
      -- skip notify patterns
      {
        filter = {
          event = "notify",
          any = {
            { find = "No code actions" },
          },
        },
        opts = { skip = true },
      },
    },
  },
}
