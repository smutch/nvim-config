vim.pack.add(require("load").gh({ "folke/snacks.nvim" }))

require("snacks").setup({
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    gh = { enabled = true },
    image = { enabled = true, doc = { enabled = false } },
    indent = {
        enabled = true,
        indent = {
            enabled = false,
            only_scope = true,
            only_current = true,
        },
        chunk = {
            enabled = true,
            only_current = true,
            char = {
                horizontal = "━",
                vertical = "┃",
                corner_top = "┏",
                corner_bottom = "┗",
                arrow = "━",
            },
        },
    },
    lazygit = { enabled = true },
    notifier = {
        enabled = true,
        top_down = false,
    },
    picker = {
        enabled = true,
    },
    quickfile = { enabled = true },
    scratch = {
        ft = "markdown",
    },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    styles = {
        notification = {
            style = "minimal",
            wo = { wrap = true }, -- Wrap notifications
        },
        zen = {
            backdrop = { transparent = false, blend = 40 },
        },
    },
    terminal = { enabled = true },
    zen = { enabled = true },
})

vim.keymap.set("n", "Q", function()
    Snacks.bufdelete()
end, { desc = "Delete buffer" })

vim.keymap.set("n", "<leader>ghi", function()
    Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>ghI", function()
    Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>ghp", function()
    Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>ghP", function()
    Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })

vim.keymap.set("n", "<leader>gl", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })

vim.keymap.set({ "t", "n" }, "<M-|>", function()
    Snacks.terminal.toggle(nil, { win = { position = "left" } })
end, { desc = "Toggle Terminal (left)" })
vim.keymap.set({ "t", "n" }, "<M-\\>", function()
    Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
end, { desc = "Toggle Terminal (bottom)" })
vim.keymap.set({ "n" }, "<leader>ts", function()
    Snacks.terminal.open(nil, { win = { position = "bottom" } })
end, { desc = "New Terminal (bottom)" })
vim.keymap.set({ "n" }, "<leader>tv", function()
    Snacks.terminal.open(nil, { win = { position = "left" } })
end, { desc = "New Terminal (left)" })

vim.keymap.set("n", "<leader>nh", function()
    Snacks.notifier.show_history()
end, { desc = "(N)otify (h)istory" })

vim.keymap.set("n", "<leader>nc", function()
    Snacks.notifier.hide()
end, { desc = "(N)otify (c)lear" })

vim.keymap.set("n", "<leader>.", function()
    Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S", function()
    Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })

vim.keymap.set("n", "<leader>f<leader>", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fp", function()
    Snacks.picker.projects()
end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent" })
vim.keymap.set("n", "<leader>f/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>f*", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })
vim.keymap.set("n", '<leader>f"', function()
    Snacks.picker.registers()
end, { desc = "Registers" })
vim.keymap.set("n", "<leader>f:", function()
    Snacks.picker.commands()
end, { desc = "Commands" })
vim.keymap.set("n", "<leader>fh", function()
    Snacks.picker.help()
end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>fH", function()
    Snacks.picker.highlights()
end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>fi", function()
    Snacks.picker.icons()
end, { desc = "Icons" })
vim.keymap.set("n", "<leader>fj", function()
    Snacks.picker.jumps()
end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>fk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fl", function()
    Snacks.picker.loclist()
end, { desc = "Location List" })
vim.keymap.set("n", "<leader>f,", function()
    Snacks.picker.marks()
end, { desc = "Marks" })
vim.keymap.set("n", "<leader>fR", function()
    Snacks.picker.resume()
end, { desc = "Resume" })
vim.keymap.set("n", "<leader>fu", function()
    Snacks.picker.undo()
end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>ls", function()
    Snacks.picker.lsp_symbols({ layout = { preset = "vscode", preview = "main" } })
end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>lw", function()
    Snacks.picker.lsp_workspace_symbols({ layout = { preset = "vscode", preview = "main" } })
end, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>lc", function()
    Snacks.picker.lsp_config({ layout = { preset = "vscode", preview = "main" } })
end, { desc = "LSP Configs" })
vim.keymap.set("n", "<leader>zt", function()
    Snacks.zen.zen()
end, { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>zz", function()
    Snacks.zen.zoom()
end, { desc = "Toggle Zen Mode" })

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
