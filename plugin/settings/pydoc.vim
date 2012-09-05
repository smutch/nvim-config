" Pydoc

if has("gui_macvim")
    let g:pydoc_cmd = "/opt/local/bin/pydoc"
elseif has("mac")
    let g:pydoc_cmd = "/opt/local/bin/pydoc"
elseif has("unix")
    let g:pydoc_cmd = "/usr/local/python-2.7.1/bin/pydoc"
endif
