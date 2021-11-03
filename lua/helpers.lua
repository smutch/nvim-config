M = {}

M.bmap = function(bufnr, mode, keys, command, opts)
    opts = opts or {}
    vim.api.nvim_buf_set_keymap(bufnr, mode, keys, command, opts)
end

M.noremap = function(mode, keys, command, opts)
    opts = opts or {}
    opts['noremap'] = true
    vim.api.nvim_set_keymap(mode, keys, command, opts)
end

M.map = function(mode, keys, command, opts)
    opts = opts or {}
    vim.api.nvim_set_keymap(mode, keys, command, opts)
end

M.bnoremap = function(bufnr, mode, keys, command, opts)
    opts = opts or {}
    opts['noremap'] = true
    vim.api.nvim_buf_set_keymap(bufnr, mode, keys, command, opts)
end

M.file_exists = function(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

return M
