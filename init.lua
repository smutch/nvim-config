-- system specific config
if table.getn(vim.api.nvim_get_runtime_file("lua/system.lua", false)) == 1 then require 'system' end

-- must be set before lazy plugins loaded
vim.g.mapleader = " "
vim.g.localleader = "\\"
vim.o.termguicolors = true

-- plugins
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
require("lazy").setup("plugins",
{
    -- see https://github.com/folke/lazy.nvim/issues/462
    concurrency = 64,
    checker = {
        enabled = true,
        concurrency = 8,
        frequency = 3600 * 24 * 7,
    }
}
)

require "lsp"
require "winbar"
Persist = require "persist"
local h = require "helpers"

-- load serialized options

-- basic setting {{{
vim.cmd.colorscheme = Persist.colorscheme()
vim.o.encoding = 'utf-8'

vim.o.history = 1000 -- Store a ton of history (default is 20)
vim.o.wildmenu = true -- show list instead of just completing
vim.o.autoread = true -- Automatically re-read changed files
vim.o.hidden = true -- Don't unload a buffer when abandoning it
vim.o.mouse = "a" -- enable mouse for all modes settings
vim.opt.clipboard:append{ unnamedplus = true } -- To work in tmux
vim.o.spelllang = "en_gb" -- British spelling
vim.o.showmode = false -- Don't show the current mode

vim.o.secure = true -- Secure mode for reading vimrc, exrc files etc. in current dir
vim.o.exrc = true -- Allow the use of folder dependent settings

vim.g.netrw_altfile = 1 -- Prev buffer command excludes netrw buffers

-- What to write in sessions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,globals"

vim.o.backspace = "indent,eol,start" -- Sane backspace
vim.o.autoindent = true -- Autoindent
vim.o.smartindent = false -- Turning this off as messes with python comment indents.
vim.o.wrap = true -- Wrap lines
vim.o.linebreak = true -- Wrap at breaks
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.display = "lastline"
vim.o.formatoptions = vim.o.formatoptions .. "l" -- Dont mess with the wrapping of existing lines
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4 -- 4 spaces for tabs

local version = vim.version()
if version.major > 0 or version.minor >= 7 then
    vim.o.laststatus = 3 -- Single status line for all windows
else
    vim.o.laststatus = 2 -- Always display a status line
end

vim.o.vb = false -- Turn off visual beep
vim.o.cmdheight = 1 -- Command line height
vim.opt.listchars = { tab = [[▸\ ]], eol = '↵', trail = '·' } -- Set hidden characters
vim.o.number = false -- Don't show line numbers
vim.o.pumblend = 20 -- opacity for popupmenu

vim.o.inccommand = "nosplit" -- Live substitution
vim.o.incsearch = true -- Highlight matches as you type
vim.o.hlsearch = true -- Highlight matches
vim.o.showmatch = true -- Show matching paren
vim.o.ignorecase = true -- case insensitive search
vim.o.smartcase = true -- case sensitive when uc present
vim.o.gdefault = true -- g flag on sed subs automatically

vim.o.backupdir = os.getenv('HOME') .. "/.nvim_backup"
vim.o.directory = os.getenv('HOME') .. "/.nvim_backup"
vim.o.undodir = os.getenv('HOME') .. "/.nvim_backup/undo" -- where to save undo histories
vim.o.undofile = true -- Save undo's after file closes

vim.opt.diffopt:append{ "algorithm:patience" }  -- use the patience algo for diffs

-- ignores
vim.o.wildignore = vim.o.wildignore ..
                       '*.o,*.obj,*.pyc,*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,Session.vim,Project.vim,tags,.tags,.sconsign.dblite,.ccls-cache'
vim.o.suffixes = '.bak,.o,.info,.swp,.obj'

-- by default, use the last focussed split for opening new items
vim.opt.switchbuf:append{ uselast = true }

-- }}}

-- general keybindings {{{

h.noremap('i', 'kj', '<ESC>')

-- Switch back to alternate files and tabs
h.noremap('n', '<BS><BS>', '<C-S-^>')

-- Make Y behave like other capital
h.noremap('n', 'Y', 'y$')

-- Easy on the fingers save and window manipulation bindings
h.noremap('n', '<leader>s', ':w<CR>')
h.noremap('n', '<leader>w', '<C-w>')

-- Quick switch to directory of current file
h.noremap('n', 'gcd', ':lcd %:p:h<CR>:pwd<CR>')

-- Quickly create a file in the directory of the current buffer
h.map('n', '<leader>e', ':<C-u>e <C-R>=expand("%:p:h") . "/" <CR>')

-- Leave cursor at end of yank after yanking text with lowercase y in visual mode
h.noremap('v', 'y', 'y`>')

-- Fit window height to contents and fix
vim.cmd([[command! SqueezeWindow execute('resize ' . line('$') . ' | set wfh')]])

-- Toggle to last active tab
vim.g.lasttab = 1
h.noremap('n', '<BS>t', ':exe "tabn ".g:lasttab<CR>')
vim.cmd([[au TabLeave * let g:lasttab = tabpagenr()]])

-- Disable increment number up / down - *way* too dangerous...
h.map('n', '<C-a>', '<Nop>')
h.map('n', '<C-x>', '<Nop>')

-- Turn off search highlighting
h.noremap('', [[|]], '<Esc>:<C-u>noh<CR>', { silent = true })
local ns = vim.api.nvim_create_namespace('toggle_hlsearch')
local function toggle_hlsearch(char)
  if vim.fn.mode() == 'n' then
    local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end
vim.on_key(toggle_hlsearch, ns)

-- Paste without auto indent
h.noremap('n', '<F2>', ':set invpaste paste?<CR>', {})
-- vim.opt.pastetoggle = '<F2>'

-- Toggle auto paragraph formatting
h.noremap('n', 'coa', [[:set <C-R>=(&formatoptions =~# "aw") ? 'formatoptions-=aw' : 'formatoptions+=aw'<CR><CR>]], {})

-- terminal stuff
vim.env.LAUNCHED_FROM_NVIM = 1
vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername

local term_augroup = vim.api.nvim_create_augroup("MyTerm", {})
vim.api.nvim_create_autocmd({"TermOpen"}, {
  pattern = {[[term://*]]},
  group = term_augroup,
  callback = function()
      vim.cmd.startinsert()
  end
})
vim.api.nvim_create_autocmd({"BufWinEnter","WinEnter","TermOpen"}, {
  pattern = {[[term://*]]},
  group = term_augroup,
  callback = function()
      -- local status, Color = pcall(require, "nightfox.lib.color")
      -- if(status) then
      --     local normal = vim.api.nvim_get_hl_by_name('Normal', {})
      --     normal['background'] = Color.from_hex(string.format("%06x", normal['background'])):brighten(-5):to_hex()
      --     vim.api.nvim_set_hl(0, "TermNormal", normal)
      -- end
      -- vim.wo.winhighlight = "Normal:TermNormal"
      vim.wo.cursorline = false
      vim.wo.number = false
      vim.wo.relativenumber = false
      -- vim.cmd.startinsert()
  end
})

-- vim.cmd([[
--     augroup MyTerm
--         au!
--         au BufWinEnter,WinEnter,TermOpen term://* startinsert 
--         au TermOpen * setlocal winhighlight=Normal:TermNormal | setlocal nocursorline nonumber norelativenumber
--     augroup END
-- ]])

h.map('t', 'kj', [[<C-\><C-n>]])
h.map('t', '<C-h>', [[<C-\><C-n><C-h>]])
h.map('t', '<C-j>', [[<C-\><C-n><C-j>]])
h.map('t', '<C-k>', [[<C-\><C-n><C-k>]])
h.map('t', '<C-l>', [[<C-\><C-n><C-l>]])
h.map('t', '<C-w>', [[<C-\><C-n><C-w>]])
-- h.noremap('n', '<A-h>', '<C-w><', {})
-- h.noremap('n', '<A-j>', '<C-w>+', {})
-- h.noremap('n', '<A-k>', '<C-w>-', {})
-- h.noremap('n', '<A-l>', '<C-w>>', {})
h.noremap('n', '<leader>ts', ':botright 20split | setl wfh | term<cr>')
h.noremap('n', '<leader>tv', ':botright 80vsplit | setl wfh | term<cr>')

-- }}}

-- gui specific {{{
vim.o.guifont = "JetBrainsMono Nerd Font:h11"

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0.01
    vim.g.neovide_cursor_vfx_mode = "railgun"
end
-- }}}

-- searching {{{

-- Use ripgrep if possible, if not then ack, and fall back to grep if all else fails
if vim.fn.executable('rg') then
    vim.o.grepprg = "rg --vimgrep --no-heading --smart-case --trim"
elseif vim.fn.executable('ack') then
    vim.o.grepprg = "ack -s -H --nocolor --nogroup --column"
    vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
else
    -- Grep will sometimes skip displaying the file name if you search in a
    -- singe file. Set grep program to always generate a file-name.
    vim.o.grepprg = "grep -nHRI $* ."
end
h.noremap('n', '<leader>*', [[:silent grep! "<C-r><C-w>"<CR>:Trouble quickfix<CR>]])
-- vim.cmd('command! -nargs=+ -complete=file -bar Grep silent grep! <args> | Trouble quickfix')

local function my_grep()
    local opts = {}

    if vim.bo.filetype == "oil" then
        opts = { search_dirs = { require "oil".get_current_dir() } }
    end

    require "telescope.builtin".live_grep(opts)
end

vim.keymap.set('n', '<leader>/', my_grep, {noremap=true})

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
        vim.wo.foldmethod = 'expr'
        vim.wo.foldlevel = 0
        vim.wo.foldcolumn = 2
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
h.noremap('n', '<localleader>z', ':SearchFold<CR>')

-- }}}

-- custom commands and functions {{{

-- Remove trailing whitespace
vim.cmd([[command! TrimWhitespace execute ':%s/\s\+$// | :noh']])

-- Allow us to move to windows by number using the leader key
for ii = 1, 9 do h.noremap('n', '<Leader>' .. ii, ':' .. ii .. 'wincmd w<CR>') end

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
vim.cmd([[autocmd FileType quickfix,qf nnoremap <buffer> e <cmd>lua QFOpenInWindow()<CR>]])

-- Edit rc files
vim.cmd([[command! Erc execute ':e ~/.config/nvim/init.lua']])
vim.cmd([[command! Eplug execute ':e ~/.config/nvim/lua/plugins/']])
vim.cmd([[command! Elsp execute ':e ~/.config/nvim/lua/lsp.lua']])
vim.cmd([[command! Esnip execute ':e ~/.config/nvim/lua/snippets.lua']])

-- Smart dd (https://www.reddit.com/r/neovim/comments/w0jzzv/comment/igfjx5y/?utm_source=share&utm_medium=web2x&context=3)
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return "\"_dd"
    else
        return "dd"
    end
end
vim.keymap.set('n', 'dd', smart_dd, {noremap=true, expr = true})

-- Capture output from a vim command (like :version or :messages) into a split scratch buffer.
--  (credit: ctechols, https://gist.github.com/ctechols/c6f7c900b09be5a31dc8)
--  Examples:
-- :Page version
-- :Page messages
-- :Page ls
-- It also works with the :!cmd command and Ex special characters like % (cmdline-special)
-- :Page !wc %
-- Capture and return the long output of a verbose command.
vim.cmd([[
    function! Redir(cmd)
       let output = ""
       redir =>> output
       silent exe a:cmd
       redir END
       return output
    endfunction

    " A command to open a scratch buffer.
    function! Scratch()
       split Scratch
       setlocal buftype=nofile
       setlocal bufhidden=wipe
       setlocal noswapfile
       setlocal nobuflisted
       return bufnr("%")
    endfunction

    " Put the output of a command into a scratch buffer.
    function! Page(command)
       let output = Redir(a:command)
       call Scratch()
       normal gg
       call append(1, split(output, "\n"))
    endfunction

    command! -nargs=+ -complete=command Page :call Page(<q-args>)
]])

-- scrach buffers (taken from <http://dhruvasagar.com/2014/03/11/creating-custom-scratch-buffers-in-vim>)
vim.cmd([[
    function! ScratchEdit(cmd, options)
        exe a:cmd tempname()
        setl buftype=nofile bufhidden=wipe nobuflisted
        if !empty(a:options) | exe 'setl' a:options | endif
    endfunction

    command! -bar -nargs=* Scratch call ScratchEdit('split', <q-args>)
    command! -bar -nargs=* ScratchV call ScratchEdit('vsplit', <q-args>)
]])

-- }}}

-- autocommands {{{

-- Scons files
vim.cmd([[au BufNewFile,BufRead SConscript,SConstruct set filetype=scons]])

-- cython files
vim.cmd([[au BufRead,BufNewFile *.pxd,*.pxi,*.pyx set filetype=cython]])

-- slurm files
vim.cmd([[au BufRead,BufNewFile *.slurm set filetype=slurm]])

-- Trim trailing whitespace when saving python file
vim.cmd([[au BufWritePre *.py normal m`:%s/\s\+$//e``]])

-- enable spell checking on certain files
vim.cmd([[au BufNewFile,BufRead COMMIT_EDITMSG set spell | setlocal nofoldenable]])

-- pandoc
vim.cmd([[
    augroup pandoc_syntax
        au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc | setlocal cole=0
    augroup END
]])

-- If we have a wide window then put the preview window on the right
vim.cmd([[au BufAdd * if &previewwindow && &columns >= 160 && winnr("$") == 2 | silent! wincmd L | endif]])

-- web related languages
vim.cmd([[au FileType javascript,coffee,html,css,scss,sass setlocal ts=2 sw=2]])

-- make sure all tex files are set to correct filetype
vim.cmd([[au BufNewFile,BufRead *.tex set ft=tex]])

-- make sure pbs scripts are set to the right filetype
vim.cmd([[au BufNewFile,BufRead *.{qsub,pbs} set ft=sh]])

-- c/c++ switching between source and header using clangd
vim.cmd([[au FileType c,cpp noremap gH :ClangdSwitchSourceHeader<CR>]])

-- project specific
local projects_grp = vim.api.nvim_create_augroup("Projects", {})
vim.api.nvim_create_autocmd("VimEnter", {
    group = projects_grp,
    pattern = { "/Users/smutch/work/astro/papers/mhysa/manuscript/*" },
    callback = function() vim.cmd.colorscheme "dayfox" end
})

-- }}}

-- vim: set fdm=marker:
