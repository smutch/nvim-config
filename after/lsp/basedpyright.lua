local h = require("helpers")

local interpreter_path = h.get_python_path().interpreter

return {
    settings = {
        basedpyright = { analysis = { typeCheckingMode = "standard", disableOrganizeImports = true } },
        python = { pythonPath = interpreter_path },
    },
    handlers = { --- filter noisy notifications
        ['$/progress'] = function(err, result, ctx) -- just notify once
            if result.token == (vim.g.basedpyright_progress_token or result.token) then
                vim.g.basedpyright_progress_token = result.token
                vim.lsp.handlers['$/progress'](err, result, ctx)
            end
        end
    },
}
