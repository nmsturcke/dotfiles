return function(use)
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			local ok, treesitter = pcall(require, "nvim-treesitter")
			if ok and treesitter.setup then
				treesitter.setup({})
				require("nvim-treesitter.config").setup({
					highlight = {
						enable = true,
						additional_vim_regex_higlighting = false,
					},
					indent = { enable = true },
				})
			end
		end,
	})
end
