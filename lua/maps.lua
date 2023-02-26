-- map
local map = vim.api.nvim_set_keymap
local options= { noremap = true, silent = true }

-- vim.keymap.set(mode, target, source, opts)

map('n', 'H', '0', options)
map('n', 'L', '$', options)
map('n', 'S', ':w<CR>', options)
map('n', 'Z', ':wq<CR>', options)
map('n', 'Q', ':q<CR>', options)

map('n', '<leader> ', ':', options)


map('n', '<leader>nc', ':e ~/.config/nvim/init.lua<CR>', options)
map('n', '<leader>bn', ':bnext<CR> ', options)
map('n', '<leader>bp', ':bprevious<CR> ', options)
map('n', '<leader>bc', ':new', options)
map('n', '<leader>bf', ':bf<CR>', options)
map('n', '<leader>bd', ':bd<CR>', options)
map('v', 'Y', '"+y', options)
map('n', 'Y', '"+y', options)
map('n', '<leader>cd', ':lcd %:p:h<CR>', options)

