local M = {}

function M.config()
    vim.g.dispatch_compilers = { python = 'python %' }

    -- remove iterm from the list of handlers (don't like it removing focus when run)
    vim.g.dispatch_handlers = { 'tmux', 'screen', 'windows', 'x11', 'headless' }
end

return M

