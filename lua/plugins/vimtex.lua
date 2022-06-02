local M = {}

function M.config()
    -- Latex options
    vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_compiler_progname = 'nvr'
end

return M

