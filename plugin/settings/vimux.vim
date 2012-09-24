" Vimux bindings
ruby << EOF
class Object
  def flush; end unless Object.new.respond_to?(:flush)
  end
EOF
let VimuxHeight = "20"
let VimuxOrientation = "v"
map <Leader>rp :PromptVimTmuxCommand<CR>
map <Leader>rl :RunLastVimTmuxCommand<CR>
map <Leader>ri :InspectVimTmuxRunner<CR>
map <Leader>rx :CloseVimTmuxPanes<CR>
map <Leader>rs :InterruptVimTmuxRunner<CR>
