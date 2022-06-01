local M = {}

function M.config()
    -- Extra surround mappings for particular filetypes
    -- Markdown
    vim.cmd([[autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)" "math]])
    vim.cmd([[autocmd FileType markdown let b:surround_115 = "~~\r~~" "strikeout]])
    vim.cmd([[autocmd FileType markdown let b:surround_98 = "**\r**" "bold]])
    vim.cmd([[autocmd FileType markdown let b:surround_105 = "*\r*" "italics]])
end

return M

