if os.getenv("TMUX") then
    --- Allows ghostty progress bar to work in tmux.
    --- https://www.reddit.com/r/neovim/comments/1sacc91/comment/oe1n62i
    --- wraps message with tmux prefix so that the underlying terminal can interpret it correctly
    --- needs 'set-option -g allow-passthrough on' in tmux config
    ---@param content string
    ---@return string
    local function wrap_tmux(content)
        return string.format("\27Ptmux;%s\27\\", (content:gsub("\27", "\27\27")))
    end

    local original_ui_send = vim.api.nvim_ui_send

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_ui_send =
        ---@param content string
        function(content)
            -- Only wrap progress (OSC 9;4); terminal queries (OSC 11, DECRQSS, XTGETTCAP, ...)
            -- must go to tmux itself, otherwise their replies leak in as keypresses.
            if content:find("^\27%]9;4;") then
                content = wrap_tmux(content)
            end
            original_ui_send(content)
        end
end
