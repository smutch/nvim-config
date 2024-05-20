local Path = require 'plenary.path'

M = {}

M.file_exists = function(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


local function is_hatch_project()
    if Path:new("./pyproject.toml"):exists() then
        local head = Path:new("./pyproject.toml"):head(10)
        if string.find(head, "hatchling") then
            return true
        end
    end
    return false
end

local python_prefix = "/usr"
if vim.g.python_prefix then
    python_prefix = vim.g.python_prefix
elseif vim.env.VIRTUAL_ENV then
    python_prefix = vim.env.VIRTUAL_ENV
elseif Path:new("./poetry.lock"):exists() then
    python_prefix = string.sub(vim.fn.system('poetry env info --path'), 0, -2)
elseif Path:new("./pixi.lock"):exists() then
    python_prefix = string.sub(vim.fn.system('pixi --quiet run --locked "which python"'), 0, -13)
elseif vim.env.CONDA_PREFIX then
    python_prefix = vim.env.CONDA_PREFIX
elseif is_hatch_project() then
    python_prefix = string.sub(vim.fn.system('hatch env find'), 0, -2)
elseif Path:new(vim.env.HOME .. "/.pyenv/shims/python"):exists() then
    python_prefix = "/Users/smutch/.pyenv/shims/python"
end

local python_interpreter_path = python_prefix .. "/bin/python"
if python_prefix:sub(-#"python") == "python" then
    python_interpreter_path = python_prefix
end

M.python_interpreter_path = python_interpreter_path
M.python_prefix = python_prefix
vim.g.python_prefix = python_prefix

return M
