-- packer
require("amcg.packer")
-- one dark color scheme
require("onedark").setup({
	cmp_itemkind_reverse = true,
	colors = {
		grey = "#484d5a",
		cyan = "#28a99e",
		diff_add = "#38523e",
	},
	highlights = {
		["@comment"] = { fg = "$grey", fmt = "italic" },
	},
})
require("onedark").load()
-- personal settings
require("amcg.prefs")
