vim.api.nvim_echo({
	{ "Do not use this plugin directly\n", "ErrorMsg" },
	{ "Press any key to exit", "MoreMsg" },
}, true, {})
vim.fn.getchar()
vim.cmd([[quit]])
