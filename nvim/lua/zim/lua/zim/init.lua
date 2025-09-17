vim.uv = vim.uv or vim.loop

local M = {}

function M.setup(opts)
	require("zim.lua.zim.config").setup(opts)
end

return M
