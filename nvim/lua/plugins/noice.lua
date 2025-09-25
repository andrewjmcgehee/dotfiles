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
      {
        filter = {
          event = "msg_show",
          find = "lines",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          any = {
            { find = "No code actions" },
            { find = "_typescript.didOrganizeImports" },
          },
        },
        opts = { skip = true },
      },
    },
  },
}
