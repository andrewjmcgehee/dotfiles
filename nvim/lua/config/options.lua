-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = true -- consider setting to false if needed for code actions
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_picker = "telescope"
vim.g.mapleader = ","
vim.g.markdown_recommended_style = 0
-- netrw more reasonable defaults
-- TODO: maybe get rid of these if we can make a better Vexplore / Hexplore
vim.g.netrw_banner = false
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.g.python_host_prog = "/opt/homebrew/bin/python3"
vim.g.python_recommended_style = 0
vim.g.snacks_animate = false

vim.opt.guicursor = ""
vim.opt.smoothscroll = false
vim.opt.swapfile = false

-- read env files as shell files
vim.filetype.add({
  pattern = {
    [".*%.env%..*"] = "sh",
  },
})
