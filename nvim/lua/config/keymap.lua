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
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics<cr>', { desc = "Toggle diagnostics window" })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', { desc = "Toggle quickfix window" })
vim.keymap.set('n', '<leader>xr', '<cmd>Trouble lsp_references<cr>', { desc = "Toggle LSP references window" })

-- NvimTree
vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = "Toggle file tree" })
vim.keymap.set('n', '<leader>tf', '<cmd>NvimTreeFindFile<cr>', { desc = "Find current file in tree" })
vim.keymap.set('n', '<leader>tc', '<cmd>NvimTreeCollapse<cr>', { desc = "Collapse all directories" })

-- Crates.nvim
vim.keymap.set('n', '<leader>ct', require('crates').toggle, { desc = "Toggle crates" })
vim.keymap.set('n', '<leader>cr', require('crates').reload, { desc = "Reload crates" })

vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)

-- Transparency
-- if vim.g.neovide then
--     if vim.g.neovide_normal_opacity == 0.8 then
--         vim.keymap.set('n', '<leader>t', (vim.g.neovide_normal_opacity = 0.8)))
--     else 
--         vim.keymap.set('n', '<leader>t', vim.g.neovide_normal_opacity = 1.0)
--     end
-- end

vim.cmd [[
command! PyrightPath lua print(vim.inspect(require('lspconfig').pyright.settings))
]]
