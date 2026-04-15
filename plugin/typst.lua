local gh = require("load").gh

require("load").on_event("FileType~typst", function()
    vim.pack.add(gh({ { src = "chomosuke/typst-preview.nvim", version = vim.version.range("1.*") } }))
    require("typst-preview").setup({
        dependencies_bin = { ["tinymist"] = "tinymist" },
    })
end)
