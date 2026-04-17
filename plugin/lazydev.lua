vim.pack.add(require("load").gh({ "folke/lazydev.nvim" }))

require("load").on_event("FileType~lua", function()
    require("lazydev").setup({
        debug = false,
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    })
end)
