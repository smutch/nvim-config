local M = {}

function M.config()
    local h = require 'helpers'
    require 'snippets'

    function _G.luasnip_map_forward()
        local luasnip = require 'luasnip'
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            return true
        end
        return false
    end

    function _G.luasnip_map_backward()
        local luasnip = require 'luasnip'
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
            return true
        end
        return false
    end

    h.noremap('i', '<C-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
    h.noremap('s', '<C-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
    h.noremap('i', '<C-y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
    h.noremap('s', '<C-y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
end

return M
