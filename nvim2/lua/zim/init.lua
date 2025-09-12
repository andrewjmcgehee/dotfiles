vim.uv = vim.uv or vim.loop

local M = {}

function M.setup(opts)
	require("zim.config").init()
	require("zim.config").setup(opts)
end

return M
