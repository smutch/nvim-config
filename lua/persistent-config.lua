local M = {}

local toml = require "toml"
local path = require "plenary.path"

M.config_file = path.new(vim.api.nvim_list_runtime_paths()[1]) / "persistent_config.toml"

function M.read()
    local success
    local settings = {}
    if M.config_file:exists() then
        local tomlStr = M.config_file:read()
        success, settings = pcall(toml.decode, tomlStr)
    end

    if not success then
        vim.api.nvim_err_writeln("Failed to decode persistent config file.")
    end

    return success, settings
end

function M.write(settings)
    local success, tomlStr = pcall(toml.encode, settings)
    if not success then
        vim.api.nvim_err_writeln("Failed to encode persistent config file.")
        return false
    end

    M.config_file:write(tomlStr, "w")

    return true
end

return M
