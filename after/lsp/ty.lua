local h = require("helpers")

local python_prefix = h.get_python_path().prefix
print("Python prefix for ty:", python_prefix)

return {
    cmd_env = {
        VIRTUAL_ENV = python_prefix,
    },
}
