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

    -- Formatting and linting
    use 'jose-elias-alvarez/null-ls.nvim'

    -- Theme
    use 'navarasu/onedark.nvim'

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
    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')

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

-- Set up color scheme
vim.cmd("colorscheme onedark")

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'pyright', 'pylsp' }
})


-- Set up LSP
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

-- Typescript
--lspconfig.tsserver.setup({
--init_options = ts_utils.init_options,
--on_attach = function(client, bufnr)
--ts_utils.setup({})
--ts_utils.setup_client(client)
--
--vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize", { silent = true })
--
--end,
--})


-- Javascript
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

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

null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save",
            })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
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

-- Keymappings
vim.g.mapleader = " "  -- Set space as leader key

-- Telescope
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = "Grep" })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = "Help" })

-- LSP
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = "Show hover" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Trouble
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = "Toggle diagnostics window" })

-- NvimTree
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeToggle<cr>', { desc = "Toggle file tree" })

-- Crates.nvim
vim.keymap.set('n', '<leader>ct', require('crates').toggle, { desc = "Toggle crates" })
vim.keymap.set('n', '<leader>cr', require('crates').reload, { desc = "Reload crates" })

vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)

vim.cmd [[
command! PyrightPath lua print(vim.inspect(require('lspconfig').pyright.settings))
]]
