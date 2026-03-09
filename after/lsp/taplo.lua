return {
    filetypes = { "toml" },
    root_dir = require("lspconfig.util").root_pattern(".toml", ".git"),
}
