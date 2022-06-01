local M = {}

function M.config()
    local autopairs = require 'nvim-autopairs'
    autopairs.setup {}
    autopairs.get_rule('"""'):with_move(
        function(opts)
            return opts.char == opts.next_char:sub(1, 1)
        end
    )
end

return M
