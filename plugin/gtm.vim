if exists('g:gtm_loaded') || &cp
  finish
endif
let g:gtm_loaded = 1

let s:last_update = 0
let s:last_file = ""
let s:update_interval = 30
let s:cmd = "silent !gtm record"

function! s:record()
  let fpath = expand("%:p")
  if s:last_file != fpath || localtime() - s:last_update > s:update_interval
    exec s:cmd shellescape(fpath)
    let s:last_update = localtime()
    let s:last_file = fpath
  endif
endfunction

augroup gtm
  autocmd!
  autocmd BufReadPost,BufWritePost,CursorMoved,CursorMovedI * call s:record()
augroup END
