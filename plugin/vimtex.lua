local gh = require("load").gh

require("load").on_event("FileType~tex", function()
    vim.pack.add(gh({ "lervag/vimtex" }))
    vim.g.vimtex_compiler_latexmk = { build_dir = "./build" }
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_fold_enabled = 1
end)
