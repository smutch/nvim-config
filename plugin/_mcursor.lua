---@diagnostic disable-next-line: param-type-mismatch
if vim.version.ge(vim.version(), vim.version.parse("0.13.0-dev")) then
    local function mcursor_next_match()
        -- get the current word under the cursor
        local current_word = vim.fn.expand("<cword>")

        -- go to the start of the current word and add a multi-cursor
        vim.fn.search("\\<\\>", "bc")
        vim.api.nvim_mcursor(0, vim.api.nvim_win_get_cursor(0))

        -- search for the next occurrence of the current word
        vim.fn.search("\\<" .. current_word .. "\\>", "W")
    end

    vim.keymap.set("n", "<M-d>", mcursor_next_match, { silent = true })

    vim.keymap.set("n", "<leader>q", function()
        local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
        vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    end)
end
