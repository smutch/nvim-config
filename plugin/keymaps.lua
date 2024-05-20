vim.keymap.set('i', 'kj', '<ESC>')

-- Switch back to alternate files and tabs
vim.keymap.set('n', '<BS><BS>', '<C-S-^>')

-- Make Y behave like other capital
vim.keymap.set('n', 'Y', 'y$')

-- Easy on the fingers window manipulation bindings
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Quick switch to directory of current file
vim.keymap.set('n', '<leader>cd', ':lcd %:p:h<CR>:pwd<CR>')

-- Quickly create a file in the directory of the current buffer
vim.keymap.set('n', '<leader>e', ':<C-u>e <C-R>=expand("%:p:h") . "/" <CR>')

-- Leave cursor at end of yank after yanking text with lowercase y in visual mode
vim.keymap.set('v', 'y', 'y`>')

-- Fit window height to contents and fix
vim.cmd([[command! SqueezeWindow execute('resize ' . line('$') . ' | set wfh')]])

-- Toggle to last active tab
vim.g.lasttab = 1
vim.keymap.set('n', '<BS>t', ':exe "tabn ".g:lasttab<CR>')
vim.cmd([[au TabLeave * let g:lasttab = tabpagenr()]])

-- Turn off search highlighting
vim.keymap.set('', [[|]], '<Esc>:<C-u>noh<CR>', { silent = true })
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
vim.keymap.set('n', '<F2>', ':set invpaste paste?<CR>', {})

-- Toggle auto paragraph formatting
vim.keymap.set('n', 'yoa', [[:set <C-R>=(&formatoptions =~# "aw") ? 'formatoptions-=aw' : 'formatoptions+=aw'<CR><CR>]],
    {})

-- Allow us to move to windows by number using the leader key
for ii = 1, 9 do vim.keymap.set('n', '<Leader>' .. ii, ':' .. ii .. 'wincmd w<CR>') end

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

-- Smart dd (https://www.reddit.com/r/neovim/comments/w0jzzv/comment/igfjx5y/?utm_source=share&utm_medium=web2x&context=3)
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return "\"_dd"
    else
        return "dd"
    end
end
vim.keymap.set('n', 'dd', smart_dd, { noremap = true, expr = true })
