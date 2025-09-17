local util = require("util")

local M = {}

function M.servers()
	return {
		basedpyright = {},
		ruff = {},
	}
end

function M.setup()
	return {
		ruff = function()
			-- prefer basedpyright hover functionality
			util.lsp.on_attach(function(client, _)
				client.server_capabilities.hoverProvider = false
			end)
		end,
	}
end

return M
