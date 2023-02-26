# Keybindings
leader key: SPC

| Mode | Key        | remaps                                           |
|------|------------|--------------------------------------------------|
| n    | \<A-i\>     | \<CMD\>lua require("FTerm").toggle()<CR>           |
| n    | \<F9>       | :lua require'dap'.toggle_breakpoint()<CR>        |
| n    | \<leader\>bb | :JABSOpen<CR>                                    |
| n    | \<leader\>db | :lua require'dap'.continue()<CR>                 |
| n    | \<leader\>ga | :HopAnywhere<CR>                                 |
| n    | \<leader\>gl | :HopLine<CR>                                     |
| n    | \<leader\>gw | :HopWord<CR>                                     |
| n    | \<leader\>ms | :ShowMappings<CR>                                |
| n    | \<leader\>op | :NvimTreeFocus<CR>                               |
| n    | \<leader\>xd | <cmd>TroubleToggle document_diagnostics<cr>      |
| n    | \<leader\>xl | <cmd>TroubleToggle loclist<cr>                   |
| n    | \<leader\>xq | <cmd>TroubleToggle quickfix<cr>                  |
| n    | \<leader\>xw | <cmd>TroubleToggle workspace_diagnostics<cr>     |
| n    | \<leader\>xx | <cmd>TroubleToggle<cr>                           |
| n    | \u         | <Cmd>UrlView<CR>                                 |
| n    | gR         | <cmd>TroubleToggle lsp_references<cr>            |
| t    | <A-i>      | <C-\><C-n><CMD>lua require("FTerm").toggle()<CR> |
| n    | X          | :SnipRun<CR>                                     |

# Some significant plugins
- tpope/vim-rsi/ for emacs keybinding in insert mode
- Fterm for terminal
- lazy.nvim for package manager
- nvim-tree/nvim-tree.lua 
- Telescope
- SnipRun
- Mason for install lspserver
- vim-cmp 
- nvim-dap for debugging
- orgmode and org-bullets
- Glow for preview markdown
