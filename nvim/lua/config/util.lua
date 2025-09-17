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

return M
