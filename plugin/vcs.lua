local gh = require("load").gh

require("load").later(function()
    vim.pack.add(
        gh({
            "tpope/vim-git",
            "tpope/vim-fugitive",
            "lewis6991/gitsigns.nvim",
            "sindrets/diffview.nvim",
            "NicolasGB/jj.nvim",
        })
    )

    -- fugitive
    vim.keymap.set("n", "<leader>g:", ":Git ")
    vim.keymap.set("n", "<leader>gs", ":Git<CR>")
    vim.keymap.set("n", "<leader>ga", ":Git commit -a<CR>")
    vim.keymap.set("n", "<leader>gd", ":Git diff<CR>")
    vim.keymap.set("n", "<leader>gp", ":Git pull<CR>")
    vim.keymap.set("n", "<leader>gP", ":Git push<CR>")

    -- gitsigns
    require("gitsigns").setup({
        signs = {
            untracked = { text = "╿" },
        },
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            vim.keymap.set("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]h", bang = true })
                else
                    gs.nav_hunk("next")
                end
            end, { desc = "Go to next hunk", buffer = bufnr })

            vim.keymap.set("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[h", bang = true })
                else
                    gs.nav_hunk("prev")
                end
            end, { desc = "Go to previous hunk", buffer = bufnr })
            vim.keymap.set("n", "gH", "<cmd>Gitsigns<cr>", { noremap = true, desc = "Gitsigns menu", buffer = bufnr })
            vim.keymap.set("n", "ghs", gs.stage_hunk, { noremap = true, desc = "Stage hunk", buffer = bufnr })
            vim.keymap.set("n", "ghr", gs.reset_hunk, { noremap = true, desc = "Reset hunk", buffer = bufnr })
        end,
    })

    -- jj
    require("jj").setup({})


end)
