local black = "#181a1f"
require("lualine").setup({
	options = {
		-- fmt = string.lower,
		theme = "onedark",
		icons_enabled = true,
		component_separators = "⏐",
		section_separators = { left = "▌", right = "▐" },
		globalstatus = true,
		refresh = {
			statusline = 100,
			tabline = 10000,
			winbar = 10000,
		},
		disabled_filetypes = {
			statusline = {
				"NetrwTreeListing",
			},
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(s)
					return s:sub(1, 1)
				end,
				color = { fg = black, gui = "bold" },
			},
		},
		lualine_b = {
			{ "branch", icon = "", color = { gui = "bold" } },
			"diff",
			"diagnostics",
		},
		lualine_c = {
			{
				"filename",
				color = { gui = "bold" },
				symbols = {
					modified = " 󰇂 ",
					readonly = " 󰜺 ",
					unnamed = "  ",
					newfile = "  ",
				},
			},
		},
		lualine_x = {
			"encoding",
			{
				"fileformat",
				color = { gui = "bold" },
				symbols = {
					unix = "󰘳",
					dos = "",
					mac = "󰘳",
				},
			},
			{ "filetype", icon_only = true },
		},
		lualine_y = {
			function()
				local last = vim.fn.getreg("/")
				if not last or last == "" then
					return ""
				end
				local s = vim.fn.searchcount({ maxcount = 999 })
				return last .. " " .. s.current .. "/" .. s.total
			end,
			function()
				local fn = vim.fn
				return string.format("%d", math.floor(fn.line(".") / fn.line("$") * 100)) .. "%%"
			end,
		},
		lualine_z = {
			{ name = "location", color = { fg = black, gui = "bold" } },
		},
	},
})
