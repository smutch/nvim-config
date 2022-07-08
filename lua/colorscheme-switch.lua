local M = {}

local pconf = require "persistent-config"

function M.apply()
    local success, settings = pconf.read()
    if success and settings.colorscheme ~= nil then
        vim.cmd("colorscheme " .. settings.colorscheme)
        return true
    else
        return false
    end
end

function M.switch(scheme)
    vim.cmd("colorscheme " .. scheme)

    local success, settings = pconf.read()
    if not success then return end

    settings.colorscheme = scheme

    pconf.write(settings)
end

function M.setup()
    vim.api.nvim_create_user_command('Cs', function(opts) require"colorscheme-switch".switch(opts.args) end, { nargs = 1, complete = "color" })
end

return M
