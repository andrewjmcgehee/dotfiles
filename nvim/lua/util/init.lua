local lazyutil = require("lazy.core.util")

local M = {}

-- TODO: check if lazygit actually needs special case...
setmetatable(M, {
	__index = function(t, k)
		if lazyutil[k] then
			return lazyutil[k]
		end
		if k == "lazygit" or k == "toggle" then -- HACK: special case for lazygit
			return M.deprecated[k]()
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("util." .. k)
		M.deprecated.decorate(k, t[k])
		return t[k]
	end,
})

---@param name string
function M.get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
	local plugin = M.get_plugin(name)
	path = path and "/" .. path or ""
	return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
	return M.get_plugin(plugin) ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

--- extends a deeply nested list with a dot-separated string key if the nested
--- list does not exist
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
	local keys = vim.split(key, ".", { plain = true })
	for i = 1, #keys do
		local k = keys[i]
		t[k] = t[k] or {}
		if type(t) ~= "table" then
			return
		end
		t = t[k]
	end
	return vim.list_extend(t, values)
end

---@param name string
function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end
	local lazyplugin = require("lazy.core.plugin")
	return lazyplugin.values(plugin, "opts", false)
end

-- check-set replacing vim.notify with a delayed notify, gives up after 500ms
function M.lazy_notify()
	local notifications = {}
	local function temporary_notify(...)
		table.insert(notifications, vim.F.pack_len(...))
	end
	local original_notify = vim.notify
	vim.notify = temporary_notify
	local timer = vim.uv.new_timer()
	local check = assert(vim.uv.new_check())
	-- replays capture notifications even if vim.notify replacement takes too long
	local replay = function()
		if timer ~= nil then
			timer:stop()
		end
		check:stop()
		if vim.notify == temporary_notify then
			vim.notify = original_notify
		end
		vim.schedule(function()
			for _, n in ipairs(notifications) do
				vim.notify(vim.F.unpack_len(n))
			end
		end)
	end
	check:start(function()
		if vim.notify ~= temporary_notify then
			replay()
		end
	end)
	-- after 500 ms, something has gone wrong
	if timer ~= nil then
		timer:start(500, 0, replay)
	end
end

function M.is_loaded(name)
	local cfg = require("lazy.core.config")
	return cfg.plugins[name] and cfg.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
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

-- silently sets a keymap unless the key handler already exists in lazy
function M.safe_keymap_set(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	local modes = type(mode) == "string" and { mode } or mode
	modes = vim.tbl_filter(function(m)
		---@cast keys LazyKeysHandler
		return not (keys.have and keys:have(lhs, m))
	end, modes)
	-- do not create the keymap if a lazy key handler already exists for that key
	if #modes > 0 then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end
		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

function M.create_undo()
	if vim.api.nvim_get_mode().mode == "i" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-G>u", true, true, true), "n", false)
	end
end

--- override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
	M[level] = function(msg, opts)
		opts = opts or {}
		opts.title = opts.title or "Zim"
		return lazyutil[level](msg, opts)
	end
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
	return function(...)
		local key = vim.inspect({ ... })
		cache[fn] = cache[fn] or {}
		if cache[fn][key] == nil then
			cache[fn][key] = fn(...)
		end
		return cache[fn][key]
	end
end

return M
