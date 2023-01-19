local M = {}

local path = require "plenary.path"

M.opts = {}

local defaults = {
    config_file = path.new(vim.api.nvim_list_runtime_paths()[1]) / "persist.json",
    colorscheme = "nightfox"
}

function M.setup(opts)
    if opts and type(opts.config_file) == "string" then
        opts.config_file = path.new(opts.config_file)
    end

    M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

function M.read()
    local store = {}
    if M.opts.config_file:exists() then
        store = vim.json.decode(M.opts.config_file:read())
        if store == nil then
            vim.api.nvim_err_writeln("Failed to decode " .. M.opts.config_file)
        end
    end
    return store
end

function M.write(store)
    local str = vim.json.encode(store)
    M.opts.config_file:write(str, "w")
end

function M.colorscheme(scheme)
    local store = M.read()
    if store == nil then return end
    if scheme == nil then
        if store.colorscheme == nil then
            scheme = defaults.colorscheme
        else
            scheme = store.colorscheme
        end
    end

    vim.cmd.colorscheme(scheme)

    store.colorscheme = scheme

    M.write(store)
end

M.setup()

return M
