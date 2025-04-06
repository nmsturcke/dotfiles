
-- Bootstrap packer
local ensure_packer = function()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Plugin setup
require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Rust specific plugins
    use 'simrat39/rust-tools.nvim'
    use {
        'saecki/crates.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- LSP Configuration
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Completion plugins
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- Telescope (fuzzy finder)
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- Treesitter (better syntax highlighting)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- File explorer (better than netrw)
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- Git integration
    use 'lewis6991/gitsigns.nvim'

    -- Show diagnostics
    use {
        'folke/trouble.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- Comment Toggling
    use {
        "numToStr/Comment.nvim",
        config = function ()
            require("Comment").setup()
        end
    }
    -- Theme
    use 'navarasu/onedark.nvim'
    -- Ayu Theme
    use('Shatur/neovim-ayu')

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- ChatGPT again!
    use {'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'}

    -- Waka Waka
    use 'wakatime/vim-wakatime'

    -- Prettier
    use('MunifTanjim/prettier.nvim')

    -- typescript
    use{
        "pmizio/typescript-tools.nvim",
        requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {
                on_attach = 
                    function(client, bufnr)
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                settings = {
                    jsx_close_tag = {
                        enable = true,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    }
                }
            }
        end,
    }

    -- Multi Cursor, from https://github.com/jake-stewart/multicursor.nvim 
    -- use {
    -- 'jake-stewart/multicursor.nvim',
    -- requires = { 'nvim-treesitter/nvim-treesitter' },
    -- config = function()
    -- require("multicursor").setup()
    -- vim.keymap.set('n', 'ga', require('multicursor-api').new_under_cursor, { desc = "Create a new cursor" })
    -- end
    -- }


    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Ayu Theme
require('ayu').setup({
    mirage = true,
    terminal = true,
    overrides = {},
})

-- ChatGPT: 
require('nvim-web-devicons').setup()


require("bufferline").setup{}



-- Keep your existing configuration
-- This will run when Neovim starts with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only apply this layout when starting Neovim without arguments
        if vim.fn.argc() == 0 then
            -- Use nvim-tree instead of netrw
            vim.cmd("NvimTreeOpen")

            -- Move to the right window (main editor area)
            vim.cmd("wincmd l")

            -- Create a horizontal split for the right side
            vim.cmd("split")

            -- Adjust the size of the splits if needed
            -- vim.cmd("resize 50%")

            -- Go back to the file explorer
            vim.cmd("wincmd h")
        end
    end,
    nested = true,
})

-- Map Alt+Left Arrow to exit terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "t", "<A-Left>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
})

vim.cmd("colorscheme ayu-mirage")

require('mason').setup()
require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'pylsp' }
    })

local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
    settings = {
        python = {
            pythonPath = vim.fn.exepath("python"),  -- Uses the Python from your active environment
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            }
        }
    }
})



local prettier = require("prettier")

prettier.setup({
    bin = 'prettierd',
    filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
    },
    cli_options = {
        arrow_parens = "always",
        bracket_spacing = true,
        bracket_same_line = false,
        embedded_language_formatting = "auto",
        end_of_line = "lf",
        html_whitespace_sensitivity = "css",
        -- jsx_bracket_same_line = false,
        jsx_single_quote = false,
        print_width = 80,
        prose_wrap = "preserve",
        quote_props = "as-needed",
        semi = true,
        single_attribute_per_line = false,
        single_quote = false,
        tab_width = 4,
        trailing_comma = "es5",
        use_tabs = false,
    },

})

-- Configure rust-analyzer
require('rust-tools').setup({
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
                cargo = {
                    allFeatures = true
                },
                procMacro = {
                    enable = true
                }
            }
        }
    }
})

-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'crates' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- Set up NvimTree
require('nvim-tree').setup({
    view = {
        width = 20,
    },
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true
            }
        }
    }
})

-- Enable treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = { "rust", "lua", "vim", "toml" },
    highlight = {
        enable = true,
    },
})

-- Configure crates.nvim
require('crates').setup()

-- Set up gitsigns
require('gitsigns').setup()

-- Set up trouble.nvim
require('trouble').setup()

-- Set up lualine
require('lualine').setup()

-- Format on save for Rust files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

