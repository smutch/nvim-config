local Path = require 'plenary.path'

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


local python_prefix = "/usr"
if vim.env.VIRTUAL_ENV then
    python_prefix = vim.env.VIRTUAL_ENV
elseif Path:new("./poetry.lock"):exists() then
    python_prefix = string.sub(vim.fn.system('poetry env info --path'), 0, -2)
elseif vim.env.CONDA_PREFIX then
    python_prefix = vim.env.CONDA_PREFIX
elseif Path:new(vim.env.HOME .. "/.pyenv/shims/python"):exists() then
    python_prefix = "/Users/smutch/.pyenv/shims/python"
end

local python_interpreter_path = python_prefix .. "/bin/python"
if python_prefix:sub(-#"python") == "python" then
    python_interpreter_path = python_prefix
end

M.python_interpreter_path = python_interpreter_path
M.python_prefix = python_prefix

return M
