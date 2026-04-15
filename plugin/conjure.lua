local gh = require("load").gh

local filetypes = { "clojure", "fennel", "racket", "janet" }

require("load").on_event("FileType~" .. table.concat(filetypes, ","), function()
    vim.pack.add(gh({ "stevearc/overseer.nvim", "gpanders/nvim-parinfer", "Olical/conjure" }))

    vim.g["conjure#debug"] = false
    vim.g["conjure#filetypes"] = { "clojure", "fennel", "racket", "janet" }
    vim.g["conjure#filetype#janet"] = "conjure.client.janet.stdio"
    vim.g["conjure#mapping#doc_word"] = "gk"

    require("conjure.main").main()
    require("conjure.mapping")["on-filetype"]()
end)
