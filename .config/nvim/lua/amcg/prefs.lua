local g = vim.g
local opt = vim.opt
local km = vim.keymap
local api = vim.api
local fn = vim.fn

--------------------------------------------------------------------------------
-- GLOBAL
--------------------------------------------------------------------------------

g.mapleader = ","
g.netrw_banner = false
g.netrw_hide = 1
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
g.python3_host_prog = "/opt/homebrew/bin/python3"
g.python_recommended_style = false
g.loaded_perl_provider = 0
-- g.rooter_patterns = { "=src", ">.config", ".git", "WORKSPACE" }
g.rooter_change_directory_for_non_project_files = "home"

--------------------------------------------------------------------------------
-- OPT
--------------------------------------------------------------------------------

-- startup message
opt.shortmess = "IFSWcls"
-- cursor
opt.guicursor = ""
-- line numbers
opt.number = true
opt.relativenumber = true
-- indents and tabs
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2
-- swap and undo
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.config/undotree"
opt.undofile = true
-- search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true
opt.tagcase = "match"
-- completions
opt.completeopt = { "menu", "menuone", "noselect" }
-- scrolling
opt.scrolloff = 8
-- sign column, color column, text width
opt.textwidth = 80
opt.colorcolumn = "80"
opt.signcolumn = "yes:1"
-- snappier updates (milliseconds)
opt.updatetime = 80
-- backspace behavior
opt.whichwrap = "b,s,<,>,h,l"
-- wrapping
opt.formatoptions = "jcql"
opt.linebreak = true
-- status bar
opt.showcmd = false
opt.showmode = false
-- matching brackets
opt.showmatch = true
-- folding
function FoldText()
	local line = fn.substitute(fn.getline(vim.v.foldstart), "^ *", "", 1)
	local n_lines = vim.v.foldend - vim.v.foldstart + 1
	return " ☰ " .. line .. " " .. n_lines .. " lines ☰ "
end
opt.foldtext = "v:lua.FoldText()"
opt.fillchars = { fold = " " }

--------------------------------------------------------------------------------
-- KEYMAP
--------------------------------------------------------------------------------

-- explore
km.set("n", "<leader>e", vim.cmd.Explore)
km.set("n", "<leader>v", vim.cmd.Vexplore)
km.set("n", "<leader>h", vim.cmd.Hexplore)
-- join
km.set("n", "J", "mzJ`z")
-- cursor in middle of buffer when jumping
km.set("n", "<C-d>", "<C-d>zz")
km.set("n", "<C-u>", "<C-u>zz")
-- cursor in middle of buffer when searching
km.set("n", "n", "nzzzv")
km.set("n", "N", "Nzzzv")
-- yank to system
km.set("n", "<leader>y", '"+y')
km.set("n", "<leader>yy", '"+yy')
km.set("n", "<leader>Y", '"+Y')
-- quick fix
km.set("n", "<C-j>", "<cmd>cnext<CR>zz")
km.set("n", "<C-k>", "<cmd>cprev<CR>zz")
km.set("n", "<leader>j", "<cmd>lnext<CR>zz")
km.set("n", "<leader>k", "<cmd>lprev<CR>zz")
-- source a file
km.set("n", "<leader><leader>", function()
	vim.cmd([[so]])
end)
-- search and replace current word under cursor
km.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make current file in buffer executable
km.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- search
km.set("n", "<Space>", "/")
-- spell check
km.set("n", "<leader>sp", ":setlocal spell! spelllang=en_us<CR>")
-- swap 0 and ^
km.set("n", "0", "^")
km.set("n", "^", "0")
-- replace all
km.set("n", "S", ":%s///g<Left><Left><Left>")
-- quiet write
km.set("n", "ZZ", ":silent w<CR>")
km.set("n", "ZX", ":silent x<CR>")
-- reroute marks to capital M
km.set("n", "M", "`")
km.set("o", "M", "`")
km.set("v", "M", "`")
-- shift tab behavior
km.set("i", "<S-Tab>", "<C-d>")
-- move code section
km.set("v", "J", ":m '>+1<CR>gv=gv")
km.set("v", "K", ":m '<-2<CR>gv=gv")
-- yank to system
km.set("v", "<leader>y", '"+y')
km.set("v", "<leader>Y", '"+Y')
-- replace current selection and keep replacement in register
km.set("x", "<leader>p", '"_dP')
-- write to a readonly file
km.set("c", "w!!", "exe 'silent! write !sudo tee % >/dev/null' <bar> edit!")

--------------------------------------------------------------------------------
-- HIGHLIGHTS
--------------------------------------------------------------------------------

local color = require("onedark.palette").dark
color.cyan = "#28a99e"
color.grey = "#484d5a"
local none = "none"
api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = color.orange, bg = none, underline = true })
api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = color.orange, bg = none, underline = true })
-- begin CmpItemKind highlights
-- red
api.nvim_set_hl(0, "CmpItemKindNamespace", { reverse = true, fg = color.yellow })
api.nvim_set_hl(0, "CmpItemKindObject", { reverse = true, fg = color.light_grey })
api.nvim_set_hl(0, "CmpItemKindOperator", { reverse = true, fg = color.green })
api.nvim_set_hl(0, "CmpItemKindSnippet", { reverse = true, fg = color.yellow })
api.nvim_set_hl(0, "CmpItemKindTypeParameter", { reverse = true, fg = color.orange })
-- orange
api.nvim_set_hl(0, "CmpItemKindBoolean", { reverse = true, fg = color.blue })
api.nvim_set_hl(0, "CmpItemKindConstant", { reverse = true, fg = color.green })
api.nvim_set_hl(0, "CmpItemKindFolder", { reverse = true, fg = color.light_grey })
api.nvim_set_hl(0, "CmpItemKindModule", { reverse = true, fg = color.purple })
api.nvim_set_hl(0, "CmpItemKindNumber", { reverse = true, fg = color.light_grey })
api.nvim_set_hl(0, "CmpItemKindReference", { reverse = true, fg = color.red })
api.nvim_set_hl(0, "CmpItemKindValue", { reverse = true, fg = color.green })
-- yellow
api.nvim_set_hl(0, "CmpItemKindArray", { reverse = true, fg = color.orange })
api.nvim_set_hl(0, "CmpItemKindClass", { reverse = true, fg = color.blue })
api.nvim_set_hl(0, "CmpItemKindEnumMember", { reverse = true, fg = color.purple })
api.nvim_set_hl(0, "CmpItemKindEvent", { reverse = true, fg = color.cyan })
api.nvim_set_hl(0, "CmpItemKindPackage", { reverse = true, fg = color.orange })
-- green
api.nvim_set_hl(0, "CmpItemKindColor", { reverse = true, fg = color.purple })
api.nvim_set_hl(0, "CmpItemKindInterface", { reverse = true, fg = color.blue })
api.nvim_set_hl(0, "CmpItemKindString", { reverse = true, fg = color.cyan })
api.nvim_set_hl(0, "CmpItemKindText", { reverse = true, fg = color.red })
api.nvim_set_hl(0, "CmpItemKindUnit", { reverse = true, fg = color.green })
-- cyan
api.nvim_set_hl(0, "CmpItemKindKey", { reverse = true, fg = color.yellow })
api.nvim_set_hl(0, "CmpItemKindKeyword", { reverse = true, fg = color.yellow })
api.nvim_set_hl(0, "CmpItemKindProperty", { reverse = true, fg = color.orange })
-- blue
api.nvim_set_hl(0, "CmpItemKindConstructor", { reverse = true, fg = color.red })
api.nvim_set_hl(0, "CmpItemKindFile", { reverse = true, fg = color.light_grey })
api.nvim_set_hl(0, "CmpItemKindFunction", { reverse = true, fg = color.green })
api.nvim_set_hl(0, "CmpItemKindMethod", { reverse = true, fg = color.purple })
-- purple
api.nvim_set_hl(0, "CmpItemKindEnum", { reverse = true, fg = color.green })
api.nvim_set_hl(0, "CmpItemKindField", { reverse = true, fg = color.blue })
api.nvim_set_hl(0, "CmpItemKindStruct", { reverse = true, fg = color.yellow })
api.nvim_set_hl(0, "CmpItemKindVariable", { reverse = true, fg = color.red })
-- grey
api.nvim_set_hl(0, "CmpItemKindDefault", { reverse = true, fg = color.light_grey })
api.nvim_set_hl(0, "CmpItemKindNull", { reverse = true, fg = color.grey })
-- end CmpItemKind highlights
api.nvim_set_hl(0, "Folded", { fg = color.black, bg = color.light_grey, bold = true })
api.nvim_set_hl(0, "FzfLuaNormal", { link = "Normal" })
api.nvim_set_hl(0, "FzfLuaBorder", { fg = color.blue, bg = none })
api.nvim_set_hl(0, "MatchParen", { bg = color.red, fg = color.black })

--------------------------------------------------------------------------------
-- AUTOCOMMANDS
--------------------------------------------------------------------------------

-- set local formatoptions
api.nvim_create_autocmd("BufReadPost", {
	command = [[setlocal formatoptions=jcql]],
})
-- place cursor on same line as when leaving the buffer if possible
api.nvim_create_autocmd("BufReadPost", {
	command = [[
    if line("'\"") > 1 && line("'\"") <= line("$") |
      execute "normal! g`\"" |
    endif
  ]],
})
-- clear previous command
api.nvim_create_autocmd("CmdlineLeave", { command = [[echo '']] })
-- more intuitive netrw
NetrwMapping = function()
	vim.cmd([[
    nmap <buffer> h -^
    nmap <buffer> l <CR>
    nmap <buffer> . gh
  ]])
end
vim.cmd([[
  augroup netrw_group
    autocmd!
    autocmd filetype netrw :lua NetrwMapping()
  augroup END
]])
