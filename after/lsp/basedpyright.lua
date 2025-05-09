local h = require("helpers")

return {
    settings = {
        basedpyright = { analysis = { typeCheckingMode = "standard", disableOrganizeImports = true } },
        python = { pythonPath = h.python_interpreter_path },
    },
}
