-- initialisation
vim.o.termguicolors = true
vim.o.encoding = 'utf-8'

-- plugins
require 'plugins'
require 'helpers'

-- basic setting
vim.g.mapleader = "\\<space>"
vim.g.localleader = "\\"

vim.o.history = 1000                                 -- Store a ton of history (default is 20)
vim.o.wildmenu = true                                -- show list instead of just completing
vim.o.autoread = true                                -- Automatically re-read changed files
vim.o.hidden = true                                  -- Don't unload a buffer when abandoning it
vim.o.mouse="a"                                      -- enable mouse for all modes settings
vim.o.clipboard = vim.o.clipboard .. ',unnamedplus'  -- To work in tmux
vim.o.spelllang="en_gb"                              -- British spelling
vim.o.showmode = false                               -- Don't show the current mode

vim.o.secure = true                                  -- Secure mode for reading vimrc, exrc files etc. in current dir
vim.o.exrc = true                                    -- Allow the use of folder dependent settings

vim.g.netrw_altfile = 1                              -- Prev buffer command excludes netrw buffers

-- What to write in sessions
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,globals"

vim.o.backspace="indent,eol,start"                  -- Sane backspace
vim.o.autoindent = true                             -- Autoindent
vim.o.smartindent = false                           -- Turning this off as messes with python comment indents.
vim.o.wrap = true                                   -- Wrap lines
vim.o.linebreak = true                              -- Wrap at breaks
vim.o.textwidth=0
vim.o.wrapmargin=0
vim.o.display="lastline"
vim.o.formatoptions = vim.o.formatoptions .. "l"    -- Dont mess with the wrapping of existing lines
vim.o.expandtab = true
vim.o.tabstop=4
vim.o.shiftwidth=4                                  -- 4 spaces for tabs

vim.o.vb = false                                    -- Turn off visual beep
vim.o.laststatus=2                                  -- Always display a status line
vim.o.cmdheight=1                                   -- Command line height
vim.o.listchars={tab= [[▸\ ]], eol='↵', trail='·'}    -- Set hidden characters
vim.o.nonumber=1                                    -- Don't show line numbers
vim.o.pumblend=20                                   -- opacity for popupmenu

vim.o.incsearch  = true                             -- Highlight matches as you type
vim.o.hlsearch   = true                             -- Highlight matches
vim.o.showmatch  = true                             -- Show matching paren
vim.o.ignorecase = true                             -- case insensitive search
vim.o.smartcase  = true                             -- case sensitive when uc present
vim.o.gdefault   = true                             -- g flag on sed subs automatically

vim.o.backupdir="~/.nvim_backup"
vim.o.directory="~/.nvim_backup"
vim.o.undodir="/.nvim_backup/undo"                  -- where to save undo histories
vim.o.undofile = true                               -- Save undo's after file closes

-- ignores
vim.o.wildignore:append '*.o,*.obj,*.pyc,*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,Session.vim,Project.vim,tags,.tags,.sconsign.dblite,.ccls-cache'
vim.o.suffixes = '.bak,~,.o,.info,.swp,.obj'

-- Live substitution
vim.o.inccommand="nosplit"

-- Use ripgrep if possible, if not then ack, and fall back to grep if all else fails
if vim.fn.executable('rg') then
    vim.o.grepprg="set grepprg=rg --vimgrep --no-heading --smart-case --trim"
elseif vim.fn.executable('ack') then
    vim.o.grepprg="ack -s -H --nocolor --nogroup --column"
    vim.o.grepformat="%f:%l:%c:%m,%f:%l:%m"
else
    -- Grep will sometimes skip displaying the file name if you search in a
    -- singe file. Set grep program to always generate a file-name.
    vim.o.grepprg="grep -nHRI $* ."
end
nnoremap('<leader>*', ':silent grep! "<C-r><C-w>"<CR>:copen<CR>:redraw!<CR>')
vim.cmd('command! -nargs=+ -complete=file -bar Grep silent grep! <args>|copen|redraw!')
nnoremap('<leader>/', ':Grep')

-- Load up last search in buffer into the location list and open it
nnoremap('<leader>l', ':<C-u>lvim // % \\| lopen<CR>')

-- handy mapping to fold around previous search results
-- taken from http://vim.wikia.com/wiki/Folding_with_Regular_Expression
-- \z to show previous search results
-- zr to display more context
-- zm to display less
function SearchFold()
    if not vim.w.searchfold_on then
        vim.w.old_foldexpr = vim.w.foldexpr
        vim.w.old_fdm = vim.w.fdm
        vim.w.old_foldlevel = vim.w.foldlevel
        vim.w.old_foldcolumn = vim.w.foldcolumn
        vim.wo.foldexpr = '(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2'
        vim.wo.foldmethod='expr'
        vim.wo.foldlevel=0
        vim.wo.foldcolumn=2
        vim.w.searchfold_on = 1
    else
        vim.w.foldexpr = vim.w.old_foldexpr
        vim.w.foldmethod = vim.w.old_fdm
        vim.w.foldlevel = vim.w.old_foldlevel
        vim.w.foldcolumn = vim.w.old_foldcolumn
        vim.w.searchfold_on = 0
    end
end
vim.cmd('command! SearchFold call s:SearchFold()')
nnoremap('<localleader>z', ':SearchFold<CR>')

-- colorschemes
vim.cmd([[
    augroup CustomColors
        au!
        au ColorScheme * hi! link Search DiffAdd
                    \| hi! link Conceal NonText
                    \| hi! Comment cterm=italic gui=italic
        au ColorScheme onedark if &background == 'dark'
                    \| hi! Normal guifg=#d9dbda
                    \| hi! IndentBlanklineChar guifg=#2e3c44
                    \| hi! NormalNC guibg=#31353f
                    \| endif
    augroup END
]])

-- use the presence of a file to determine if we want to start in light or dark mode
local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if not file_exists("~/.vimlight") or (vim.env.LIGHT == 1) then
    vim.opt.background = 'light'
    vim.g.colors_name = 'Ayu'
else
    vim.opt.background = 'dark'
    vim.g.colors_name = 'onedark'
end

-- terminal colors
vim.g.terminal_color_0 = "#252525"
vim.g.terminal_color_1 = "#d06c76"
vim.g.terminal_color_2 = "#99c27c"
vim.g.terminal_color_3 = "#FFD740"
vim.g.terminal_color_4 = "#40C4FF"
vim.g.terminal_color_5 = "#FF4081"
vim.g.terminal_color_6 = "#59b3be"
vim.g.terminal_color_7 = "#F5F5F5"
vim.g.terminal_color_8 = "#708284"
vim.g.terminal_color_9 = "#d06c76"
vim.g.terminal_color_10 = "#99c27c"
vim.g.terminal_color_11 = "#FFD740"
vim.g.terminal_color_12 = "#40C4FF"
vim.g.terminal_color_13 = "#FF4081"
vim.g.terminal_color_14 = "#59b3be"
vim.g.terminal_color_15 = "#F5F5F5"

-- custom commands and functions

-- Remove trailing whitespace
vim.cmd([[command! TrimWhitespace execute ':%s/\s\+$// | :noh']])

-- Allow us to move to windows by number using the leader key
for ii=1,9 do
    nnoremap('<Leader>' .. ii .. ' :' .. ii .. 'wincmd w<CR>')
end

-- Allow `e` to be prefixed by a window number to use for the jump
function QFOpenInWindow()
    if vim.v.count == 0 then
        vim.cmd(".cc")
    else
        local linenumber = vim.api.nvim_win_get_cursor(0)[1]
        vim.cmd([[exec v:count . 'wincmd w']])
        vim.cmd("exec ':' " .. linenumber .. 'cc')
    end
end
vim.cmd([[autocmd FileType quickfix,qf nnoremap <buffer> e :<C-u>call QFOpenInWindow()<CR>]])

-- Edit rc files
vim.cmd([[Erc execute ':e ~/.config/nvim/init.lua']])
vim.cmd([[Ezrc execute ':e ~/.zshrc']])
vim.cmd([[Eplug execute ':e ~/.config/nvim/lua/plugins.lua']])
