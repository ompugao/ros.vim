if &cp || (exists('g:loaded_ros_vim') && g:loaded_ros_vim)
    finish
endif
let g:loaded_ros_vim = 1

function! s:RosPackList(arg_lead,cmdline,cursor_pos)
    let args = split(a:arg_lead,'/')
    if (len(args) == 0) || (len(args) == 1 && a:arg_lead[strlen(a:arg_lead)-1] != '/')
        let packs = split(system('rospack list | cut -f 1 -d" "'),"\n")
        let matches = []
        for pack in packs
            if pack =~? '^' . strpart(a:arg_lead, 0)
                call add(matches, pack )
            endif 
        endfor
        return matches
    endif

    let pkgname = args[0]
    let reldir = ''
    for i in args[1:]
      let reldir = reldir . '/' . i
    endfor
    let location = ros#RosDecodePath(pkgname)[1]
    if isdirectory(location . reldir) 
      return map(split(glob(location . reldir . '/*'),"\n"),'pkgname.v:val[strlen(location):]')
    else
      return map(split(glob(location . reldir . '*'),"\n"),'pkgname.v:val[strlen(location):]')
    endif
endfunction

command! -nargs=* -complete=customlist,s:RosPackList Roscd :call ros#RosChangeDir(<f-args>)
command! -nargs=* -complete=customlist,s:RosPackList Rosed :call ros#RosEditDir(<f-args>)
