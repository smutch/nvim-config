-- begin by ensure packer is actually installed!
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
end
require 'packer'.init({ max_jobs = 50 })


-- configure plugins
return require 'packer'.startup(function(use, use_rocks)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Utility stuff used by lots of plugins
    use 'nvim-lua/plenary.nvim'

    -- lsp {{{
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use { 'ray-x/lsp_signature.nvim', config = require "plugins.lsp_signature".config }
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'nvim-lua/lsp_extensions.nvim'
	use 'kosayoda/nvim-lightbulb'
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup() end }
    -- The rockspec for this is currently broken. Need to wait for a fix.
    -- use_rocks {'luaformatter', server = 'https://luarocks.org/dev'}
    -- }}}


    -- completion {{{
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use { 'Saecki/crates.nvim', config = function() require "crates".setup() end }
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
    use 'kdheepak/cmp-latex-symbols'
	use 'f3fora/cmp-spell'
	use 'hrsh7th/cmp-calc'
	use 'ray-x/cmp-treesitter'
	use 'hrsh7th/cmp-emoji'
	use 'hrsh7th/cmp-omni'
	use 'hrsh7th/cmp-cmdline'
    use 'lukas-reineke/cmp-under-comparator'
    use { 'hrsh7th/nvim-cmp', config = require "plugins.cmp".config }
    -- }}}

    -- snippets {{{
    use 'saadparwaiz1/cmp_luasnip'
	use 'rafamadriz/friendly-snippets'
	use 'onsails/lspkind-nvim'
    use { 'L3MON4D3/LuaSnip', config = require "plugins.luasnip".config }
    -- }}}

    -- editing {{{
    use { 'windwp/nvim-autopairs', config = require "plugins.autopairs".config }
    use { 'github/copilot.vim', opt = true, setup = require "plugins.copilot".setup }
    use 'tpope/vim-rsi'
    use { 'ggandor/lightspeed.nvim', config = require "plugins.lightspeed".config }

    use 'tpope/vim-repeat'
    use { 'numToStr/Comment.nvim', config = require "plugins.comment".config }
    use { 'junegunn/vim-easy-align', config = require "plugins.easy-align".config }
    use 'michaeljsmith/vim-indent-object'
    use { 'tpope/vim-surround', config = require "plugins.vim-surround".config }
    use { 'jeffkreeftmeijer/vim-numbertoggle', opt = true }
    use { 'chrisbra/unicode.vim', opt = true }
    use 'wellle/targets.vim'
    use { 'edluffy/specs.nvim', config = require "plugins.specs".config }
    use { 'editorconfig/editorconfig-vim', config = require "plugins.editorconfig-vim".config }
    -- }}}

    -- treesitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = 'nvim-treesitter/nvim-treesitter-textobjects',
        run = ':TSUpdate',
        config = require "plugins.nvim-treesitter".config
    }
    use { 'SmiteshP/nvim-gps', config = function() require("nvim-gps").setup() end }
    use { 'nvim-treesitter/playground', opt = true }
    use { 'tpope/vim-dispatch', config = require "plugins.vim-dispatch".config }
    -- }}}

    -- utils {{{
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup {
                post_restore_cmds = { "stopinsert" }
            }
        end
    }
    use 'chrisbra/vim-diff-enhanced'
    use {
        'moll/vim-bbye',
        config = function() vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true }) end
    }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                's1n7ax/nvim-window-picker',
                tag = "1.*",
                config = function()
                    require'window-picker'.setup({
                        filter_rules = {
                            bo = {
                                filetype = { 'neo-tree', "neo-tree-popup", "notify", "quickfix" },
                                buftype = { 'terminal' },
                            },
                        },
                        other_win_hl_color = '#e35e4f',
                    })
                end,
            }
        },
        config = function ()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

            vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
            vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
            vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
            vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

            require("neo-tree").setup({
                filesystem = {
                    window = {
                        mappings = {
                            ["-"] = "navigate_up",
                            ["<bs>"] = nil,
                            ["S"] = "split_with_window_picker",
                            ["s"] = "vsplit_with_window_picker",
                            ["<cr>"] = "open_with_window_picker"
                        }
                    }
                }
            })
            vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>Neotree reveal<cr>', { noremap = true })
        end
    }

    use "elihunter173/dirbuf.nvim"

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' },
            'xiyaowong/telescope-emoji.nvim', 'nvim-telescope/telescope-packer.nvim', {
                "AckslD/nvim-neoclip.lua",
                config = function()
                    require('neoclip').setup()
                    vim.api.nvim_set_keymap('n', '<leader>fv', '<cmd>Telescope neoclip<cr>', { noremap = true })

                    local actions = require "telescope.actions"
                    require("telescope").setup {
                        defaults = {
                            vimgrep_arguments = {
                                "rg",
                                "--color=never",
                                "--no-heading",
                                "--with-filename",
                                "--line-number",
                                "--column",
                                "--smart-case",
                            },
                            prompt_prefix = "  ",
                            selection_caret = "  ",
                            entry_prefix = "  ",
                            mappings = {
                                n = { ["q"] = actions.close },
                                i = {
                                    ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                                },
                            },
                        },
                        extensions_list = { "themes", "terms" },
                    }

                    -- vim.cmd [[hi! link TelescopeResultsTitle TodoBgNOTE]]
                    -- vim.cmd [[hi! link TelescopePromptTitle TodoBgTODO]]
                    -- vim.cmd [[hi! link TelescopePreviewTitle TodoBgHACK]]

                end
            }, 'nvim-telescope/telescope-symbols.nvim'
        },
        config = function()
            local h = require 'helpers'
            local telescope = require 'telescope'
            telescope.setup { pickers = { find_files = { theme = "dropdown" } } }

            local extensions = { "fzy_native", "packer", "emoji", "neoclip" }
            for _, extension in ipairs(extensions) do telescope.load_extension(extension) end

            h.noremap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
            h.noremap('n', '<leader>fg', '<cmd>Telescope git_files<cr>')
            h.noremap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
            h.noremap('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')
            h.noremap('n', '<leader>f?', '<cmd>Telescope help_tags<cr>')
            h.noremap('n', '<leader>f:', '<cmd>Telescope commands<cr>')
            h.noremap('n', '<leader>fm', '<cmd>Telescope marks<cr>')
            h.noremap('n', '<leader>fl', '<cmd>Telescope loclist<cr>')
            h.noremap('n', '<leader>fq', '<cmd>Telescope quickfix<cr>')
            h.noremap('n', [[<leader>f"]], '<cmd>Telescope registers<cr>')
            h.noremap('n', '<leader>fk', '<cmd>Telescope keymaps<cr>')
            h.noremap('n', '<leader>ft', '<cmd>Telescope treesitter<cr>')
            h.noremap('n', '<leader>fe', '<cmd>Telescope emoji<cr>')
            h.noremap('n', '<leader>fp', '<cmd>Telescope packer<cr>')
            h.noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
            h.noremap('n', '<leader>fs', '<cmd>Telescope symbols<cr>')
        end
    }

    use { 'folke/todo-comments.nvim', config = function() require("todo-comments").setup {} end }

    use { 'norcalli/nvim-colorizer.lua', opt = true, config = function() require 'colorizer'.setup() end }
    use {
        'majutsushi/tagbar',
        config = function() vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {}) end,
        opt = true
    }
    use 'christoomey/vim-tmux-navigator'
    use {
        'rcarriga/vim-ultest',
        requires= { 'vim-test/vim-test' },
        run = ":UpdateRemotePlugins"
    }

    use { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end }

    -- git
    use {
        'tpope/vim-fugitive',
        requires = { 'tpope/vim-git', 'junegunn/gv.vim' },
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', { noremap = true })
        end
    }
    use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
    use { 'f-person/git-blame.nvim', config = function() vim.g.gitblame_enabled = 0 end }

    -- use {
    --     "akinsho/toggleterm.nvim",
    --     tag = 'v1.*',
    --     config = function()
    --         require("toggleterm").setup()
    --     end
    -- }

    -- linting
    use { 'neomake/neomake', opt = true }

    -- docstrings
    use { 'kkoomen/vim-doge', run = ':call doge#install()',
        config = function()
            vim.g.dodge_doc_standard_python = 'google'
        end
    }

    -- }}}

    -- looking good {{{

    -- colorschemes {{{
    use { 'navarasu/onedark.nvim', opt = true }
    use { 'EdenEast/nightfox.nvim' }
    use { 'Shatur/neovim-ayu', opt = true }
    use {
        'projekt0n/github-nvim-theme',
        opt = true,
        config = function() require 'github-theme'.setup { theme_style = 'dark' } end
    }
    use { 'rmehri01/onenord.nvim' }
    -- }}}

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', 'nvim-lua/lsp-status.nvim' },
        config = function() require 'statusline' end,
    }
    use {
        'gcmt/taboo.vim',
        config = function()
            vim.g.taboo_tab_format = " %I %f%m "
            vim.g.taboo_renamed_tab_format = " %I %l%m "
        end
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                char = '│',
                show_current_context = true,
                buftype_exclude = { "terminal" }
            }
            vim.cmd [[highlight! link IndentBlanklineChar VertSplit]]
        end
    }
    use { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = function() require('pqf').setup() end }
    use {
        'petertriho/nvim-scrollbar',
        requires = 'kevinhwang91/nvim-hlslens',
        config = function()
            require("scrollbar").setup { handle = { color = "#4C566A" } }
            require("hlslens").setup({
                require("scrollbar.handlers.search").setup()
            })

            vim.cmd([[
        augroup scrollbar_search_hide
        autocmd!
        autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
        ]]   )
        end
    }
    -- }}}

    -- prose {{{
    use { 'reedes/vim-wordy', opt = true, ft = { 'markdown', 'tex', 'latex' } }
    use { 'davidbeckingsale/writegood.vim', opt = true, ft = { 'tex', 'markdown', 'latex' } }
    use { 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode', config = function() require("zen-mode").setup {} end }
    -- }}}

    -- filetypes {{{

    -- python {{{
    use { 'vim-python/python-syntax', ft = { 'python' } }
    use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }
    use { 'tmhedberg/SimpylFold', ft = { 'python' } }
    use { 'anntzer/vim-cython', ft = { 'python', 'cython' } }
    -- }}}

    use { 'adamclaxon/taskpaper.vim', opt = true, ft = { 'taskpaper', 'tp' } }
    use {
        'lervag/vimtex',
        opt = true,
        ft = 'tex',
        config = function()
            -- Latex options
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = 'nvr'
        end,
        requires = { 'jbyuki/nabla.nvim' }
    }
    use { 'vim-scripts/scons.vim', opt = true, ft = { 'scons' } }
    use { 'Glench/Vim-Jinja2-Syntax', opt = true, ft = { 'html' } }
    use { 'mattn/emmet-vim', opt = true, ft = { 'html', 'css', 'sass', 'jinja.html' } }
    use { 'cespare/vim-toml', opt = true, ft = { 'toml' } }
    use { 'tikhomirov/vim-glsl', opt = true }
    use { 'DingDean/wgsl.vim', opt = true }
    use { 'snakemake/snakemake', rtp = 'misc/vim' }
    use 'NoahTheDuke/vim-just'
    use 'alaviss/nim.nvim'
    -- }}}

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

-- vim: set fdm=marker:
