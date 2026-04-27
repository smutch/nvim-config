vim.keymap.set("n", "<leader>y", function()
    local path = vim.fn.expand("%:~:.") -- Relative path
    local line = vim.fn.line(".")
    local text = path .. ":" .. line
    vim.fn.setreg("+", text)
    print("Copied: " .. text)
end, { desc = "Copy path:line" })
