-- leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
-- TODO: many of these can be hard coded in their specific plugin. leaving for now, changing later
vim.g.autoformat = false
-- disables snack animations
vim.g.snacks_animate = false
-- lazyvim picker to use.
-- can be one of: telescope, fzf
-- leave it to "auto" to automatically use the picker
-- enabled with `:lazyextras`
vim.g.lazyvim_picker = "telescope"
-- lazyvim completion engine to use.
-- can be one of: nvim-cmp, blink.cmp
-- leave it to "auto" to automatically use the completion engine
-- enabled with `:lazyextras`
vim.g.lazyvim_cmp = "blink.cmp"
-- netrw reasonable defaults
vim.g.netrw_banner = false
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
-- read env files as shell files
vim.filetype.add({
	pattern = {
		[".*%.env%..*"] = "sh",
	},
})
-- don't use python recommended styles
vim.g.python_recommended_style = 0
-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- if the completion engine supports the ai source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true
-- lazyvim root dir detection
-- each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
-- set lsp servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the lsp root
vim.g.root_lsp_ignore = { "copilot" }
-- hide deprecation warnings
vim.g.deprecation_warnings = false
-- show the current document symbols location from trouble in lualine
-- you can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt
opt.autowrite = true -- enable auto write
-- only set clipboard if not in ssh, to make sure the osc 52
-- integration works automatically. requires neovim >= 0.10.0
opt.clipboard = vim.env.ssh_tty and "" or "unnamedplus" -- sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- enable highlighting of the current line
opt.expandtab = true -- use spaces instead of tabs
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guicursor = ""
opt.ignorecase = true -- ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap lines at convenient points
opt.list = true -- show some invisible characters (tabs...
opt.mouse = "a" -- enable mouse mode
opt.number = true -- print line number
opt.pumblend = 10 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
opt.relativenumber = true -- relative line numbers
opt.ruler = false -- disable the default ruler
opt.scrolloff = 6 -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmatch = true
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 8 -- columns of context
opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.smoothscroll = false
opt.spelllang = { "en" }
opt.splitbelow = true -- put new windows below current
opt.splitkeep = "screen"
opt.splitright = false -- put new windows right of current
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.swapfile = false -- turn off swap file
opt.tabstop = 2 -- number of spaces tabs count for
opt.tagcase = "match"
opt.termguicolors = true -- true color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger cursorhold
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winminwidth = 5 -- minimum window width
opt.wrap = false -- disable line wrap
