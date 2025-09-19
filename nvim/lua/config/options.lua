-- TODO: many of these can be hard coded in their specific plugin. leaving for now, changing later
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.g.autoformat = false
-- disables snack animations
vim.g.snacks_animate = false
-- TODO: since these will be defaults get rid of them
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
-- netrw more reasonable defaults
-- TODO: maybe get rid of these if we can make a better Vexplore / Hexplore
vim.g.netrw_banner = false
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
-- read env files as shell files
vim.filetype.add({
  pattern = {
    [".*%.env%..*"] = "sh",
  },
})
vim.g.python_recommended_style = 0
vim.g.markdown_recommended_style = 0
vim.g.ai_cmp = true
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
-- set lsp servers to be ignored when used with `util.root.detectors.lsp` for
-- detecting the lsp root
vim.g.root_lsp_ignore = { "copilot" }
vim.g.trouble_lualine = true

local opt = vim.opt
opt.autowrite = true
-- only set clipboard if not in ssh, to make sure the osc 52 integration works
-- automatically
opt.clipboard = vim.env.ssh_tty and "" or "unnamedplus" -- sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
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
opt.foldexpr = "v:lua.require'util'.ui.foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guicursor = ""
opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap lines at convenient points
-- opt.list = false
opt.mouse = "a" -- enable mouse
opt.number = true
opt.pumblend = 10 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
opt.relativenumber = true
opt.ruler = false -- disable the default ruler
opt.scrolloff = 6 -- lines of context
-- changes how :mksession behaves
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- round indent to multiple of shiftwidth
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmatch = true
opt.showmode = false
opt.sidescrolloff = 8 -- columns of context
opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.smoothscroll = false
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = false
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.swapfile = false
opt.tabstop = 2
opt.tagcase = "match"
opt.termguicolors = true -- true color support
opt.timeoutlen = 300 -- quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger cursorhold
opt.virtualedit = "block" -- allow cursor to traverse blanks in visual block mode
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winminwidth = 5
opt.wrap = false
