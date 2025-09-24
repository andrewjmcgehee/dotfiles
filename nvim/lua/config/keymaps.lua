-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- unset alt keymaps (don't work on mac os)
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")
-- unset window resize commands (unused)
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")
-- unset buffer keymaps (unused)
vim.keymap.del("n", "<leader>`") -- also might collide with tmux hyper
vim.keymap.del("n", "<leader>bP")
vim.keymap.del("n", "<leader>bb")
vim.keymap.del("n", "<leader>bd")
vim.keymap.del("n", "<leader>bD")
vim.keymap.del("n", "<leader>bl")
vim.keymap.del("n", "<leader>bo")
vim.keymap.del("n", "<leader>bp")
vim.keymap.del("n", "<leader>br")
-- unset profiling keys (unused)
vim.keymap.del("n", "<leader>dps")
vim.keymap.del("n", "<leader>dph")
vim.keymap.del("n", "<leader>dpp")
-- map <leader>d to buf delete
vim.keymap.set("n", "<leader>d", function()
  Snacks.bufdelete()
end, { desc = "which_key_ignore" })
-- single q for quit
vim.keymap.del("n", "<leader>qq")
vim.keymap.set("n", "<leader>q", "<cmd>qa<enter>", { desc = "Quit" })
-- delete more keymaps
vim.keymap.del({ "n", "i", "x", "s" }, "<c-s>") -- save file
vim.keymap.del("t", "<c-/>") -- toggle terminal
vim.keymap.del("t", "<c-_>") -- unused
vim.keymap.del("n", "<leader>.") -- toggle scratch buffer
vim.keymap.del("n", "<leader>|") -- vertical split (replacing with telescope vexplore)
vim.keymap.del("n", "<leader>-") -- horizontal split (replacing with telescope and hexplore)
vim.keymap.del("n", "<leader>K") -- keywordprg (no idea what this is for)
vim.keymap.del("n", "<leader>L") -- lazyvim changelog
vim.keymap.del("n", "<leader>S") -- open scratch buffer
vim.keymap.del("n", "<leader>cd") -- disable line diagnostics in favor of [d or ]d
vim.keymap.del("n", "<leader>cf") -- manual format (unused)
vim.keymap.del("n", "<leader>fT") -- terminal in cwd
vim.keymap.del("n", "<leader>fn") -- new file
vim.keymap.del("n", "<leader>ft") -- terminal in root
-- git
vim.keymap.set({ "n", "x" }, "<leader>gb", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gl", function()
  Snacks.picker.git_log({ cwd = LazyVim.root.git() })
end, { desc = "Git Log" })
vim.keymap.set({ "n", "x" }, "<leader>gy", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git Yank URL" })
vim.keymap.del("n", "<leader>gB")
vim.keymap.del("n", "<leader>gG")
vim.keymap.del("n", "<leader>gY")
vim.keymap.del("n", "<leader>gL")
vim.keymap.del("n", "<leader>gf")
-- trouble
vim.keymap.del("n", "<leader>cS")
vim.keymap.del("n", "<leader>cs")
vim.keymap.del("n", "<leader>xL")
vim.keymap.del("n", "<leader>xQ")
vim.keymap.del("n", "<leader>xX")
vim.keymap.del("n", "<leader>xl")
vim.keymap.del("n", "<leader>xq")
vim.keymap.del("n", "<leader>xx")
-- noice
vim.keymap.set("n", "<leader>sn", function() end, { desc = "+Noice" })
vim.keymap.set("n", "<leader>snt", function()
  require("noice").cmd("pick")
end, { desc = "Noice Telescope" })
-- ui
vim.keymap.del("n", "<leader>uA") -- toggle tab/buffer line
vim.keymap.del("n", "<leader>uD") -- toggle cursor context dimming
vim.keymap.del("n", "<leader>uF") -- toggle autoformat (buffer)
vim.keymap.del("n", "<leader>uL") -- toggle relative number
vim.keymap.del("n", "<leader>uS") -- toggle smooth scrolling
vim.keymap.del("n", "<leader>uT") -- toggle treesitter highlighting
vim.keymap.del("n", "<leader>uZ") -- toggle zoom mode
vim.keymap.del("n", "<leader>ua") -- toggle animation
vim.keymap.del("n", "<leader>ub") -- toggle dark mode
vim.keymap.del("n", "<leader>ud") -- toggle diagnostics
vim.keymap.del("n", "<leader>uf") -- toggle autoformat
vim.keymap.del("n", "<leader>ug") -- toggle indent guides
vim.keymap.del("n", "<leader>uh") -- toggle inlay hints
vim.keymap.del("n", "<leader>ul") -- toggle line numbers
vim.keymap.del("n", "<leader>up") -- toggle mini pairs
vim.keymap.del("n", "<leader>ur") -- redraw
vim.keymap.del("n", "<leader>uw") -- toggle wrap
vim.keymap.del("n", "<leader>uz") -- toggle zen mode
vim.keymap.del("n", "<leader>wm") -- toggle zoom mode
-- TODO: see what conceallevel toggling does in json file before unmapping this
--
-- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
-- unmap all tab controls (don't use tabs)
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")
