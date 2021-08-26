function noremap(mode, keys, command, opts)
    opts = opts or {}
    opts['noremap'] = true
    vim.api.nvim_set_keymap(mode, keys, command, opts)
end

function map(mode, keys, command, opts)
    opts = opts or {}
    vim.api.nvim_set_keymap(mode, keys, command, opts)
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
