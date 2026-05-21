local gh = require("load").gh

require("load").later(function()
    vim.pack.add(gh({
        "tpope/vim-git",
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
        "sindrets/diffview.nvim",
        "NicolasGB/jj.nvim",
    }))

    -- fugitive
    vim.keymap.set("n", "<leader>g:", ":Git ", { desc = "Fugitive: start :Git command" })
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Fugitive: git status" })
    vim.keymap.set("n", "<leader>ga", ":Git commit -a<CR>", { desc = "Fugitive: commit all changes" })
    vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { desc = "Fugitive: show git diff" })
    vim.keymap.set("n", "<leader>gp", ":Git pull<CR>", { desc = "Fugitive: pull from remote" })
    vim.keymap.set("n", "<leader>gP", ":Git push<CR>", { desc = "Fugitive: push to remote" })

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
    local jj = require("jj.cmd")
    vim.keymap.set("n", "<leader>js", jj.squash, { desc = "JJ split" })
    vim.keymap.set("n", "<leader>jc", jj.commit, { desc = "JJ commit" })
    vim.keymap.set("n", "<leader>jl", jj.log, { desc = "JJ log" })
    vim.keymap.set("n", "<leader>jd", jj.diff, { desc = "JJ diff" })
    vim.keymap.set("n", "<leader>jt", function()
        jj.j("tug")
        jj.log({})
    end, { desc = "JJ tug" })
end)
