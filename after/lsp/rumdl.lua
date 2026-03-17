local config_path = vim.fn.stdpath('config') .. '/after/lsp/config/rumdl.toml'

return {
    cmd = { 'rumdl', 'server', '--config', config_path },
    filetypes = {
        "markdown",
        "rmd",
        "quarto"
    }
}
