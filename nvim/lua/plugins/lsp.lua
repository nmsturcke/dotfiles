return function(use)
    use "neovim/nvim-lspconfig"

    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    }

    use {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- "pyright",
                    -- "ts_ls",
                    "rust_analyzer",
                },
                automatic_installation = true,
            })

            -- -- Setup LSP servers
            -- local lspconfig = require("lspconfig")

            -- require("mason-lspconfig").setup_handlers({
            --     -- Default handler
            --     function(server_name)
            --         lspconfig[server_name].setup({})
            --     end,
            -- })
        end,
    }

    use {
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
    }
end
