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
  config = function(opts)
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          -- replace newline and tab characters with space for more compact diagnostics
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, vim.api.nvim_create_namespace("neotest"))
    if LazyVim.has("trouble.nvim") then
      opts.consumers = opts.consumers or {}
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))
          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == "failed" and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require("trouble")
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
          return {}
        end
      end
    end
    opts.adapters = {
      require("neotest-bun"),
      require("neotest-golang"),
      require("neotest-jest"),
      require("neotest-playwright").adapter({}),
      require("neotest-python")({
        args = { "-vvv" },
      }),
      require("neotest-rust"),
      require("neotest-vitest"),
    }
    require("neotest").setup(opts)
  end,
}
