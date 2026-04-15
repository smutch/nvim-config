local gh = require("load").gh

require("load").later(function()
    vim.pack.add(gh({ "chrisgrieser/nvim-scissors" }))
    require("scissors").setup({
        snippetDir = vim.fn.stdpath("config") .. "/snippets",
    })

    vim.keymap.set("n", "<leader>se", function()
        require("scissors").editSnippet()
    end, { nnoremap = true, desc = "Snippet: Edit" })
    vim.keymap.set({ "n", "x" }, "<leader>sa", function()
        require("scissors").addNewSnippet()
    end, { noremap = true, desc = "Snippet: Add" })
end)
