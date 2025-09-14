vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? ZimConfig
function M.setup(opts)
	require("zim.config").setup(opts)
end

return M
