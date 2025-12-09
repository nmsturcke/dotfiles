return function(use)
    use {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require('conform').setup({
                notify_on_error = false,
                default_format_opts = {
                    async = true,
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
                format_after_save = function(buffer_number)
                    if vim.g.disable_autoformat or vim.b[buffer_number].disable_autoformat then
                        return
                    end
                    return {
                        async = true,
                        timeout_ms = 500,
                        lsp_format = "fallback",
                    }
                end,
                formatters_by_ft = {
                    astro = { "biome", "prettierd", stop_after_first = true },
                    javascript = { "biome", "prettierd", stop_after_first = true },
                    typescript = { "biome", "prettierd", stop_after_first = true },
                    typescriptreact = { "biome", "prettierd", stop_after_first = true },
                    svelte = { "prettierd" },
                    lua = { "stylua" },
                    python = { "black" },
                    json = { "prettierd" },
                    jsonc = { "prettierd" },
                },
                formatters = {
                    biome = {
                        condition = function(_, ctx)
                            return vim.fs.find({ "biome.json", "biome.jsonc" }, {
                                path = ctx.filename,
                                upward = true,
                                stop = vim.uv.os_homedir(),
                            })[1] ~= nil
                        end,
                    },
                    prettierd = {
                        condition = function(_, ctx)
                            return vim.fs.find({
                                ".prettierrc",
                                ".prettierrc.json",
                                ".prettierrc.js",
                                ".prettierrc.cjs",
                                ".prettierrc.mjs",
                                "prettier.config.js",
                                "prettier.config.cjs",
                                "prettier.config.mjs",
                            }, {
                                path = ctx.filename,
                                upward = true,
                                stop = vim.uv.os_homedir(),
                            })[1] ~= nil
                        end,
                    },
                },
            })
        end,
    }
end
