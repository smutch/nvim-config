vim.bo.commentstring = "#%s"

vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>f', ':w!<CR>:!janet-format %<CR>:e<CR>',
	{ noremap = true, silent = true })
