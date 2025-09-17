local util = require("util")

local M = {}

function M.is_loaded(name)
	local cfg = require("lazy.core.config")
	return cfg.plugins[name] and cfg.plugins[name]._.loaded
end

function M.on_load(name, fn)
	if M.is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

local defaults = {
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = "󱄽 ",
      String        = " ",
      Struct        = "󰆼 ",
      Supermaven    = " ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  },
	---@type table<string, string[]|boolean>?
	kind_filter = {
		default = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			"Package",
			"Property",
			"Struct",
			"Trait",
		},
		markdown = false,
		help = false,
		-- you can specify a different filter for each filetype
		lua = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			-- "Package", -- remove package since luals uses it for control flow structures
			"Property",
			"Struct",
			"Trait",
		},
	},
}

local options
local lazy_clipboard

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}
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
			-- Zim.format.setup()
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

------@param buf? number
------@return string[]?
---function M.get_kind_filter(buf)
---	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
---	local ft = vim.bo[buf].filetype
---	if M.kind_filter == false then
---		return
---	end
---	if M.kind_filter[ft] == false then
---		return
---	end
---	if type(M.kind_filter[ft]) == "table" then
---		return M.kind_filter[ft]
---	end
---	---@diagnostic disable-next-line: return-type-mismatch
---	return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
---end

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

------@alias ZimDefault {name: string, extra: string, enabled?: boolean, origin?: "global" | "default" | "extra" }
---
---local default_extras ---@type table<string, ZimDefault>
---function M.get_defaults()
---	if default_extras then
---		return default_extras
---	end
---	---@type table<string, ZimDefault[]>
---	local checks = {
---		picker = {
---			{ name = "snacks", extra = "editor.snacks_picker" },
---			{ name = "fzf", extra = "editor.fzf" },
---			{ name = "telescope", extra = "editor.telescope" },
---		},
---		cmp = {
---			{ name = "blink.cmp", extra = "coding.blink", enabled = vim.fn.has("nvim-0.10") == 1 },
---			{ name = "nvim-cmp", extra = "coding.nvim-cmp" },
---		},
---		explorer = {
---			{ name = "snacks", extra = "editor.snacks_explorer" },
---			{ name = "neo-tree", extra = "editor.neo-tree" },
---		},
---	}
---	default_extras = {}
---	for name, check in pairs(checks) do
---		local valid = {} ---@type string[]
---		for _, extra in ipairs(check) do
---			if extra.enabled ~= false then
---				valid[#valid + 1] = extra.name
---			end
---		end
---		local origin = "default"
---		local use = vim.g["zim_" .. name]
---		use = vim.tbl_contains(valid, use or "auto") and use or nil
---		origin = use and "global" or origin
---		for _, extra in ipairs(use and {} or check) do
---			if extra.enabled ~= false and Zim.has_extra(extra.extra) then
---				use = extra.name
---				break
---			end
---		end
---		origin = use and "extra" or origin
---		use = use or valid[1]
---		for _, extra in ipairs(check) do
---			local import = "zim.plugins.extras." .. extra.extra
---			extra = vim.deepcopy(extra)
---			extra.enabled = extra.name == use
---			if extra.enabled then
---				extra.origin = origin
---			end
---			default_extras[import] = extra
---		end
---	end
---	return default_extras
---end

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return options[key]
	end,
})

return M
