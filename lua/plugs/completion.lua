return {
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets", { "L3MON4D3/LuaSnip", version = "v2.*" } },

        -- use a release tag to download pre-built binaries
        version = "v0.*",

        config = function()
            require("plugs.config.completion")
        end,
    },
}
