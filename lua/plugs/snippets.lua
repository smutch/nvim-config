return {
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
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

            vim.keymap.set('i', '<A-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
            vim.keymap.set('s', '<A-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
            vim.keymap.set('i', '<A-h>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
            vim.keymap.set('s', '<A-h>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
            vim.api.nvim_create_user_command("LuaSnipEdit", require("luasnip.loaders").edit_snippet_files, {})

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
            require("luasnip.loaders.from_vscode").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
        end
    }
}
