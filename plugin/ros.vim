if &cp || (exists('g:loaded_ros_vim') && g:loaded_ros_vim)
    finish
endif
let g:loaded_ros_vim = 1

function! s:RosPackList(arg_lead,cmdline,cursor_pos)
    let packs = split(system('rospack list | cut -f 1 -d" "'),"\n")
    let matches = []
    for pack in packs
        if pack =~? '^' . strpart(a:arg_lead, 0)
            call add(matches, pack )
        endif 
    endfor
    return matches
endfunction

command! -nargs=* -complete=customlist,s:RosPackList Roscd :call ros#RosChangeDir(<f-args>)
command! -nargs=* -complete=customlist,s:RosPackList Rosed :call ros#RosEditDir(<f-args>)
