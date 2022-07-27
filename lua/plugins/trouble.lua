M = {}

M.config = function()
    require "trouble".setup()

    -- Load up last search in buffer into the location list and open it
    h.noremap('n', '<leader>L', ':<C-u>lvimgrep // % | Trouble loclist<CR>')
end

return M
