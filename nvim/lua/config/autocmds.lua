local lsp = require("lsp")

local function augroup(name)
  return vim.api.nvim_create_augroup("zim_" .. name, { clear = true })
end

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lspattach"),
  callback = function(evt)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = evt.buf, desc = "Goto Definition", silent = true })
    vim.keymap.set(
      "n",
      "gr",
      vim.lsp.buf.references,
      { buffer = evt.buf, desc = "References", nowait = true, silent = true }
    )
    vim.keymap.set(
      "n",
      "gI",
      vim.lsp.buf.implementation,
      { buffer = evt.buf, desc = "Goto Implementation", silent = true }
    )
    vim.keymap.set(
      "n",
      "gt",
      vim.lsp.buf.type_definition,
      { buffer = evt.buf, desc = "Goto Type Definition", silent = true }
    )
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = evt.buf, desc = "Goto Declaration", silent = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = evt.buf, desc = "Hover", silent = true })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = evt.buf, desc = "Signature Help", silent = true })
    vim.keymap.set(
      "i",
      "<c-k>",
      vim.lsp.buf.signature_help,
      { buffer = evt.buf, desc = "Signature Help", silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      { buffer = evt.buf, desc = "Code Action", silent = true }
    )
    vim.keymap.set(
      "n",
      "<leader>cR",
      Snacks.rename.rename_file,
      { buffer = evt.buf, desc = "Rename File", silent = true }
    )
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = evt.buf, desc = "Rename", silent = true })
  end,
})

-- format on save and run code actions
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  group = augroup("autoformat"),
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    if ft == "typescript" or ft == "typescriptreact" then
      vim.schedule(function()
        lsp.execute_action("source.addMissingImports.ts")
        lsp.execute_action("source.organizeImports.ts")
        lsp.execute_action("source.removeUnused.ts")
      end)
    end
  end,
})

-- check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
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
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

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
