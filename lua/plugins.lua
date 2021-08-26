-- begin by ensure packer is actually installed!
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- configure plugins
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- lsp and completion {{{
    use {
        'neovim/nvim-lsp',
        requires = {'kabouzeid/nvim-lspinstall', 'ray-x/lsp_signature.nvim', 'nvim-lua/plenary.nvim'},
        config = function() require 'lsp' end
    }
    use {
        'hrsh7th/nvim-compe',
        config = function()
            -- Use <Tab> and <S-Tab> to navigate through popup menu
            local function t(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end
            function _G.smart_tab()
                return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
            end
            function _G.smart_shift_tab()
                return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
            end
            vim.api.nvim_set_keymap('i', '<TAB>', 'v:lua.smart_tab()', {expr = true, noremap = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})

            -- use ctrl-space for manual completion
            vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', {expr = true, noremap = true, silent = true})

            -- Set completeopt to have a better completion experience
            vim.go.completeopt = 'menuone,noinsert,noselect'

            -- Avoid showing message extra message when using completion
            vim.opt.shortmess:append({ c = true })
        end
    }
    use {
        'folke/lsp-trouble.nvim',
        config = function()
            require("trouble").setup {}
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
        'scrooloose/nerdcommenter',
        config = function()
            -- Custom NERDCommenter mappings
            vim.g.NERDCustomDelimiters = {
                scons = { left = '#' },
                jinja = { left = '<!--', right = '-->' },
                just = { left = '#' },
            }

            vim.g.NERDSpaceDelims = 1
            vim.g.NERDAltDelims_c = 1
            vim.api.nvim_set_keymap('', '<leader><leader>', '<plug>NERDCommenterToggle', {})
            vim.api.nvim_set_keymap('n', '<leader>cp', "yy:<C-u>call NERDComment('n', 'comment')<CR>p", {})
            vim.api.nvim_set_keymap('n', '<leader>cP', "yy:<C-u>call NERDComment('n', 'comment')<CR>P", {})
            vim.api.nvim_set_keymap('v', '<leader>cp', "ygv:<C-u>call NERDComment('x', 'comment')<CR>`>p", {})
            vim.api.nvim_set_keymap('v', '<leader>cP', "ygv:<C-u>call NERDComment('x', 'comment')<CR>`<P", {})
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
    use {
        'SirVer/ultisnips',
        requires = 'honza/vim-snippets',
        config = function()
            vim.g.UltiSnipsUsePythonVersion = 3
            vim.g.UltiSnipsExpandTrigger = '<C-k>'
            vim.g.UltiSnipsJumpForwardTrigger = '<C-k>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<C-j>'
            vim.g.ultisnips_python_style = 'google'
        end
    }
    use {
        'jeffkreeftmeijer/vim-numbertoggle',
        opt = true
    }
    use {
        'chrisbra/unicode.vim',
        opt = true
    }
    use 'wellle/targets.vim'
    use {
        'bfredl/nvim-miniyank',
        requires='junegunn/fzf.vim',
        config = function()
            vim.api.nvim_set_keymap('', 'p', '<Plug>(miniyank-autoput)', {})
            vim.api.nvim_set_keymap('', 'P', '<Plug>(miniyank-autoPut)', {})
            vim.api.nvim_set_keymap('', '<leader>ys', '<Plug>(miniyank-startput)', {})
            vim.api.nvim_set_keymap('', '<leader>yS', '<Plug>(miniyank-startPut)', {})
            vim.api.nvim_set_keymap('', '<leader>yn', '<Plug>(miniyank-cycle)', {})
            vim.api.nvim_set_keymap('', '<leader>yN', '<Plug>(miniyank-cycleback)', {})

            vim.cmd([[
                function! FZFYankList() abort
                  function! KeyValue(key, val)
                    let line = join(a:val[0], '\n')
                    if (a:val[1] ==# 'V')
                      let line = '\n'.line
                    endif
                    return a:key.' '.line
                  endfunction
                  return map(miniyank#read(), function('KeyValue'))
                endfunction

                function! FZFYankHandler(opt, line) abort
                  let key = substitute(a:line, ' .*', '', '')
                  if !empty(a:line)
                    let yanks = miniyank#read()[key]
                    call miniyank#drop(yanks, a:opt)
                  endif
                endfunction
                ]])

                vim.cmd([[command! YanksAfter call fzf#run(fzf#wrap('YanksAfter', {]]
                    .. [['source':  FZFYankList(),]]
                    .. [['sink':    function('FZFYankHandler', ['p']),]]
                    .. [['options': '--no-sort --prompt="Yanks-p> "' }))]]
                )

                vim.cmd([[command! YanksBefore call fzf#run(fzf#wrap('YanksBefore', {]]
                    .. [['source':  FZFYankList(),]]
                    .. [['sink':    function('FZFYankHandler', ['P']),]]
                    .. [['options': '--no-sort --prompt="Yanks-P> "', }))]]
                )

                vim.api.nvim_set_keymap('', '<leader>yp', ':YanksAfter<CR>', {})
                vim.api.nvim_set_keymap('', '<leader>yP', ':YanksBefore<CR>', {})
        end
    }
    -- }}}

    -- treesitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "maintained",     -- one of "all", "language", or a list of languages
                highlight = {
                    enable = true,              -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                    custom_captures = {
                        ["variable"] = "Normal",
                    },
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = false,
                },
                refactor = {
                    highlight_definitions = { enable = true },
                    highlight_current_scope = { enable = true },
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "gR",
                        },
                    },
                },
            }
        end
    }
    use 'nvim-treesitter/playground'
    use {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = {
                markdown = 'doit',
                python = 'python %'
            }

            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = {'tmux', 'screen', 'windows', 'x11', 'headless'}
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
        config = function()
            vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true })
        end
    }
    use 'justinmk/vim-dirvish'
    use {
        'junegunn/fzf.vim',
        requires = 'junegunn/fzf',
        run = 'cd ~/.fzf && ./install --all',
        config = function()
            -- Advanced customization using autoload functions
            vim.api.nvim_set_keymap('i', '<C-x><C-k>', 'fzf#vim#complete#word({"left": "15%"})', {noremap = true, expr = true})
            -- This is the default extra key bindings
            vim.g.fzf_action = {
                ['ctrl-t'] = 'tab split',
                ['ctrl-o'] = 'split',
                ['ctrl-v'] = 'vsplit'
            }

            -- Default fzf layout
            vim.g.fzf_layout = { up = '~40%' }

            -- Customize fzf colors to match your color scheme
            vim.g.fzf_colors = {
                fg =      {'fg', 'Normal'},
                bg =      {'bg', 'Normal'},
                hl =      {'fg', 'Comment'},
                ['fg+'] =     {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
                ['bg+'] =     {'bg', 'CursorLine', 'CursorColumn'},
                ['hl+'] =     {'fg', 'Statement'},
                info =    {'fg', 'PreProc'},
                border =  {'fg', 'Ignore'},
                prompt =  {'fg', 'Conditional'},
                pointer = {'fg', 'Exception'},
                marker =  {'fg', 'Keyword'},
                spinner = {'fg', 'Label'},
                header =  {'fg', 'Comment'}
            }

            -- For Commits and BCommits to customize the options used by 'git log':
            vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

            -- Mappings and commands
            vim.api.nvim_set_keymap('n', '<leader>fm', '<plug>(fzf-maps-n)', {})
            vim.api.nvim_set_keymap('x', '<leader>fm', '<plug>(fzf-maps-x)', {})
            vim.api.nvim_set_keymap('o', '<leader>fm', '<plug>(fzf-maps-o)', {})

            -- local function t(str)
                -- return vim.api.nvim_replace_termcodes(str, true, true, true)
            -- end
            -- vim.api.nvim_exec([[
            -- command! -bang -nargs=* Rg
            -- call fzf#vim#grep(
              -- 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
              -- <bang>0 ? fzf#vim#with_preview('up:60%')
                      -- : fzf#vim#with_preview('right:50%:hidden', '?'),
              -- <bang>0)
            -- ]], false)

            vim.api.nvim_set_keymap('n', '<leader>fb',':Buffers<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>ff',':Files %:p:h<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fhf',':History<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fh:',' :History:<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fh/',':History/<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>f:',':Commands<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fw',':Windows<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fs',':Snippets<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>f?',':Helptags<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fg',':GitFiles?<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fl',':Lines<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fL',':BLines<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>ft',':Tags<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>fT',':BTags<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>f/',':Rg<CR>', { noremap = true })

            vim.api.nvim_set_keymap('i', '<c-x><c-k>','<plug>(fzf-complete-word)', {})
            vim.api.nvim_set_keymap('i', '<c-x><c-f>','<plug>(fzf-complete-path)', {})
            vim.api.nvim_set_keymap('i', '<c-x><c-j>','<plug>(fzf-complete-file-ag)', {})
            vim.api.nvim_set_keymap('i', '<c-x><c-l>','<plug>(fzf-complete-line)', {})

            -- project files
            function _G.find_git_root()
                return vim.cmd('system("git rev-parse --show-toplevel 2> /dev/null")[:-2]')
            end
            vim.cmd('command! -bang FZFProjectFiles call fzf#vim#files(v:lua.find_git_root(), <bang>0)')
            vim.api.nvim_set_keymap('n', '<leader>fp', ':FZFProjectFiles<CR>', {noremap=true})

            -- floating fzf
            -- taken from https://github.com/junegunn/fzf.vim/issues/664#issuecomment-564267298
            vim.env.FZF_DEFAULT_OPTS = vim.env.FZF_DEFAULT_OPTS .. ' --layout=reverse'

            function _G.FloatingFZF()
                local height = vim.go.lines
                local width = vim.go.columns - (vim.go.columns * 2 / 10)
                local col = (vim.go.columns - width) / 2
                local col_offset = vim.go.columns / 10
                local opts = {
                    relative = 'editor',
                    row = 1,
                    col = math.floor(col + col_offset),
                    width = math.floor(width * 2 / 1),
                    height = math.floor(height / 2),
                    style = 'minimal'
                }
                local buf = vim.api.nvim_create_buf(false, true)
                local win = vim.api.nvim_open_win(buf, true, opts)
                vim.api.nvim_win_set_var(win, 'winhl', 'NormalFloat:TabLine')
                end

                vim.g.fzf_layout = { window = 'call v:lua.FloatingFZF()' }
        end
    }
    use {
        'folke/todo-comments.nvim',
        config = function()
            require("todo-comments").setup {}
        end
    }

    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require'colorizer'.setup()
        end
    }
    use {
        'majutsushi/tagbar',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {})
        end,
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
            require("toggleterm").setup{
                -- size can be a number or function which is passed the current terminal
                function(term)
                    termsize(term.direction)
                end,
                open_mapping = '<leader>ts',
                hide_numbers = true, -- hide the number column in toggleterm buffers
                shade_filetypes = {"none"},
                shade_terminals = true,
                shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
                start_in_insert = true,
                insert_mappings = false, -- whether or not the open mapping applies in insert mode
                persist_size = true,
                direction = 'horizontal',
                close_on_exit = true, -- close the terminal window when the process exits
                shell = vim.o.shell, -- change the default shell
            }
            vim.api.nvim_set_keymap('n', '<leader>tv', ':ToggleTerm size='.. termsize('vertical') .. ' direction=vertical<CR>', {noremap = true})
        end
    }

    use 'christoomey/vim-tmux-navigator'
    use 'vim-test/vim-test'
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

    -- git
    use {
        'tpope/vim-fugitive',
        requires = {'tpope/vim-git', 'junegunn/gv.vim'},
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git ', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', {noremap = true})
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end
    }
    use {
        'rhysd/git-messenger.vim',
        opt = true
    }

    -- linting
    use 'neomake/neomake'

    -- }}}

    -- looking good {{{

    -- colorschemes {{{
    use 'navarasu/onedark.nvim'
    use {'Shatur/neovim-ayu', opt = true}
    -- }}}

    use 'kyazdani42/nvim-web-devicons'
    use {
        'glepnir/galaxyline.nvim',
        config = function() require 'statusline' end,
        requires = 'nvim-lua/lsp-status.nvim',
    }
    use {
        'gcmt/taboo.vim',
        config = function()
            vim.g.taboo_tab_format=" %I %f%m "
            vim.g.taboo_renamed_tab_format=" %I %l%m "
        end
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_char = '│'
        end
    }
    use {
        'metakirby5/codi.vim',
        cmd = 'Codi',
        setup = function()
            vim.g['codi#interpreters'] = {
                python = {
                    bin='/usr/local/Caskroom/mambaforge/base/envs/std/bin/python'
                }
            }
            vim.g['codi#virtual_text'] = 0
        end
    }
    -- }}}

    -- prose {{{
    use {
        'reedes/vim-wordy',
        opt = true,
        ft = {'markdown', 'tex', 'latex'}
    }
    use {
        'davidbeckingsale/writegood.vim',
        opt = true,
        ft = {'tex', 'markdown', 'latex'}
    }
    use {
        'folke/zen-mode.nvim',
        config = function()
            require("zen-mode").setup {}
        end
    }
    -- }}}

    -- filetypes {{{

    -- python {{{
    use {
        'vim-python/python-syntax',
        ft = { 'python' }
    }
    use {
        'Vimjas/vim-python-pep8-indent',
        ft = { 'python'}
    }
    use {
        'tmhedberg/SimpylFold',
        ft = { 'python' }
    }
    use {
        'anntzer/vim-cython',
        ft = { 'python', 'cython' }
    }
    -- }}}

    use {
        'adamclaxon/taskpaper.vim',
        ft = { 'taskpaper', 'tp' }
    }
    use {
        'lervag/vimtex',
        ft = { 'tex' },
        config = function()
            -- Latex options
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname='nvr'
        end
    }
    use {
        'vim-scripts/scons.vim',
        ft = { 'scons' }
    }
    use {
        'Glench/Vim-Jinja2-Syntax',
        ft = { 'html' }
    }
    use {
        'mattn/emmet-vim',
        ft = { 'html', 'css', 'sass', 'jinja.html' }
    }
    use {
        'cespare/vim-toml',
        ft = { 'toml' }
    }
    use {'tikhomirov/vim-glsl', opt = true}
    use {'DingDean/wgsl.vim', opt = true}
    use 'NoahTheDuke/vim-just'
    -- }}}

end)

-- vim: set fdm=marker:
