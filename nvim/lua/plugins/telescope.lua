return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "Buffer",
    },
    { "<leader>fc", LazyVim.pick.config_files(), desc = "Config" },
    { "<leader>ff", LazyVim.pick("files"), desc = "File" },
    { "<leader>fg", LazyVim.pick("live_grep"), desc = "Grep" },
    { "<leader>fr", "<cmd>Telescope oldfiles prompt_title=Find\\ Recent<cr>", desc = "Recent" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" }, -- reamps document diagnostics
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumps" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Opts" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Symbols",
    },
    {
      "<leader>sS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Symbols (Workspace)",
    },
    -- disabled
    { "<leader>,", false }, -- buffers
    { "<leader>/", false }, -- grep
    { "<leader>:", false }, -- command history
    { "<leader><space>", false }, -- files in root
    { "<leader>fF", false }, -- files in cwd
    { "<leader>fR", false }, -- recents in cwd
    { "<leader>gs", false }, -- git status files
    { "<leader>sb", false }, -- fuzzy search buffer
    { "<leader>sD", false }, -- was workspace diagnostics, but remapped to lowercase - shadows file level diagnostics
    { "<leader>sg", false }, -- grep root
    { "<leader>sG", false }, -- grep cwd
    { "<leader>sl", false }, -- loclist
    { "<leader>sR", false }, -- resume (don't know what this is useful for)
    { "<leader>sw", false }, -- word root
    { "<leader>sW", false }, -- word cwd
    { "<leader>sw", false }, -- selection root
    { "<leader>sW", false }, -- selection cwd
    { "<leader>uC", false }, -- colorschemese
  },
}
