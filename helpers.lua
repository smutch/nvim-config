function nnoremap(keys, command, opts)
    opts = opts or {}
    opts['noremap'] = true
    vim.api.nvim_set_keymap('n', keys, command, opts)
end

function inoremap(keys, command, opts)
    opts = opts or {}
    opts['noremap'] = true
    vim.api.nvim_set_keymap('i', keys, command, opts)
end
