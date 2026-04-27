vim.pack.add(require("load").gh({ "folke/sidekick.nvim" }))

require("sidekick").setup({
    nes = { enabled = false },
    cli = {
        mux = {
            enabled = true,
            backend = "tmux",
        },
        tools = {
            pi = {
                cmd = {
                    "container",
                    "run",
                    "-v",
                    "~/.gitconfig:/root/.gitconfig:ro",
                    "-v",
                    "~/.pi:/root/.pi",
                    "-v",
                    "~/.agents:/root/.agents",
                    "-v",
                    ".:/workdir",
                    "--ssh",
                    "--rm",
                    "-it",
                    "pi",
                },
                -- Optional: custom keymaps for this tool
                keys = {
                    submit = {
                        "<c-s>",
                        function(t)
                            t:send("\n")
                        end,
                    },
                },
            },
        },
    },
})

local map = vim.keymap.set

-- Focus CLI
map({ "n", "t", "i", "x" }, "<C-.>", function()
    require("sidekick.cli").focus()
end, { desc = "Sidekick Focus" })

-- Toggle CLI
map("n", "<leader>aa", function()
    require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })

-- Select CLI
map("n", "<leader>as", function()
    require("sidekick.cli").select()
end, { desc = "Select CLI" })

-- Detach session
map("n", "<leader>ad", function()
    require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })

-- Send "this"
map({ "n", "x" }, "<leader>at", function()
    require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

-- Send file
map("n", "<leader>af", function()
    require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

-- Send visual selection
map("x", "<leader>av", function()
    require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

-- Prompt
map({ "n", "x" }, "<leader>ap", function()
    require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

-- Toggle Pi
map("n", "<leader>ap", function()
    require("sidekick.cli").toggle({ name = "pi", focus = true })
end, { desc = "Sidekick Toggle Pi" })
