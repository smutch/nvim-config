local h = require("helpers")

local interpreter_path = h.get_python_path().interpreter

return {
    settings = {
        basedpyright = { analysis = { typeCheckingMode = "standard", disableOrganizeImports = true } },
        python = { pythonPath = interpreter_path },
    },
}
