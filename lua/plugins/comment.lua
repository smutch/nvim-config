local M = {}

function M.config()
    local utils = require("Comment.utils")
    local api = require("Comment.api")
    local map = vim.keymap.set

    require('Comment').setup { ignore = '^$' }

    vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', { desc = 'Toggle comments linewise' })
    vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', { desc = 'Toggle comments in selection' })

    function _G.___gpc(vmode)
        local range = utils.get_region(vmode)
        -- print(vim.inspect(range))
        local lines = utils.get_lines(range)
        -- print(vim.inspect(lines))

        -- Copying the block
        local srow = range.erow
        vim.api.nvim_buf_set_lines(0, srow, srow, false, lines)

        -- Doing the comment
        api.comment.linewise.current(vmode)

        -- Move the cursor
        local erow = srow + 1
        local line = utils.get_lines({ srow = srow, erow = erow })
        local _, col = utils.grab_indent(line[1])
        vim.api.nvim_win_set_cursor(0, { erow, col })
    end

    vim.api.nvim_set_keymap('v', 'gpc', '<esc><cmd>call v:lua.___gpc("V")<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'gpc', '<esc><cmd>call v:lua.___gpc()<cr>', { noremap = true })


    -- extended mappings (https://github.com/numToStr/Comment.nvim/wiki/Extended-Keybindings)
    map('n', 'g>', api.call('comment.linewise', 'g@'), { expr = true, desc = 'Comment region linewise' })
    map('n', 'g>c', api.call('comment.linewise.current', 'g@$'), { expr = true, desc = 'Comment current line' })
    map('n', 'g>b', api.call('comment.blockwise.current', 'g@$'), { expr = true, desc = 'Comment current block' })

    map('n', 'g<', api.call('uncomment.linewise', 'g@'), { expr = true, desc = 'Uncomment region linewise' })
    map('n', 'g<c', api.call('uncomment.linewise.current', 'g@$'), { expr = true, desc = 'Uncomment current line' })
    map('n', 'g<b', api.call('uncomment.blockwise.current', 'g@$'), { expr = true, desc = 'Uncomment current block' })

    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

    map('x', 'g>', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.locked('comment.linewise')(vim.fn.visualmode())
    end, { desc = 'Comment region linewise (visual)' })

    map('x', 'g<', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.locked('uncomment.linewise')(vim.fn.visualmode())
    end, { desc = 'Uncomment region linewise (visual)' })
end

return M
