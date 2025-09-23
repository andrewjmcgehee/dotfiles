return {
  "folke/flash.nvim",
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    -- simulate nvim-treesitter incremental selection
    {
      "<space>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<space>"] = "next",
            ["<bs>"] = "prev",
          },
        })
      end,
      desc = "Treesitter Incremental Selection",
    },
  },
}
