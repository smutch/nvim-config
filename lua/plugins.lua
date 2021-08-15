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

    -- lsp and completion
    use 'neovim/nvim-lsp'
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
    use 'ray-x/lsp_signature.nvim'
    use 'folke/lsp-trouble.nvim'
    use 'kabouzeid/nvim-lspinstall'

    -- movement
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

    -- editing
    use 'tpope/vim-repeat'
    use 'scrooloose/nerdcommenter'
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
    use 'tpope/vim-surround'
    use {'SirVer/ultisnips', requires = 'honza/vim-snippets'}
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'chrisbra/unicode.vim'
    use 'wellle/targets.vim'
    use 'bfredl/nvim-miniyank'


    -- utils
    use 'nvim-treesitter/nvim-treesitter'
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
        run = function() vim.fn['fzf#install']() end,
        requires = 'junegunn/fzf',
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
    use 'nvim-lua/plenary.nvim'
    use 'folke/todo-comments.nvim'
    use 'michaeljsmith/vim-indent-object'
    use 'norcalli/nvim-colorizer.lua'
    use 'majutsushi/tagbar'
    use 'kassio/neoterm'
    use 'christoomey/vim-tmux-navigator'
    use 'vim-test/vim-test'
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

    -- git
    use {
        'tpope/vim-fugitive',
        requires = {'tpope/vim-git', 'junegunn/gv.vim'},
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git ', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>git', ':Git<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Gstatus<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', {noremap = true})
        end
    }
    use 'lewis6991/gitsigns.nvim'
    use 'rhysd/git-messenger.vim'


    -- linting
    use 'neomake/neomake'


    -- looking good
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lua/lsp-status.nvim'
    use 'glepnir/galaxyline.nvim'
    use 'gcmt/taboo.vim'
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_char = '│'
        end
    }


    -- prose
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
    }


    -- colorschemes
    use 'navarasu/onedark.nvim'
    -- use 'KeitaNakamura/neodark.vim'


    -- filetypes
    -- python
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


    -- other
    use {
        'adamclaxon/taskpaper.vim',
        opt = true,
        ft = { 'taskpaper', 'tp' }
    }
    use {
        'lervag/vimtex',
        ft = { 'tex' }
    }
    use {
        'vim-scripts/scons.vim',
        opt = true,
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


end)
