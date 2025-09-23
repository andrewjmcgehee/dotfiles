local repo_pattern = "https://github.com/(.*)"

return {
  "snacks.nvim",
  keys = {
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "notifications",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "dismiss notifications",
    },
  },
  opts = {
    dashboard = {
      row = 8,
      preset = {
        header = nil,
        keys = {
          { icon = " ", key = "f", desc = "files", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "c",
            desc = "config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy" },
          { icon = " ", key = "x", desc = "extras", action = ":LazyExtras" },
          { icon = " ", key = "q", desc = "quit", action = ":qa" },
        },
      },
      sections = {
        { section = "keys", padding = 1 },
        { section = "projects", title = "projects", indent = 2, padding = 1, limit = 5 },
        { section = "recent_files", title = "recents", indent = 2, padding = 1, limit = 5 },
        { section = "startup" },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local wide_enough = vim.opt.columns:get() >= 100
          local remote = io.popen("git remote get-url --all origin"):read("*l")
          local title = "browse repo"
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
              title = "notifications",
              cmd = "gh-notifications",
              icon = " ",
              key = "n",
              height = 5,
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
            },
            {
              title = "issues",
              cmd = "gh-issues",
              icon = " ",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              height = 5,
            },
            {
              title = "prs",
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
              enabled = in_git and wide_enough,
              padding = 1,
              ttl = 60, -- 1 minute
              indent = 3,
            }, cmd)
          end, cmds)
        end,
      },
    },
  },
}
