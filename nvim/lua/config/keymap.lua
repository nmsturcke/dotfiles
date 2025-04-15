vim.g.mapleader = " "

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
