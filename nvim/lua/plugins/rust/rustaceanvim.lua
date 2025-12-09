-- Rustaceanvim setup
-- According to Claude this has to be before the plugin is loaded
vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			-- Enable inlay hints if supported
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end,
		default_settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
				cargo = {
					allFeatures = true,
				},
				procMacro = {
					enable = true,
				},
				inlayHints = {
					bindingModeHints = {
						enable = false,
					},
					chainingHints = {
						enable = true,
					},
					closingBraceHints = {
						enable = true,
						minLines = 25,
					},
					closureReturnTypeHints = {
						enable = "never",
					},
					lifetimeElisionHints = {
						enable = "never",
						useParameterNames = false,
					},
					maxLength = 25,
					parameterHints = {
						enable = true,
					},
					reborrowHints = {
						enable = "never",
					},
					renderColons = true,
					typeHints = {
						enable = true,
						hideClosureInitialization = false,
						hideNamedConstructor = false,
					},
				},
			},
		},
	},
}

return function(use)
	use({
		"mrcjkb/rustaceanvim",
		ft = "rust",
	})
end
