-- begin by ensure packer is actually installed!
local execute = vim.api.nvim_command
local fn = vim.fn
require 'helpers'

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    execute 'packadd packer.nvim'
end

-- configure plugins
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- lsp and completion {{{
    use {
        'neovim/nvim-lsp',
        requires = {
            'kabouzeid/nvim-lspinstall', {
                'ray-x/lsp_signature.nvim',
                config = function()
                    require'lsp_signature'.setup { fix_pos = true, hint_enable = false, hint_prefix = " " }
                    vim.cmd([[hi link LspSignatureActiveParameter SpellBad]])
                end
            }, 'nvim-lua/plenary.nvim'
        },
        config = function() require 'lsp' end
    }
    use {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        config = function()
            vim.g.coq_settings = {
                -- keymap = { jump_to_mark = '<c-k>', bigger_preview = '<c-p>' },
                display = { pum = { fast_close = false } },
                auto_start = true
            }
        end
    }
    use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
    use {
        'ms-jpq/coq.thirdparty',
        branch = '3p',
        config = function()
            require("coq_3p") { { src = "nvimlua", short_name = "nLUA" }, { src = "vimtex", short_name = "vTEX" } }
        end
    }
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup {} end }
    -- }}}

    -- editing {{{
    use 'tpope/vim-rsi'
    use {
        'ggandor/lightspeed.nvim',
        config = function()
            -- These dummy mappings prevent lightspeed from implementing multi-line f/F/t/F
            -- jumps and breaking ; and ,
            vim.api.nvim_set_keymap('n', 'f', 'f', {})
            vim.api.nvim_set_keymap('n', 'F', 'F', {})
            vim.api.nvim_set_keymap('n', 't', 't', {})
            vim.api.nvim_set_keymap('n', 'T', 'T', {})
        end
    }

    use 'tpope/vim-repeat'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
            vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', {})
            vim.api.nvim_set_keymap('n', 'gcp', 'yygccp', {})
            vim.api.nvim_set_keymap('n', 'gcP', 'yygccP', {})
            vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', {})
            vim.api.nvim_set_keymap('v', 'gp', 'ygvgcp', {})
            vim.api.nvim_set_keymap('v', 'gP', 'ygvgcP', {})
        end
    }
    use {
        'junegunn/vim-easy-align',
        config = function()
            vim.api.nvim_set_keymap('v', '<Enter>', '<Plug>(EasyAlign)', {})
            vim.api.nvim_set_keymap('n', 'gA', '<Plug>(EasyAlign)', {})
        end
    }
    use {
        'jiangmiao/auto-pairs',
        config = function()
            vim.g.AutoPairsFlyMode = 0
            vim.g.AutoPairsShortcutToggle = ''
            vim.g.AutoPairsShortcutBackInsert = '<A-b>'
            vim.g.AutoPairsMapCR = 0
            vim.g.AutoPairsMapCh = 0
        end
    }
    use 'michaeljsmith/vim-indent-object'
    use {
        'tpope/vim-surround',
        config = function()
            -- Extra surround mappings for particular filetypes

            -- Markdown
            vim.cmd([[autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)" "math]])
            vim.cmd([[autocmd FileType markdown let b:surround_115 = "~~\r~~" "strikeout]])
            vim.cmd([[autocmd FileType markdown let b:surround_98 = "**\r**" "bold]])
            vim.cmd([[autocmd FileType markdown let b:surround_105 = "*\r*" "italics]])
        end
    }
    use { 'jeffkreeftmeijer/vim-numbertoggle', opt = true }
    use { 'chrisbra/unicode.vim', opt = true }
    use 'wellle/targets.vim'
    use {
        'edluffy/specs.nvim',
        config = function()
            require('specs').setup {
                popup = { inc_ms = 10, width = 50, winhl = "WildMenu", resizer = require('specs').slide_resizer }
            }
        end
    }
    -- }}}

    -- treesitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "maintained", -- one of "all", "language", or a list of languages
                highlight = {
                    enable = true, -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                    custom_captures = { ["variable"] = "Normal" },
                    additional_vim_regex_highlighting = false
                },
                incremental_selection = { enable = false },
                refactor = {
                    highlight_definitions = { enable = true },
                    highlight_current_scope = { enable = true },
                    smart_rename = { enable = true, keymaps = { smart_rename = "gR" } }
                }
            }
        end
    }
    use 'nvim-treesitter/playground'
    use {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = { markdown = 'doit', python = 'python %' }

            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = { 'tmux', 'screen', 'windows', 'x11', 'headless' }
        end
    }
    -- }}}

    -- utils {{{
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-obsession'
    use 'chrisbra/vim-diff-enhanced'
    use {
        'moll/vim-bbye',
        config = function() vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true }) end
    }
    use 'justinmk/vim-dirvish'

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { 'xiyaowong/telescope-emoji.nvim' }
        },
        config = function()
            local telescope = require 'telescope'
            telescope.setup { pickers = { find_files = { theme = "dropdown" } } }

            local extensions = { "fzf", "emoji" }
            for _, extension in ipairs(extensions) do
                telescope.load_extension(extension)
                telescope.load_extension(extension)
            end

            noremap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
            noremap('n', '<leader>fg', '<cmd>Telescope git_files<cr>')
            noremap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
            noremap('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')
            noremap('n', '<leader>f?', '<cmd>Telescope help_tags<cr>')
            noremap('n', '<leader>f:', '<cmd>Telescope commands<cr>')
            noremap('n', '<leader>fm', '<cmd>Telescope marks<cr>')
            noremap('n', '<leader>fl', '<cmd>Telescope loclist<cr>')
            noremap('n', '<leader>fq', '<cmd>Telescope quickfix<cr>')
            noremap('n', [[<leader>f"]], '<cmd>Telescope registers<cr>')
            noremap('n', '<leader>fk', '<cmd>Telescope keymaps<cr>')
            noremap('n', '<leader>ft', '<cmd>Telescope treesitter<cr>')
            noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
        end
    }

    use { 'folke/todo-comments.nvim', config = function() require("todo-comments").setup {} end }

    use { 'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end }
    use {
        'majutsushi/tagbar',
        config = function() vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {}) end,
        opt = true
    }
    use {
        'akinsho/toggleterm.nvim',
        config = function()
            local termsize = function(direction)
                if direction == "horizontal" then
                    return 20
                elseif direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end
            require("toggleterm").setup {
                -- size can be a number or function which is passed the current terminal
                function(term) termsize(term.direction) end,
                open_mapping = '<leader>ts',
                hide_numbers = true, -- hide the number column in toggleterm buffers
                shade_filetypes = { "none" },
                shade_terminals = true,
                shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
                start_in_insert = true,
                insert_mappings = false, -- whether or not the open mapping applies in insert mode
                persist_size = true,
                direction = 'horizontal',
                close_on_exit = true, -- close the terminal window when the process exits
                shell = vim.o.shell -- change the default shell
            }
            vim.api.nvim_set_keymap('n', '<leader>tv',
                                    ':ToggleTerm size=' .. termsize('vertical') .. ' direction=vertical<CR>',
                                    { noremap = true })
        end
    }

    use 'christoomey/vim-tmux-navigator'
    use 'vim-test/vim-test'
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

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
    use { 'rhysd/git-messenger.vim', opt = true }

    -- linting
    use { 'neomake/neomake', opt = true }

    -- }}}

    -- looking good {{{

    -- colorschemes {{{
    use 'navarasu/onedark.nvim'
    use { 'Shatur/neovim-ayu', opt = true }
    use {
        'projekt0n/github-nvim-theme',
        opt = true,
        config = function() require'github-theme'.setup { theme_style = 'dark' } end
    }
    -- }}}

    use 'kyazdani42/nvim-web-devicons'
    use {
        'NTBBloodbath/galaxyline.nvim',
        config = function() require 'statusline' end,
        requires = 'nvim-lua/lsp-status.nvim'
    }
    use {
        'gcmt/taboo.vim',
        config = function()
            vim.g.taboo_tab_format = " %I %f%m "
            vim.g.taboo_renamed_tab_format = " %I %l%m "
        end
    }
    use { 'lukas-reineke/indent-blankline.nvim', config = function() vim.g.indent_blankline_char = '│' end }
    use {
        'metakirby5/codi.vim',
        cmd = 'Codi',
        setup = function()
            vim.g['codi#interpreters'] =
                { python = { bin = '/usr/local/Caskroom/mambaforge/base/envs/std/bin/python' } }
            vim.g['codi#virtual_text'] = 0
        end
    }
    use { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = function() require('pqf').setup() end }
    -- }}}

    -- prose {{{
    use { 'reedes/vim-wordy', opt = true, ft = { 'markdown', 'tex', 'latex' } }
    use { 'davidbeckingsale/writegood.vim', opt = true, ft = { 'tex', 'markdown', 'latex' } }
    use { 'folke/zen-mode.nvim', config = function() require("zen-mode").setup {} end }
    -- }}}

    -- filetypes {{{

    -- python {{{
    use { 'vim-python/python-syntax', ft = { 'python' } }
    use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }
    use { 'tmhedberg/SimpylFold', ft = { 'python' } }
    use { 'anntzer/vim-cython', ft = { 'python', 'cython' } }
    -- }}}

    use { 'adamclaxon/taskpaper.vim', ft = { 'taskpaper', 'tp' } }
    use {
        'lervag/vimtex',
        ft = 'tex',
        config = function()
            -- Latex options
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = 'nvr'
        end
    }
    use { 'vim-scripts/scons.vim', ft = { 'scons' } }
    use { 'Glench/Vim-Jinja2-Syntax', ft = { 'html' } }
    use { 'mattn/emmet-vim', ft = { 'html', 'css', 'sass', 'jinja.html' } }
    use { 'cespare/vim-toml', ft = { 'toml' } }
    use { 'tikhomirov/vim-glsl', opt = true }
    use { 'DingDean/wgsl.vim', opt = true }
    use 'NoahTheDuke/vim-just'
    -- }}}

end)

-- vim: set fdm=marker:
