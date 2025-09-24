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

-- TODO: revisit this after we have ts lsp setup
--
-- format on save and run code actions
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*" },
--   group = augroup("autoformat"),
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--     local buf = vim.api.nvim_get_current_buf()
--     local ft = vim.bo[buf].filetype
--     if ft == "typescript" or ft == "typescriptreact" then
--       vim.schedule(function()
--         lsp.execute_action("source.addMissingImports.ts")
--         lsp.execute_action("source.organizeImports.ts")
--         lsp.execute_action("source.removeUnused.ts")
--       end)
--     end
--   end,
-- })

-- TODO: remove this in favor of telescope
--
-- maybe remove this with better telescope based vexplore / hexplore
-- more intuitive netrw experience
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("netrw_remaps"),
  pattern = "netrw",
  callback = function(opts)
    vim.api.nvim_buf_set_keymap(opts.buf, "n", "<left>", "-^", {})
    vim.api.nvim_buf_set_keymap(opts.buf, "n", "<right>", "<enter>", {})
    vim.api.nvim_buf_set_keymap(opts.buf, "n", ".", "gh", {})
    vim.opt_local.statuscolumn = ""
  end,
})

-- TODO: replace existing named augroup

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

-- TODO: maybe move this to its own module?
--
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
