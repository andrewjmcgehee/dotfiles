local repo_pattern = "https://github.com/(.*)"

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>n", false },
    {
      "<leader>N",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notifications",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss Notifications",
    },
    { "<leader>fe", false },
    { "<leader>fE", false },
    {
      "<leader>e",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Explorer",
    },
    { "<leader>E", false },
  },
  opts = {
    dashboard = {
      row = 8,
      preset = {
        header = nil,
        keys = {
          { icon = " ", key = "f", desc = "Files", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "x", desc = "Extras", action = ":LazyExtras" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "keys", padding = 1 },
        { section = "projects", title = "Projects", indent = 2, padding = 1, limit = 5 },
        { section = "recent_files", title = "Recents", indent = 2, padding = 1, limit = 5 },
        { section = "startup" },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local remote = io.popen("git remote get-url --push origin 2>/dev/null"):read("*l")
          local title = "Browse Repo"
          if remote then
            title = title .. " (" .. remote:match(repo_pattern) .. ")"
          end
          local cmds = {
            {
              icon = " ",
              title = title,
              cmd = "",
              height = 1,
              padding = 0,
              key = "b",
              action = function()
                Snacks.gitbrowse()
              end,
            },
            {
              title = "Notifications",
              cmd = "gh-notifications",
              icon = " ",
              key = "n",
              height = 5,
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
            },
            {
              title = "Issues",
              cmd = "gh-issues",
              icon = " ",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              height = 5,
            },
            {
              title = "PRs",
              cmd = "gh-prs",
              icon = " ",
              key = "p",
              height = 5,
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              indent = 3,
              ttl = 0,
            }, cmd)
          end, cmds)
        end,
      },
    },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          jump = { close = false },
          layout = { preset = "default", preview = true },
          win = {
            list = {
              keys = {
                ["<left>"] = "explorer_up",
                ["<right>"] = "confirm",
                ["a"] = "explorer_add",
                ["d"] = "explorer_del",
                ["m"] = "explorer_move",
                ["y"] = { "explorer_yank", mode = { "n", "x" } },
                ["p"] = "explorer_paste",
                ["u"] = "explorer_update",
                ["<c-c>"] = "tcd",
                ["I"] = "toggle_ignored",
                ["H"] = "toggle_hidden",
                ["Z"] = "explorer_close_all",
                ["]g"] = "explorer_git_next",
                ["[g"] = "explorer_git_prev",
                ["]d"] = "explorer_diagnostic_next",
                ["[d"] = "explorer_diagnostic_prev",
                ["]w"] = "explorer_warn_next",
                ["[w"] = "explorer_warn_prev",
                ["]e"] = "explorer_error_next",
                ["[e"] = "explorer_error_prev",
                -- unset
                ["<BS>"] = false,
                ["l"] = false,
                ["h"] = false,
                ["r"] = false,
                ["c"] = false,
                ["o"] = false,
                ["P"] = false,
                ["<leader>/"] = false,
                ["<c-t>"] = false,
                ["."] = false,
              },
            },
          },
        },
      },
    },
  },
}
