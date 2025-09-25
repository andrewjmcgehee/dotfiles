return {
  "andrewjmcgehee/curl.nvim",
  cmd = { "CurlOpen" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  opts = {
    default_flags = {},
    open_with = "buffer",
  },
  keys = {
    {
      "<leader>ra",
      function()
        require("curl").create_global_collection()
      end,
      desc = "Add Rest File",
    },
    {
      "<leader>rd",
      function()
        require("curl").delete_global_collection()
      end,
      desc = "Delete Rest File",
    },
    {
      "<leader>ro",
      function()
        require("curl").pick_global_collection()
      end,
      desc = "Open Rest Collections",
    },
  },
}
