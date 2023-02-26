# Introduction
Neovim is an open source text editor that is a fork of Vim. 
It is designed to be highly customizable and extensible, and it has a wide range of features that make it a powerful tool for editing text. 

I use folke/lazy.nvim as my package manager.

The plugin folke/lazy.nvim is a plugin for Neovim that provides an easy way to manage plugins and configuration.
It allows users to quickly install and update plugins, as well as customize their settings with a simple configuration file. 
It also provides an easy way to keep track of changes to the configuration, making it easier to keep your setup up-to-date.


# Keybindings
The leader key for this configuration is the space bar.

The following are some of the keybindings:

| Mode | Key        | remaps                                           |
|------|------------|--------------------------------------------------|
| n    | \<A-i\>     | \<CMD\>lua require("FTerm").toggle()<CR>           |
| t    | \<A-i\>      | <C-\><C-n><CMD>lua require("FTerm").toggle()<CR> |
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
| n    | X          | :SnipRun<CR>                                     |

# Some significant plugins
There are some plugins in my configuration which are really helpful and I use them frequently.

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
