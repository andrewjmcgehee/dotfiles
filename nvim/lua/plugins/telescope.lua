local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values

local function add_parsed_snippets(filepath, ft, snippets)
  if vim.fn.filereadable(filepath) == 1 then
    local ok, content = pcall(vim.fn.readfile, filepath)
    if ok then
      local json_ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
      if json_ok and type(data) == "table" then
        for name, snippet_data in pairs(data) do
          if type(snippet_data) == "table" and snippet_data.prefix then
            local prefixes = snippet_data.prefix
            if type(prefixes) == "string" then
              prefixes = { prefixes }
            end
            for _, prefix in ipairs(prefixes) do
              table.insert(snippets, {
                trigger = prefix,
                description = snippet_data.description or name,
                filetype = ft,
                body = snippet_data.body,
              })
            end
          end
        end
      end
    end
  end
end

local function get_snippets()
  local snippets = {}
  local ft = vim.bo[0].filetype
  local snippet_base = vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets/" .. ft
  local snippet_file = snippet_base .. ".json"
  local snippet_glob = snippet_base .. "/*.json"
  add_parsed_snippets(snippet_file, ft, snippets)
  if vim.fn.isdirectory(snippet_base) == 1 then
    local files = vim.fn.glob(snippet_glob, false, true)
    for _, file in ipairs(files) do
      add_parsed_snippets(file, ft, snippets)
    end
  end
  table.sort(snippets, function(a, b)
    return a.trigger < b.trigger
  end)
  return snippets
end

local function snippet_picker(opts)
  opts = opts or {}
  local snippets = get_snippets()
  if #snippets == 0 then
    vim.notify("No snippets found for the current buffer", vim.log.levels.INFO)
    return
  end
  pickers
    .new(opts, {
      prompt_title = "Snippets",
      finder = finders.new_table({
        results = snippets,
        entry_maker = function(entry)
          local max_description = 80
          if #entry.description > max_description then
            entry.description = string.sub(entry.description, 1, max_description - 3) .. "..."
          end
          local display = string.format("%-20s │ %s", entry.trigger, entry.description)
          return {
            value = entry,
            display = display,
            ordinal = entry.trigger .. " " .. entry.description,
          }
        end,
      }),
      sorter = config.generic_sorter(opts),
    })
    :find()
end

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node_modules/",
        "__pycache__/",
      },
      -- sorting_strategy = "ascending",
    },
  },
  keys = {
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "Buffer",
    },
    { "<leader>fc", LazyVim.pick.config_files(), desc = "Config Files" },
    { "<leader>ff", LazyVim.pick("files"), desc = "File in CWD" },
    { "<leader>fg", LazyVim.pick("live_grep"), desc = "Grep in CWD" },
    {
      "<leader>fh",
      "<cmd>Telescope find_files cwd=~ search_dirs=~/.config,~/Desktop,~/Documents,~/Downloads,~/Notes,~/Workspaces<cr>",
      desc = "File in Home",
    },
    { "<leader>fn", "<cmd>Telescope live_grep cwd=$HOME/Notes prompt_title=Find Note<cr>", desc = "Notes" },
    { "<leader>fr", "<cmd>Telescope oldfiles prompt_title=Find\\ Recent<cr>", desc = "Recents" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
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
    { "<leader>ss", snippet_picker, desc = "Snippets" },
    {
      "<leader>sS",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Symbols",
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
