local map = vim.api.nvim_set_keymap
local options= { noremap = true, silent = true }

require('settings')
require('maps')

-- map
-- local map = vim.api.nvim_set_keymap
-- local options = { noremap = true, silent = true }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- use vimp to add maps
-- local vimp = require('vimp')

-- load packages
-- LazyBegin
require("lazy").setup({
	{"sbdchd/neoformat"},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	{
		'gorbit99/codewindow.nvim',
		config = function()
			local codewindow = require('codewindow')
			codewindow.setup()
			codewindow.apply_default_keybinds()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},
	{ "lukas-reineke/indent-blankline.nvim" },
	{
		"folke/neoconf.nvim",
	},
	"folke/neodev.nvim",
	{"williamboman/mason.nvim",
	config = function()
		require("mason").setup()
	end,
},
{
	"williamboman/mason-lspconfig.nvim",
	config = function()
		require("mason-lspconfig").setup()
	end,
},

{
	"neovim/nvim-lspconfig",
	config = function()
		require('lspconfig')['pylsp'].setup{
			on_attach = on_attach,
			flags = lsp_flags,
		}
		require('lspconfig')['tsserver'].setup{
			on_attach = on_attach,
			flags = lsp_flags,
		}
		require('lspconfig')['rust_analyzer'].setup{
			on_attach = on_attach,
			flags = lsp_flags,
			-- Server-specific settings...
			settings = {
				["rust-analyzer"] = {}
			}
		}
		require('lspconfig')['clangd'].setup{}

	end,
},
--  'mfussenegger/nvim-dap'
{
	"mfussenegger/nvim-dap",
	config = function ()
		-- break point
		map("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>", options)
		map("n", "<leader>db", ":lua require'dap'.continue()<CR>", options)

		vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
		vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
		vim.keymap.set('n', '<F6>', function() require('dap').step_into() end)
		vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
		vim.keymap.set('n', '<Leader>de', function() require('dap').set_breakpoint() end)
		vim.keymap.set('n', '<Leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
		vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
		vim.keymap.set('n', '<Leader>dt', function() require('dap').run_last() end)
		vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
			require('dap.ui.widgets').hover()
		end)
		vim.keymap.set({'n', 'v'}, '<Leader>dv', function()
			require('dap.ui.widgets').preview()
		end)
		vim.keymap.set('n', '<Leader>df', function()
			local widgets = require('dap.ui.widgets')
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set('n', '<Leader>ds', function()
			local widgets = require('dap.ui.widgets')
			widgets.centered_float(widgets.scopes)
		end)

		local dap = require('dap')
		dap.adapters.python = {
			type = 'executable';
			command = '/home/peng/.virtualenvs/debugpy/bin/python';
			args = { '-m', 'debugpy.adapter' };
		}
		dap.configurations.python = {
			{
				-- The first three options are required by nvim-dap
				type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = 'launch';
				name = "Launch file";

				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

				program = "${file}"; -- This configuration will launch the current file if used.
				setupCommands = {
					{
						text = '-enable-pretty-printing',
						description =  'enable pretty printing',
						ignoreFailures = false
					},
				},

				pythonPath = function()
					-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
					-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
					-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
						return cwd .. '/venv/bin/python'
					elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
						return cwd .. '/.venv/bin/python'
					else
						return '/usr/bin/python'
					end
				end;
			},
		}
		dap.adapters.cppdbg = {
			id = 'cppdbg',
			type = 'executable',
			command = '/home/peng/.local/bin/extension/debugAdapters/bin/OpenDebugAD7',
			options = {
				detached = false
			}
		}
		dap.adapters.cdbg = {
			id = 'cppdbg',
			type = 'executable',
			command = '/home/peng/.local/bin/extension/debugAdapters/bin/OpenDebugAD7',
			options = {
				detached = false
			}
		}
		dap.configurations.cpp = {

			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopAtEntry = true,
			},
			{
				name = 'Attach to gdbserver :1234',
				type = 'cppdbg',
				request = 'launch',
				MIMode = 'gdb',
				miDebuggerServerAddress = 'localhost:1234',
				miDebuggerPath = '/usr/bin/gdb',
				cwd = '${workspaceFolder}',
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
			},
		}
		dap.configurations.c = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopAtEntry = true,
			},
			{
				name = 'Attach to gdbserver :1234',
				type = 'cppdbg',
				request = 'launch',
				MIMode = 'gdb',
				miDebuggerServerAddress = 'localhost:1234',
				miDebuggerPath = '/usr/bin/gdb',
				cwd = '${workspaceFolder}',
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
			},
		}
	end
},

{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/cmp-buffer'},
{'hrsh7th/cmp-path'},
{'hrsh7th/cmp-cmdline'},
{
	'hrsh7th/nvim-cmp',
	config = function()
		-- Set up nvim-cmp.
		--
		local cmp = require'cmp'
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		cmp.event:on(
		'confirm_done',
		cmp_autopairs.on_confirm_done()
		)

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'vsnip' }, -- For vsnip users.
				-- { name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, {
				{ name = 'buffer' },
				{ name = 'orgmode'},
			})
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
			}, {
				{ name = 'buffer' },
			})
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			})
		})

		-- Set up lspconfig.
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
		require('lspconfig')['lua_ls'].setup {
			capabilities = capabilities
		}
	end,
},
{"rafamadriz/friendly-snippets"},
--{
	--	"L3MON4D3/LuaSnip",
	--	-- follow latest release.
	--	version = "<CurrentMajor>.*",
	--	-- install jsregexp (optional!).
	--	build = "make install_jsregexp",
	--	config = function()
		--		require("luasnip.loaders.from_vscode").lazy_load()
		--	end,
		--},
		{'hrsh7th/cmp-vsnip', config = function ()
			require'cmp'.setup {
				sources = {
					{ name = 'vsnip' }
				}
			}
		end},
		{
			'hrsh7th/vim-vsnip',
			config = function ()
			end
		},
		{
			'hrsh7th/vim-vsnip-integ'
		},
		{
			"nvim-treesitter/nvim-treesitter",
			run = ':TSUpdate',
			config = function()
				require'nvim-treesitter.configs'.setup {
					-- A list of parser names, or "all" (the four listed parsers should always be installed)
					ensure_installed = { "c", "lua", "vim", "help", "python" },

					-- Install parsers synchronously (only applied to `ensure_installed`)
					sync_install = true,

					-- Automatically install missing parsers when entering buffer
					-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
					auto_install = true,

					-- List of parsers to ignore installing (for "all")
					-- ignore_install = { "javascript" },

					---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
					-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

					highlight = {
						enable = true,

						-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
						-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
						-- the name of the parser)
						-- list of language that will be disabled
						disable = { "c", "rust" },
						-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
						disable = function(lang, buf)
							local max_filesize = 100 * 1024 -- 100 KB
							local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
							if ok and stats and stats.size > max_filesize then
								return true
							end
						end,
						-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
						-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
						-- Using this option may slow down your editor, and you may see some duplicate highlights.
						-- Instead of true it can also be a list of languages
						additional_vim_regex_highlighting = false,
					},
				}
			end,
		},

		{'nvim-orgmode/orgmode', config = function()
			-- init.lua

			-- Load custom treesitter grammar for org filetype
			require('orgmode').setup_ts_grammar()

			-- Treesitter configuration
			require('nvim-treesitter.configs').setup {
				-- If TS highlights are not enabled at all, or disabled via `disable` prop,
				-- highlighting will fallback to default Vim syntax highlighting
				highlight = {
					enable = true,
					-- Required for spellcheck, some LaTex highlights and
					-- code block highlights that do not have ts grammar
					additional_vim_regex_highlighting = {'org'},
				},
				ensure_installed = {'org'}, -- Or run :TSUpdate org
			}

			require('orgmode').setup({
				org_agenda_files = {'~/org/*'},
				org_default_notes_file = '~/org/note.org',
			})
		end,
	},
	{'akinsho/org-bullets.nvim', config = function()
		require('org-bullets').setup()
	end,},
	{"dhruvasagar/vim-table-mode"},
	{
		'michaelb/sniprun',
		config = function()
			map('v', 'X', ":SnipRun<CR>", options)
		end,
	},

	{ 'echasnovski/mini.nvim', version = false },
	{ 'echasnovski/mini.tabline', version = false , config = function ()
		-- code
		require('mini.tabline').setup()
	end},
	{ 'echasnovski/mini.cursorword', version = false, config = function() require('mini.cursorword').setup() end, },
	{ 'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	-- {'TimUntersberger/neogit', config = function() require('neogit').setup() end,},
	{"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
	{ 'echasnovski/mini.map', version = false, config = function() require('mini.map').setup() end, },
	{ 'echasnovski/mini.starter', version = false, config = function() require('mini.starter').setup() end, },
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require'nvim-web-devicons'.setup {
				-- your personnal icons can go here (to override)
				-- you can specify color or cterm_color instead of specifying both of them
				-- DevIcon will be appended to `name`
				override = {
					zsh = {
						icon = "",
						color = "#428850",
						cterm_color = "65",
						name = "Zsh"
					}
				};
				-- globally enable different highlight colors per icon (default to true)
				-- if set to false all icons will have the default icon's color
				color_icons = true;
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true;
				-- globally enable "strict" selection of icons - icon will be looked up in
				-- different tables, first by filename, and if not found by extension; this
				-- prevents cases when file doesn't have any extension but still gets some icon
				-- because its name happened to match some extension (default to false)
				strict = true;
				-- same as `override` but specifically for overrides by filename
				-- takes effect when `strict` is true
				override_by_filename = {
					[".gitignore"] = {
						icon = "",
						color = "#f1502f",
						name = "Gitignore"
					}
				};
				-- same as `override` but specifically for overrides by extension
				-- takes effect when `strict` is true
				override_by_extension = {
					["log"] = {
						icon = "",
						color = "#81e043",
						name = "Log"
					}
				};
			}
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
		config = function()
			require('gitsigns').setup()
		end,
	},

	"nixprime/cpsm",

	{
		'gelguy/wilder.nvim',
		config = function()
			local wilder = require('wilder')
			wilder.setup({modes = {':', '/', '?'}})
			wilder.set_option('renderer', wilder.popupmenu_renderer({
				highlighter = wilder.basic_highlighter(),
				left = {' ', wilder.popupmenu_devicons()},
				right = {' ', wilder.popupmenu_scrollbar()},
			}))
		end,
	},

	{
		"FeiyouG/command_center.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			vim.cmd "nnoremap <leader>fc <CMD>Telescope command_center<CR>"
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup()
		end,

	},
	{
		"rebelot/kanagawa.nvim",
		config = function ()
			local default_colors = require("kanagawa.colors").setup()
		end
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				vim.keymap.set("n", "]t", function()
					require("todo-comments").jump_next()
				end,
				{ desc = "Next todo comment" }),

				vim.keymap.set("n", "[t", function()
					require("todo-comments").jump_prev()
				end, { desc = "Previous todo comment" }),

				-- You can also specify a list of valid jump keywords

				vim.keymap.set("n", "]t", function()
					require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
				end, { desc = "Next error/warning todo comment" }),
			}
		end
	},
	{
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				map("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
				{silent = true, noremap = true}
				),
				map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
				{silent = true, noremap = true}
				),
				map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
				{silent = true, noremap = true}
				),
				map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
				{silent = true, noremap = true}
				),
				map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
				{silent = true, noremap = true}
				),
				map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
				{silent = true, noremap = true}
				),
			}
		end
	},
	{'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                              , branch = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim', 'tsakirist/telescope-lazy.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader> ', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
			vim.keymap.set('n', '<leader>ss', builtin.live_grep, {})
			vim.keymap.set('n', 'F', builtin.live_grep, {})
			require('telescope').setup {
				extensions = {
					fzf = {
						fuzzy = true,                    -- false will only do exact matching
						override_generic_sorter = true,  -- override the generic sorter
						override_file_sorter = true,     -- override the file sorter
						case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					lazy = {
						-- Optional theme (the extension doesn't set a default theme)
						-- theme = "ivy",
						-- Whether or not to show the icon in the first column
						show_icon = true,
						-- Mappings for the actions
						mappings = {
							open_in_browser = "<C-o>",
							open_in_file_browser = "<M-b>",
							open_in_find_files = "<C-f>",
							open_in_live_grep = "<C-g>",
							open_plugins_picker = "<C-b>", -- Works only after having called first another action
							open_lazy_root_find_files = "<C-r>f",
							open_lazy_root_live_grep = "<C-r>g",
						},
						-- Other telescope configuration options
					},
					command_center = {
						-- Your configurations go here
					}
				}
			}
			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require('telescope').load_extension('fzf')
			require("telescope").load_extension("command_center")
			-- require('telescope').extensions.notify.notify()
		end
	},
	{
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
		config = function ()
			-- examples for your init.lua

			-- disable netrw at the very start of your init.lua (strongly advised)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1


			map("n", "<leader>op", ":NvimTreeFocus<CR>", options)
			-- set termguicolors to enable highlight groups
			vim.opt.termguicolors = true

			-- empty setup using defaults
			require("nvim-tree").setup()

			-- OR setup with some options
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				view = {
					width = 30,
					mappings = {
						list = {
							{ key = "u", action = "dir_up" },
						},
					},
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
				},
			})
		end
	},
	{
		"xiyaowong/nvim-transparent",
		config = function()
			require("transparent").setup({
				enable = true, -- boolean: enable transparent
				extra_groups = { -- table/string: additional groups that should be cleared
				-- In particular, when you set it to 'all', that means all available groups

				-- example of akinsho/nvim-bufferline.lua
				"BufferLineTabClose",
				"BufferlineBufferSelected",
				"BufferLineFill",
				"BufferLineBackground",
				"BufferLineSeparator",
				"BufferLineIndicatorSelected",
			},
			exclude = {}, -- table: groups you don't want to clear
			ignore_linked_group = true, -- boolean: don't clear a group that links to another group
		})
	end
},
{
	'folke/tokyonight.nvim'
},
{
	'Chaitanyabsprip/present.nvim',
	config = function()
		require('present').setup{
			-- ... your config here
		}
	end
},
-- override neovim ui
{'stevearc/dressing.nvim'},
{
	"rcarriga/nvim-notify",
	config = function()
		require('notify').setup()
	end,
},
{
	"krady21/compiler-explorer.nvim",
	config = function()
		require("compiler-explorer").setup({
			url = "https://godbolt.org",
			infer_lang = true, -- Try to infer possible language based on file extension.
			binary_hl = "Comment", -- Highlight group for binary extmarks/virtual text.
			autocmd = {
				enable = false, -- Enable highlighting matching lines between source and assembly windows.
				hl = "Cursorline", -- Highlight group used for line match highlighting.
			},
			diagnostics = { -- vim.diagnostic.config() options for the ce-diagnostics namespace.
			underline = false,
			virtual_text = false,
			signs = false,
		},
		split = "split", -- How to split the window after the second compile (split/vsplit).
		spinner_frames = { "⣼", "⣹", "⢻", "⠿", "⡟", "⣏", "⣧", "⣶" }, -- Compiling... spinner settings.
		spinner_interval = 100,
		compiler_flags = "", -- Default flags passed to the compiler.
		job_timeout = 25000, -- Timeout for libuv job in milliseconds.
	})
end,
	},
	{
		'jghauser/mkdir.nvim'
	},
	{
		"matbme/JABS.nvim",
		config = function()
			require('jabs').setup()
			map("n", "<leader>bb", ":JABSOpen<CR>", options)
		end,
	},
	{"kevinhwang91/promise-async"},
	{
		'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async',
		config = function()

			vim.o.foldcolumn = '1' -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			require('ufo').setup({
				provider_selector = function(bufnr, filetype, buftype)
					return {'treesitter', 'indent'}
				end
			})
			--
		end,
	},
	{
		"numToStr/FTerm.nvim",
		config = function()
			require'FTerm'.setup({
				border = 'double',
				dimensions  = {
					height = 0.9,
					width = 0.9,
				},
			})

			-- Example keybindings
			vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
			vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
		end
	},
	{
		"sindrets/diffview.nvim",
	},
	{
		"tpope/vim-repeat",
	},
	{
		'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
			map("n", "<leader>gw", ":HopWord<CR>", options)
			-- map("n", "/", ":HopPattern<CR>", options)
			map("n", "<leader>ga", ":HopAnywhere<CR>", options)
			map("n", "<leader>gl", ":HopLine<CR>", options)
		end
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			-- Utilities for creating configurations
			local util = require "formatter.util"
			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			require("formatter").setup {
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = {
					-- Formatter configurations for filetype "lua" go here
					-- and will be executed in order
					lua = {
						-- "formatter.filetypes.lua" defines default configurations for the
						-- "lua" filetype
						require("formatter.filetypes.lua").stylua,
						-- You can also define your own configuration
						function()
							-- Supports conditional formatting
							if util.get_current_buffer_file_name() == "special.lua" then
								return nil
							end
							-- Full specification of configurations is down below and in Vim help
							-- files
							return {
								exe = "stylua",
								args = {
									"--search-parent-directories",
									"--stdin-filepath",
									util.escape_path(util.get_current_buffer_file_path()),
									"--",
									"-",
								},
								stdin = true,
							}
						end
					},
					-- Use the special "*" filetype for defining formatter configurations on
					-- any filetype
					["*"] = {
						-- "formatter.filetypes.any" defines default configurations for any
						-- filetype
						require("formatter.filetypes.any").remove_trailing_whitespace
					}
				}
			}
		end,
	},
	{
		"axieax/urlview.nvim",
		config = function()
			require("urlview").setup({
				-- custom configuration options --
				vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
			})
		end,
	},
	"Konfekt/vim-wsl-copy-paste",
	{
		"f-person/git-blame.nvim",
	},
	{
		"MunifTanjim/nui.nvim",
	},
	{
		"jackMort/ChatGPT.nvim",
		config = function()
			require("chatgpt").setup({
				-- optional configuration
			})
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},
	"tpope/vim-rsi",
	-- LazyEnd
})

-- lsp config


-- vertical preview = 1
vim.cmd("set cmdheight=1")

-- colorscheme
vim.cmd("colorscheme tokyonight-storm")


vim.cmd("imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'")
vim.cmd("smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'")
vim.cmd("imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
vim.cmd("smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
vim.cmd("imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.cmd("smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'")
vim.cmd("imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")
vim.cmd("smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'")
