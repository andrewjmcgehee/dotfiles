vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
	function(use, use_rocks)
		-- packer
		use("wbthomason/packer.nvim")
		-- luarocks
		use_rocks("ansicolors")
		use_rocks("inspect")
		use_rocks("lualogging")
		-- mason
		use({
			"williamboman/mason.nvim",
			run = ":MasonUpdate",
		})
		use("williamboman/mason-lspconfig.nvim")
		-- plenary
		use("nvim-lua/plenary.nvim")
		-- lsp
		use("neovim/nvim-lspconfig")
		use("jose-elias-alvarez/null-ls.nvim")
		use("mfussenegger/nvim-jdtls") -- java specific
		-- cmp
		use("hrsh7th/nvim-cmp")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-nvim-lua")
		use("hrsh7th/cmp-path")
		-- snippets
		use("L3MON4D3/LuaSnip")
		-- tree sitter
		use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
		-- color scheme
		use("navarasu/onedark.nvim")
		use({ "nvim-tree/nvim-web-devicons" })
		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				"nvim-tree/nvim-web-devicons",
				opt = true,
			},
		})
		-- fuzzy search
		use({
			"ibhagwan/fzf-lua",
			requires = { "nvim-tree/nvim-web-devicons" },
		})
		-- tpope
		use("tpope/vim-commentary")
		use("tpope/vim-fugitive")
		use("tpope/vim-repeat")
		use("tpope/vim-surround")
		-- other
		use("airblade/vim-gitgutter")
		use("mbbill/undotree")
		use("nvim-treesitter/playground")
		use("windwp/nvim-autopairs")
		use("windwp/nvim-ts-autotag")
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
