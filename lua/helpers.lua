local Path = require("plenary.path")

M = {}

M.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
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

M.get_python_path = function()
    local default_prefix = "/usr"
    local prefix = default_prefix

    if vim.g.python_prefix then
        prefix = vim.g.python_prefix
    else
        local buf_first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
        if buf_first_line:match("^ *# */// script") then
            prefix = vim.system({ "uv", "python", "find", "--script", vim.api.nvim_buf_get_name(0) })
                :wait().stdout
                :gsub("\n", "")
            prefix = Path:new(prefix):parent():parent().filename
        elseif vim.env.VIRTUAL_ENV then
            prefix = vim.env.VIRTUAL_ENV
        elseif Path:new("./poetry.lock"):exists() then
            prefix = string.sub(vim.fn.system("poetry env info --path"), 0, -2)
        elseif Path:new("./pixi.lock"):exists() then
            prefix = string.sub(vim.fn.system('pixi --quiet run --locked "which python"'), 0, -13)
        elseif vim.env.CONDA_PREFIX then
            prefix = vim.env.CONDA_PREFIX
        elseif is_hatch_project() then
            prefix = string.sub(vim.fn.system("hatch env find"), 0, -2)
        elseif Path:new(vim.env.HOME .. "/.pyenv/shims/python"):exists() then
            prefix = "/Users/smutch/.pyenv/shims/python"
        end
    end

    local interpreter = prefix .. "/bin/python"
    if prefix:sub(-#"python") == "python" then
        interpreter = prefix
    end

    if prefix ~= default_prefix then
        vim.notify("Python interpreter: " .. interpreter, vim.log.levels.INFO)
    end

    return { interpreter = interpreter, prefix = prefix }
end

-- M.python_interpreter_path = python_interpreter_path
-- M.python_prefix = python_prefix
-- vim.g.python_prefix = python_prefix

function M.fixssh()
    local h = io.popen("tmux show-environment")
    if not h then
        return
    end
    for line in h:lines() do
        local k, v = line:match("^([^=]+)=(.*)$")
        if k and k:match("^SSH_") then
            -- remove surrounding quotes if tmux quoted them
            v = v:gsub('^"(.*)"$', "%1")
            vim.env[k] = v
        end
    end
    h:close()
    vim.notify("SSH environment imported from tmux", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("FixSSH", function()
    M.fixssh()
end, {})

return M
