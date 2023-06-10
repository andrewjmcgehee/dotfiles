-- plugin to change the working directory to a project root
local g = vim.g
local v = vim.v
local o = vim.o
local opt = vim.opt
local fn = vim.fn

if g.loaded_rooter or o.cp then
	return
end

vim.g.loaded_rooter = true

local nomodeline = ""
if v.version > 703 or (v.version == 703 and fn.has("patch442")) then
	nomodeline = "<nomodeline>"
else
	nomodeline = ""
end

local set_default = function(var, default)
	if var == nil then
		var = default
	end
	return var
end

g.rooter_manual_only = set_default(g.rooter_manual_only, false)
g.rooter_cd_cmd = set_default(g.rooter_cd_cmd, "cd")
g.rooter_buftypes = set_default(g.rooter_buftypes, { "", "nofile", "nowrite", "acwrite" })
g.rooter_patterns = set_default(g.rooter_patterns, { ".git", "Makefile", "package.json", "WORKSPACE" })
g.rooter_targets = set_default(g.rooter_targets, "/,*")
g.rooter_change_directory_for_non_project_files = set_default(g.rooter_change_directory_for_non_project_files, "")
g.rooter_silent_chdir = set_default(g.rooter_silent_chdir, false)
g.rooter_resolve_links = set_default(g.rooter_resolve_links, false)

if opt.autochdir and not g.rooter_manual_only then
	opt.autochdir = false
end

local activate = function()
	local targets = fn.split(g.rooter_targets, ",")
	-- LOG:info("*** START NEW RUN ***")
	-- LOG:info("targets:")
	-- for _, val in ipairs(targets) do
	-- 	LOG:info("\t%s", val)
	-- end
	if fn.index(g.rooter_buftypes, o.buftype) == -1 then
		-- LOG:warn("buftype not found in rooter_buftypes")
		return false
	end
	local filename = fn.expand("%:p", true)
	-- LOG:info("filename: " .. filename)
	if string.match(filename, "NERD_tree_%d%+$") then
		filename = vim.b.NERDTree.root.path.str() .. "/"
		-- LOG:info("filename matched NERDTree and changed to: " .. filename)
	end
	if fn.empty(filename) == 1 or string.sub(filename, -1, -1) == "/" then
		-- LOG:info("filename is empty: %s", (fn.empty(filename) == 1))
		-- LOG:info("filename is directory: %s", (string.sub(filename, -1, -1) == "/"))
		-- LOG:warn("/ not in targets: %s", (fn.index(targets, "/") == -1))
		return fn.index(targets, "/") ~= -1
	end
	if not fn.filereadable(filename) then
		-- LOG:warn("file not readable")
		return false
	end
	if not fn.exists("*glob2regpat") then
		-- LOG:warn("no glob2regpat function, activate will always be true")
		return true
	end
	for _, p in pairs(targets) do
		-- LOG:info("target: %s", p)
		if p == "/" then
			-- LOG:info("skipping / pattern")
			goto continue
		end
		local reg = fn.glob2regpat(p)
		-- LOG:info("glob2regpat returned: " .. reg)
		if vim.regex(reg):match_str(filename) then
			-- LOG:info("filename matched: " .. reg)
			return true
		end
		::continue::
	end
	-- LOG:warn("filename matched no target")
	return false
end

TestActivate = function()
	print(activate())
end

local parent = function(dir)
	return fn.fnamemodify(dir, ":h")
end

local exact_match = function(dir, identifier)
	identifier = fn.substitute(identifier, "/$", "", "")
	return fn.fnamemodify(dir, ":t") == identifier
end

local has_ancestor = function(dir, identifier)
	local path = parent(dir)
	local current
	while true do
		if fn.fnamemodify(path, ":t") == identifier then
			return true
		end
		current, path = path, parent(path)
		if current == path then
			break
		end
	end
	return false
end

local has_parent = function(dir, identifier)
	local path = parent(dir)
	return fn.fnamemodify(path, ":t") == identifier
end

local contains_file = function(dir, identifier)
	return not (fn.empty(fn.globpath(fn.escape(dir, "?*[]"), identifier, true)) == 1)
end

local match = function(dir, pattern)
	if pattern:sub(1, 1) == "=" then
		return exact_match(dir, pattern:sub(2, -1))
	elseif pattern:sub(1, 1) == "^" then
		return has_ancestor(dir, pattern:sub(2, -1))
	elseif pattern:sub(1, 1) == ">" then
		return has_parent(dir, pattern:sub(2, -1))
	else
		return contains_file(dir, pattern)
	end
end

local current_path = function()
	local filename = fn.expand("%:p", true)
	if string.match(filename, "NERD_tree_%d%+$") then
		filename = vim.b.NERDTree.root.path.str() .. "/"
	end
	if fn.empty(filename) == 1 then
		return fn.getcwd()
	end
	if g.rooter_resolve_links then
		filename = fn.resolve(filename)
	end
	return fn.fnamemodify(filename, ":h")
end

local find_root = function()
	local dir = current_path()
	print(dir)
	local current, p, exclude
	while true do
		for _, pattern in pairs(g.rooter_patterns) do
			if pattern:sub(1, 1) == "!" then
				p, exclude = pattern:sub(2, -1), true
			else
				p, exclude = pattern, false
			end
			if match(dir, p) then
				if exclude then
					break
				end
				return dir
			end
		end
		current, dir = dir, parent(dir)
		if current == dir then
			break
		end
	end
	return ""
end

local cd = function(dir)
	if dir == fn.getcwd() then
		return
	end
	vim.cmd(g.rooter_cd_cmd .. " fnameescape(" .. dir .. ")")
	if not g.rooter_silent_chdir then
		fn.redraw()
		print("cwd: " .. dir)
	end
	if fn.exists("#User#RooterChDir") then
		vim.cmd("doautocmd " .. nomodeline .. " User RooterChDir")
	end
end

local rootless = function()
	local dir = ""
	if g.rooter_change_directory_for_non_project_files == "current" then
		dir = current_path()
	elseif g.rooter_change_directory_for_non_project_files == "home" then
		dir = os.getenv("HOME") or ""
	end
	if not (fn.empty(dir) == 1) then
		cd(dir)
	end
end

local rooter = function()
	if not activate() then
		return
	end
	local root = vim.fn.getbufvar("%", "rootDir")
	if fn.empty("rootDir") == 1 then
		root = find_root()
		vim.fn.setbufvar("%", "rootDir", root)
	end
	if fn.empty(root) == 1 then
		rootless()
		return
	end
	cd(root)
end

FindRootDirectory = function()
	return find_root()
end
-- command! -bar Rooter call <SID>rooter()
-- command! -bar RooterToggle call <SID>toggle()

-- augroup rooter
--   autocmd!
--   autocmd VimEnter,BufReadPost,BufEnter * nested if !g:rooter_manual_only | Rooter | endif
--   autocmd BufWritePost * nested if !g:rooter_manual_only | call setbufvar('%', 'rootDir', '') | Rooter | endif
-- augroup END
