local load = require("load")

require("load").later(function()
    vim.pack.add(load.gh({ "andersevenrud/nvim_context_vt.git" }))
    require("nvim_context_vt").setup()
    vim.api.nvim_set_hl(0, "ContextVt", { link = "NonText" })
end)
