local util = require("util")

local M = {}

local lazy_clipboard

function M.setup(_)
  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end
  local group = vim.api.nvim_create_augroup("Zim", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")
      if lazy_clipboard ~= nil then
        vim.opt.clipboard = lazy_clipboard
      end
      -- Zim.root.setup()
      -- vim.api.nvim_create_user_command("ZimExtras", function()
      -- 	Zim.extras.show()
      -- end, { desc = "Manage Zim extras" })
      vim.api.nvim_create_user_command("LazyHealth", function()
        vim.cmd([[Lazy! load all]])
        vim.cmd([[checkhealth]])
      end, { desc = "Load all plugins and run :checkhealth" })
      local health = require("lazy.health")
      vim.list_extend(health.valid, {
        "recommended",
        "desc",
        "vscode",
      })
    end,
  })
  vim.cmd.colorscheme("tokyonight")
end

function M.get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if util.kind_filter[ft] == false then
    return
  end
  if type(util.kind_filter[ft]) == "table" then
    return util.kind_filter[ft]
  end
  return util.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local pattern = name:sub(1, 1):upper() .. name:sub(2)
  local module = "config." .. name
  if require("lazy.core.cache").find(module)[1] then
    util.try(function()
      require(module)
    end, { msg = "failed loading " .. module })
  end
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
  if vim.bo.filetype == "lazy" then
    -- HACK: we may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

M.init_once = false
function M.init()
  if M.init_once then
    return
  end
  M.init_once = true
  -- delay notifications till vim.notify was replaced or after 500ms
  util.lazy_notify()
  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load("options")
  -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
  lazy_clipboard = vim.opt.clipboard
  vim.opt.clipboard = ""
  -- add support for the LazyFile event
  local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
  local evt = require("lazy.core.handler.event")
  evt.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
  evt.mappings["User LazyFile"] = evt.mappings.LazyFile
end

return M
