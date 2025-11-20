local h = require("helpers")

local interpreter_path = h.python_interpreter_path

if vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:match("^ *# /// script") then
    print("Bufname: " .. vim.api.nvim_buf_get_name(0))
    interpreter_path =
        vim.system({ "uv", "python", "find", "--script", vim.api.nvim_buf_get_name(0) }):wait().stdout:gsub("\n", "")
end

return {
    settings = {
        basedpyright = { analysis = { typeCheckingMode = "standard", disableOrganizeImports = true } },
        python = { pythonPath = interpreter_path },
    },
}
