return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
    "arthur944/neotest-bun",
    "fredrikaverpil/neotest-golang",
    "haydenmeade/neotest-jest",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
    "thenbe/neotest-playwright",
  },
  opts = {
    adapters = {
      ["neotest-bun"] = {},
      ["neotest-golang"] = {},
      ["neotest-jest"] = {},
      ["neotest-playwright"] = {},
      ["neotest-python"] = {
        args = { "-vvv" },
      },
      ["neotest-rust"] = {},
      ["neotest-vitest"] = {},
    },
  },
  keys = {
    { "<leader>tT", false },
    { "<leader>tr", false },
    { "<leader>t", desc = "+Test" },
    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Test File",
    },
    {
      "<leader>ta",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Test All",
    },
    {
      "<leader>tn",
      function()
        require("neotest").run.run()
      end,
      desc = "Test Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Test Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Test Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Test Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Test Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop Tests",
    },
    {
      "<leader>tw",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Toggle Test Watch",
    },
  },
}
