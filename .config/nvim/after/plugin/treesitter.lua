require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
	},
	auto_install = true,
	ensure_installed = {
		"bash",
		"c",
		"comment",
		"cpp",
		"css",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"latex",
		"lua",
		"make",
		"markdown",
		"proto",
		"python",
		"query",
		"sql",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
	},
	highlight = {
		additional_vim_regex_highlighting = false,
		enable = true,
	},
	indent = {
		enable = true,
	},
	sync_install = false,
})
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup({})
