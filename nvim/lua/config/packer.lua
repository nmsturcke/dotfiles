
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

    -- Copilot
    use 'github/copilot.vim'

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

    use "IogaMaster/neocord"
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
            vim.cmd("NvimTreeResize +15")

            -- Move to the right window (main editor area)
            vim.cmd("wincmd l")

            -- Create a horizontal split for the right side
            -- vim.cmd("split")

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


require('mason').setup()
require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'pylsp' }
    })

local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
    settings = {
        python = {
            pythonPath = vim.fn.exepath("python3"),  -- Uses the Python from your active environment
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            }
        }
    }
})


-- Restart the LSP when a Python file is saved.
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {"*.py"},
    callback = function()
        vim.cmd("LspRestart pyright")
    end,
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
    ensure_installed = { "rust", "lua", "vim", "toml", "python" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})


-- Custom highlight group for f-string interpolation
vim.api.nvim_command('highlight pythonFString guifg=#88AAFF ctermfg=111')
vim.api.nvim_command('highlight pythonFStringVar guifg=#FF8866 ctermfg=209')

-- Link treesitter captures to our custom highlight groups
vim.api.nvim_command('highlight link @string.special.python pythonFString')
vim.api.nvim_command('highlight link @punctuation.special.python pythonFString')
vim.api.nvim_command('highlight link @variable.python.f_string pythonFStringVar')

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


-- The setup config table shows all available config options with their default values:
require("neocord").setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "Best Editor",              -- Text displayed when hovered over the Neovim image
    main_image          = "file",                     -- Main image display (either "neovim" or "file")
    -- client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    -- show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})

vim.api.nvim_set_hl(0, 'TSStringFBraces', { fg = '#ff5555', bold = true })
vim.api.nvim_set_hl(0, 'TSVariableSpecialFString', { fg = '#ffaa55' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.cmd([[
      highlight! link @string.fbraces TSStringFBraces
      highlight! link @variable.special.fstring TSVariableSpecialFString
    ]])
  end,
})
-- Add this to your init.lua
-- This will help us debug what highlight groups are being applied
vim.keymap.set('n', 'gx', function()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local current_node = ts_utils.get_node_at_cursor()
  
  if current_node then
    local captures = vim.treesitter.get_captures_at_cursor()
    print(vim.inspect(captures))
  end
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command('TSCheck', function()
  local ft = vim.bo.filetype
  local has_parser = pcall(vim.treesitter.get_parser, 0, ft)
  print("Filetype: " .. ft .. ", Has parser: " .. tostring(has_parser))
  
  if has_parser then
    -- Check if parser is working properly
    local parser = vim.treesitter.get_parser(0, ft)
    local tree = parser:parse()[1]
    local root = tree:root()
    local node_count = 0
    for _ in root:iter_children() do
      node_count = node_count + 1
    end
    print("Parser found " .. node_count .. " top-level nodes")
  end
end, {})

