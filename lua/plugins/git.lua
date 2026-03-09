return {
    { "tpope/vim-git" },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>g:", ":Git ")
            vim.keymap.set("n", "<leader>gs", ":Git<CR>")
            vim.keymap.set("n", "<leader>ga", ":Git commit -a<CR>")
            vim.keymap.set("n", "<leader>gd", ":Git diff<CR>")
            vim.keymap.set("n", "<leader>gp", ":Git pull<CR>")
            vim.keymap.set("n", "<leader>gP", ":Git push<CR>")
        end,
    },
    { "junegunn/gv.vim" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    untracked = { text = "╿" },
                },
                on_attach = function(bufnr)
                    local gs = require("gitsigns")
                    vim.keymap.set("n", "]h", gs.nav_hunk, { noremap = true })
                    vim.keymap.set("n", "[h", function()
                        gs.nav_hunk({ count = -1 })
                    end, { noremap = true })
                    vim.keymap.set("n", "ghs", gs.stage_hunk, { noremap = true })
                    vim.keymap.set("n", "ghu", gs.undo_stage_hunk, { noremap = true })
                end,
            })
        end,
    },
    { "f-person/git-blame.nvim", config = { enabled = false } },
    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        opts = {
            -- or "fzf-lua" or "snacks" or "default"
            picker = "telescope",
            -- bare Octo command opens picker of commands
            enable_builtin = true,
        },
        keys = {
            {
                "<leader>oi",
                "<CMD>Octo issue list<CR>",
                desc = "List GitHub Issues",
            },
            {
                "<leader>op",
                "<CMD>Octo pr list<CR>",
                desc = "List GitHub PullRequests",
            },
            {
                "<leader>od",
                "<CMD>Octo discussion list<CR>",
                desc = "List GitHub Discussions",
            },
            {
                "<leader>on",
                "<CMD>Octo notification list<CR>",
                desc = "List GitHub Notifications",
            },
            {
                "<leader>os",
                function()
                    require("octo.utils").create_base_search_command({ include_current_repo = true })
                end,
                desc = "Search GitHub",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/snacks.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
    -- {
    --     "jceb/jiejie.nvim",
    -- },
    {
        "NicolasGB/jj.nvim",
        opts = {},
        cmd = { "J" },
        keys = {
            {
                "<leader>jd",
                function()
                    require("jj.cmd").describe()
                end,
                desc = "JJ describe",
            },
            {
                "<leader>jl",
                function()
                    require("jj.cmd").log()
                end,
                desc = "JJ log",
            },
            {
                "<leader>je",
                function()
                    require("jj.cmd").edit()
                end,
                desc = "JJ edit",
            },
            {
                "<leader>jn",
                function()
                    require("jj.cmd").new()
                end,
                desc = "JJ new",
            },
            {
                "<leader>js",
                function()
                    require("jj.cmd").status()
                end,
                desc = "JJ status",
            },
            {
                "<leader>sj",
                function()
                    require("jj.cmd").squash()
                end,
                desc = "JJ squash",
            },
            {
                "<leader>ju",
                function()
                    require("jj.cmd").undo()
                end,
                desc = "JJ undo",
            },
            {
                "<leader>jy",
                function()
                    require("jj.cmd").redo()
                end,
                desc = "JJ redo",
            },
            {
                "<leader>jr",
                function()
                    require("jj.cmd").rebase()
                end,
                desc = "JJ rebase",
            },
            {
                "<leader>jc",
                function()
                    require("jj.cmd").commit()
                end,
                desc = "JJ commit",
            },
            {
                "<leader>jbc",
                function()
                    require("jj.cmd").bookmark_create()
                end,
                desc = "JJ bookmark create",
            },
            {
                "<leader>jbd",
                function()
                    require("jj.cmd").bookmark_delete()
                end,
                desc = "JJ bookmark delete",
            },
            {
                "<leader>jbm",
                function()
                    require("jj.cmd").bookmark_move()
                end,
                desc = "JJ bookmark move",
            },
            {
                "<leader>ja",
                function()
                    require("jj.cmd").abandon()
                end,
                desc = "JJ abandon",
            },
            {
                "<leader>jf",
                function()
                    require("jj.cmd").fetch()
                end,
                desc = "JJ fetch",
            },
            {
                "<leader>jp",
                function()
                    require("jj.cmd").push()
                end,
                desc = "JJ push",
            },
            {
                "<leader>jpr",
                function()
                    require("jj.cmd").open_pr()
                end,
                desc = "JJ open PR from bookmark in current revision or parent",
            },
            {
                "<leader>jpl",
                function()
                    require("jj.cmd").open_pr({ list_bookmarks = true })
                end,
                desc = "JJ open PR listing available bookmarks",
            },
            {
                "<leader>jt",
                function()
                    local cmd = require("jj.cmd")
                    cmd.j("tug")
                    cmd.log({})
                end,
                desc = "JJ tug",
            },
        },
    },
}
