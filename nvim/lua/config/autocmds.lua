-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local function organize_imports(args)
  local ft = vim.bo[args.buf].filetype:gsub("react$", "")
  if ft == "javascript" then
    ft = "typescript"
  end
  if ft == "typescript" then
    LazyVim.try(function()
      return vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
        command = (ft .. ".organizeImports"),
        arguments = { vim.api.nvim_buf_get_name(args.buf) },
      }, 2000)
    end, {
      on_error = LazyVim.warn,
    })
  elseif ft == "java" then
    LazyVim.try(function()
      require("jdtls").organize_imports()
    end, {
      on_error = LazyVim.warn,
    })
  else
    return
  end
end

-- organize imports and format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  group = augroup("autoformat"),
  callback = function(args)
    organize_imports(args)
    require("conform").format({
      bufnr = args.buf,
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    })
  end,
})

-- extend lazyvim's ability to close some filetypes with <q> and <esc>
vim.api.nvim_clear_autocmds({ group = "lazyvim_close_with_q" })
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q_or_esc"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "octo",
    "qf",
    "rip-substitute",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit",
      })
      vim.keymap.set("n", "<esc>", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit",
      })
    end)
  end,
})

local dashboard_once = false

-- fix annoying Snacks explorer behavior
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("dir_explorer"),
  pattern = {
    "snacks_dashboard",
  },
  callback = function(_)
    if dashboard_once then
      return
    end
    dashboard_once = true
    local arg = vim.fn.argv(0)
    ---@cast arg string
    if arg == "" then
      return
    end
    local path = vim.fn.fnamemodify(arg, ":p")
    if vim.fn.isdirectory(path) == 1 then
      Snacks.explorer({ cwd = path })
    end
  end,
})

-- video recorder
local record_path = vim.fn.expand("~/Movies/")
local function start_record()
  local current_file = vim.fn.expand("%:t")
  local time = os.date("%H%M%S")
  local output_filename = string.format("%s.%s.mp4", current_file, time)
  local path = record_path .. output_filename
  local cmd = string.format(
    [[ffmpeg -y -f avfoundation -r 30 -i "3:none" -filter:v "unsharp=5:5:1.0:5:5:0.0" -preset ultrafast "%s"]],
    path
  )
  print("Recording to: " .. record_path .. output_filename)
  local job_id = vim.fn.jobstart(cmd, { detach = true })
  vim.g.recording_job_id = job_id
end
local function stop_record()
  if vim.g.recording_job_id then
    vim.fn.jobstop(vim.g.recording_job_id)
    print("Recording stopped.")
    vim.g.recording_job_id = nil
  else
    print("No active recording!")
  end
end
vim.api.nvim_create_user_command("RecordStop", stop_record, {})
vim.api.nvim_create_user_command("Record", start_record, {})
