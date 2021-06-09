require("trouble").setup {}
require("todo-comments").setup {}
require("zen-mode").setup {}
require'lsp_signature'.on_attach({
    hint_prefix = "🎯 ",
})
