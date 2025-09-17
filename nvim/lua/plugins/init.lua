require("config").init()

local util = require("util")

return {
	{ "folke/lazy.nvim", version = "*" },
	{
		dir = vim.fn.expand("$HOME/.config/nvim/lua/zim"),
		priority = 10000,
		lazy = false,
		opts = {},
		cond = true,
		version = "*",
		config = function(opts)
			vim.uv = vim.uv or vim.loop
			require("config").setup(opts)
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = { explorer = { enabled = true } },
		keys = {
			{
				"<leader>e",
				function()
					Snacks.explorer({ cwd = util.root() })
				end,
				desc = "Explorer Root",
			},
			{
				"<leader>E",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer CWD",
			},
		},
		-- config = function(_, opts)
		-- 	local notify = vim.notify
		-- 	require("snacks").setup(opts)
		-- 	-- HACK: restore vim.notify after snacks setup and let noice.nvim take over
		-- 	-- this is needed to have early notifications show up in noice history
		-- 	if Zim.has("noice.nvim") then
		-- 		vim.notify = notify
		-- 	end
		-- end,
	},
}
