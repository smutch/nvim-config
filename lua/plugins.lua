-- begin by ensure packer is actually installed!
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    execute 'packadd packer.nvim'
end

-- configure plugins
require'packer'.init({ max_jobs = 50 })
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Utility stuff used by lots of plugins
    use 'nvim-lua/plenary.nvim'

    -- lsp and completion {{{
    use {
        'neovim/nvim-lsp',
        event = 'InsertEnter',
        requires = {
            'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer', {
                'ray-x/lsp_signature.nvim',
                config = function()
                    require'lsp_signature'.setup { fix_pos = true, hint_enable = false, hint_prefix = " " }
                    vim.cmd([[hi link LspSignatureActiveParameter SpellBad]])
                end
            }, {
                'hrsh7th/nvim-cmp',
                requires = {
                    'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer',
                    { 'Saecki/crates.nvim', config = function() require('crates').setup() end }, 'hrsh7th/cmp-path',
                    'hrsh7th/cmp-nvim-lua', -- {'andersevenrud/compe-tmux', branch='cmp'},
                    'kdheepak/cmp-latex-symbols', 'f3fora/cmp-spell', 'hrsh7th/cmp-calc', 'ray-x/cmp-treesitter',
                    'hrsh7th/cmp-emoji', 'hrsh7th/cmp-omni', 'hrsh7th/cmp-cmdline',
                    { 'L3MON4D3/LuaSnip', config = function() require 'snippets' end }, 'saadparwaiz1/cmp_luasnip',
                    'rafamadriz/friendly-snippets', 'onsails/lspkind-nvim', {
                        'windwp/nvim-autopairs',
                        config = function()
                            require'nvim-autopairs'.setup {}
                        end
                    }, 'nvim-lua/lsp_extensions.nvim', 'kosayoda/nvim-lightbulb', {
                        'aspeddro/cmp-pandoc.nvim',
                        ft = 'markdown',
                        config = function()
                            require'cmp_pandoc'.setup()
                        end
                    },
                    'lukas-reineke/cmp-under-comparator',
                },
                config = function()
                    vim.o.completeopt = 'menu,menuone,noselect'
                    local cmp = require 'cmp'

                    local has_words_before = function()
                        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                        return col ~= 0 and
                                   vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
                                   nil
                    end

                    cmp.setup({
                        snippet = { expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end },
                        mapping = {
                            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                            ['<C-e>'] = cmp.mapping({
                                i = cmp.mapping.abort(),
                                c = cmp.mapping.close(),
                            }),
                            ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

                            ["<Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_next_item()
                                elseif has_words_before() then
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),

                            ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                else
                                    fallback()
                                end
                            end, { "i", "s" })
                        },
                        sources = {
                            { name = 'calc' }, { name = 'path' }, { name = 'nvim_lsp' }, { name = 'luasnip' },
                            { name = 'treesitter' }, { name = 'emoji' }, { name = 'buffer', keyword_length = 5 }
                        },
                        formatting = { format = require'lspkind'.cmp_format({ with_text = true, maxwidth = 50 }) },
                        experimental = { native_menu = false, ghost_text = true },
                        sorting = {
                            comparators = {
                                cmp.config.compare.offset,
                                cmp.config.compare.exact,
                                cmp.config.compare.score,
                                require "cmp-under-comparator".under,
                                cmp.config.compare.kind,
                                cmp.config.compare.sort_text,
                                cmp.config.compare.length,
                                cmp.config.compare.order,
                            },
                        }
                    })

                    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline('/', {
                        sources = {
                            { name = 'buffer' }
                        }
                    })

                    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline(':', {
                        sources = cmp.config.sources({
                            { name = 'path' }
                        }, {
                            { name = 'cmdline' }
                        }),
                        -- completion = {
                        --     -- Use <tab> or <c-space> to request completion
                        --     autocomplete = false
                        -- },
                    })

                    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
                    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '{' } }))

                    vim.cmd(
                        [[autocmd FileType lua lua require'cmp'.setup.buffer {sources = { { name = 'nvim_lua' } } }]])
                    vim.cmd([[autocmd FileType toml lua require'cmp'.setup.buffer {sources = { { name = 'crates' } } }]])
                    vim.cmd([[autocmd FileType markdown lua require'cmp'.setup.buffer {sources = { { name = 'cmp_pandoc' } } }]])
                    vim.cmd(
                        [[autocmd FileType tex lua require'cmp'.setup.buffer {sources = { { name = 'omni' } }, { name = 'latex_symbols'} }]])

                    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
                    vim.fn.sign_define('LightBulbSign', { text = "ﯧ", texthl = "", linehl="", numhl="" })

                    vim.cmd(
                    [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' 﫢 ', highlight = "NonText", enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}]])
                end
            }
        },
        config = function() require 'lsp' end
    }
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup {} end }
    use {
        'github/copilot.vim',
        opt = true,
        setup = function()
            vim.api.nvim_set_keymap('i', [[<C-j>]], [[copilot#Accept("<CR>")]],
                                    { silent = true, script = true, expr = true })
            vim.g.copilot_no_tab_map = true
        end
    }
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
            vim.api.nvim_set_keymap('v', 'gp', 'ypgvgc', {})
            vim.api.nvim_set_keymap('v', 'gP', 'ygvgc`<P', {})
        end
    }
    use {
        'junegunn/vim-easy-align',
        opt = true,
        event = 'InsertEnter',
        config = function()
            vim.api.nvim_set_keymap('v', '<Enter>', '<Plug>(EasyAlign)', {})
            vim.api.nvim_set_keymap('n', 'gA', '<Plug>(EasyAlign)', {})
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
                popup = { inc_ms = 10, width = 50, winhl = "DiffText", resizer = require('specs').slide_resizer }
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
                -- { "python", "c", "cpp", "bash", "lua", "cuda", "latex", "rst", "rust", "toml", "vim", "yaml", "json",
                -- "json5", "cmake", "glsl", "docker", "bibtex", "javascript", "html", "css" },
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
    use { 'nvim-treesitter/playground', opt = true }
    use {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = { python = 'python %' }

            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = { 'tmux', 'screen', 'windows', 'x11', 'headless' }
        end
    }
    -- }}}

    -- utils {{{
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use { 'tpope/vim-obsession', opt = true }
    use 'chrisbra/vim-diff-enhanced'
    use {
        'moll/vim-bbye',
        config = function() vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true }) end
    }
    use 'justinmk/vim-dirvish'

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' }, 'xiyaowong/telescope-emoji.nvim', 'nvim-telescope/telescope-packer.nvim' },
        config = function()
            local telescope = require 'telescope'
            local h = require 'helpers'
            telescope.setup { pickers = { find_files = { theme = "dropdown" } } }

            local extensions = { "fzy_native", "packer", "emoji" }
            for _, extension in ipairs(extensions) do
                telescope.load_extension(extension)
            end

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
            h.noremap('n', '<leader>fp', '<cmd>lua require("telescope").extensions.packer.plugins()<cr>')
            h.noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
        end
    }

    use { 'folke/todo-comments.nvim', config = function() require("todo-comments").setup {} end }

    use { 'norcalli/nvim-colorizer.lua', opt = true, config = function() require'colorizer'.setup() end }
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
    use { 'vim-test/vim-test', opt = true }
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

    use { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end }

    use {
        'dccsillag/magma-nvim',
        run = ':UpdateRemotePlugins',
        ft = 'python',
        config = function()
            local h = require 'helpers'
            h.noremap('n', '<LocalLeader>r', 'nvim_exec("MagmaEvaluateOperator", v:true)',
                      { silent = true, expr = true })
            h.noremap('n', '<LocalLeader>rr', ':MagmaEvaluateLine<CR>', { silent = true })
            h.noremap('x', '<LocalLeader>r', ':<c-u>MagmaEvaluateVisual<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>rc', ':MagmaReevaluateCell<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>rd', ':MagmaDelete<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>ro', ':MagmaShowOutput<CR>', { silent = true })

            vim.g.magma_automatically_open_output = false
        end
    }

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
    use { 'EdenEast/nightfox.nvim', opt = true }
    use { 'Shatur/neovim-ayu', opt = true }
    use {
        'projekt0n/github-nvim-theme',
        opt = true,
        config = function() require'github-theme'.setup { theme_style = 'dark' } end
    }
    use { 'rmehri01/onenord.nvim' }
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
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                char = '│',
                show_current_context = true,
                buftype_exclude = {"terminal"}
            }
            vim.cmd[[highlight! link IndentBlanklineChar VertSplit]]
        end
    }
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
        requires = {'jbyuki/nabla.nvim'}
    }
    use { 'vim-scripts/scons.vim', opt = true, ft = { 'scons' } }
    use { 'Glench/Vim-Jinja2-Syntax', opt = true, ft = { 'html' } }
    use { 'mattn/emmet-vim', opt = true, ft = { 'html', 'css', 'sass', 'jinja.html' } }
    use { 'cespare/vim-toml', opt = true, ft = { 'toml' } }
    use { 'tikhomirov/vim-glsl', opt = true }
    use { 'DingDean/wgsl.vim', opt = true }
    use 'NoahTheDuke/vim-just'
    -- }}}

end)

-- vim: set fdm=marker:
