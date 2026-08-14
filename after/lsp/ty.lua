local python_path = require("helpers").get_python_path()
return {
    cmd_env = {
        [python_path.kind] = python_path.prefix,
    },
}
