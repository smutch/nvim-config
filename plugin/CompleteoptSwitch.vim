function! CompleteoptSwitch()
    if exists("s:completeopt_toggle") && s:completeopt_toggle==0
        set completeopt=preview,menuone 
        let s:completeopt_toggle=1
        set completeopt?
    else
        set completeopt=menu,menuone,longest
        let s:completeopt_toggle=0
        set completeopt?
    endif
endfunction
