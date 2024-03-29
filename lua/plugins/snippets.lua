return {
    { 'onsails/lspkind-nvim' },
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            local h = require 'helpers'

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

            h.noremap('i', '<C-y>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
            h.noremap('s', '<C-y>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
            h.noremap('i', '<C-Y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
            h.noremap('s', '<C-Y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
            vim.api.nvim_create_user_command("LuaSnipEdit", require("luasnip.loaders").edit_snippet_files, {})

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
            require("luasnip.loaders.from_vscode").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
        end
    },
    { 'danymat/neogen',      config = function() require('neogen').setup({ snippet_engine = "luasnip" }) end },
    {
        "chrisgrieser/nvim-scissors",
        dependencies = "nvim-telescope/telescope.nvim",
        config = function()
            require 'scissors'.setup {
                snippetDir = vim.fn.stdpath("config") .. "/lua/snippets"
            }
            vim.api.nvim_create_user_command("EditSnippet", require("scissors").editSnippet, {})
            vim.api.nvim_create_user_command("AddNewSnippet", require("scissors").addNewSnippet, {})
        end
    },
}
