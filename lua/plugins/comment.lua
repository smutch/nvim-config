local M = {}

function M.config()
    require('Comment').setup { mappings = { extended = true }, ignore = '^$' }
    vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', {})
    vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', {})

    local U = require("Comment.utils")
    local A = require("Comment.api")

    function _G.___gpc(vmode)
        local range = U.get_region(vmode)
        -- print(vim.inspect(range))
        local lines = U.get_lines(range)
        -- print(vim.inspect(lines))

        -- Copying the block
        local srow = range.erow
        vim.api.nvim_buf_set_lines(0, srow, srow, false, lines)

        -- Doing the comment
        A.comment_linewise_op(vmode)

        -- Move the cursor
        local erow = srow + 1
        local line = U.get_lines({ srow = srow, erow = erow })
        local _, col = U.grab_indent(line[1])
        vim.api.nvim_win_set_cursor(0, { erow, col })
    end

    vim.api.nvim_set_keymap('v', 'gpc', '<esc><cmd>call v:lua.___gpc("V")<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'gpc', '<esc><cmd>call v:lua.___gpc()<cr>', { noremap = true })
end

return M
