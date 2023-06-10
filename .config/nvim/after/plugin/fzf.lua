local km = vim.keymap
local fzf = require("fzf-lua")
km.set("n", "<leader>ff", fzf.files)
km.set("n", "<leader>fg", fzf.git_files)
km.set("n", "<leader>fs", function()
	fzf.live_grep({ prompt = "live_grep >" })
end)
