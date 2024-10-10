if not vim.g.vscode then return {} end

local enabled = {
  "flash.nvim",
  "vim-surround",
  "vim-repeat",
  "Comment.nvim",
  "vim-indent-object",
  "treesj",
  "nvim-parinfer",
}

return {
  defaults = {
    cond = function(plugin)
      return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
    end
  }
}
