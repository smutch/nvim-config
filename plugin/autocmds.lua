-- If we have a wide window then put the preview window on the right
vim.cmd([[au BufAdd * if &previewwindow && &columns >= 160 && winnr("$") == 2 | silent! wincmd L | endif]])

