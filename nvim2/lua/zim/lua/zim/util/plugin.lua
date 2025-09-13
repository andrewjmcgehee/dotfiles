---@class lazyvim.util.plugin
local M = {}

---@type string[]
M.core_imports = {}
M.handle_defaults = true

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.renames = {
	["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
	["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
	["null-ls.nvim"] = "none-ls.nvim",
	["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
	["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
	["markdown.nvim"] = "render-markdown.nvim",
	["williamboman/mason.nvim"] = "mason-org/mason.nvim",
	["williamboman/mason-lspconfig.nvim"] = "mason-org/mason-lspconfig.nvim",
}

function M.save_core()
	if vim.v.vim_did_enter == 1 then
		return
	end
	M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
	M.lazy_file()
end

function M.extra_idx(name)
	local Config = require("lazy.core.config")
	for i, extra in ipairs(Config.spec.modules) do
		if extra == "zim.plugins.extras." .. name then
			return i
		end
	end
end

function M.lazy_file()
	-- Add support for the LazyFile event
	local Event = require("lazy.core.handler.event")
	Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

return M
