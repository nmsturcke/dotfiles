return function(use)
	use("neovim/nvim-lspconfig")

	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})

	use({
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"rust_analyzer",
				},
				handlers = {
					function(server_name)
						if server_name == "ts_ls" then
							return
						end
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	})
	use({
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		after = "mason.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"ruff",
					"prettierd",
					"stylua",
				},
			})
		end,
	})
end
