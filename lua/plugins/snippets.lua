return {
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            local ls = require("luasnip")

            function _G.luasnip_map_forward()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                    return true
                end
                return false
            end

            function _G.luasnip_map_backward()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                    return true
                end
                return false
            end

            vim.keymap.set({'i', 's'}, '<A-j>', function() ls.expand_or_jump() end, {silent = true})
            vim.keymap.set({'i', 's'}, '<A-k>', function() ls.jump(-1) end, {silent = true})

            vim.api.nvim_create_user_command("LuaSnipEdit", require("luasnip.loaders").edit_snippet_files, {})

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
            require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
        end
    }
}
