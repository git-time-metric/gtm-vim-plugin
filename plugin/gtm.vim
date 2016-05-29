" Git Time Metric Vim plugin
" Author: Michael Schenk
" License: MIT

if exists('g:gtm_plugin_loaded') || &cp
  finish
endif
let g:gtm_plugin_loaded = 1

let s:last_update = 0
let s:last_file = ""
let s:update_interval = 30
let s:cmd = "silent !gtm record"

function! s:record()
  let fpath = expand("%:p")
  " record if file path has changed or last update is greater than update_interval
  if s:last_file != fpath || localtime() - s:last_update > s:update_interval
    exec s:cmd shellescape(fpath)
    let s:last_update = localtime()
    let s:last_file = fpath
  endif
endfunction

augroup gtm_plugin
  autocmd!
  autocmd BufReadPost,BufWritePost,CursorMoved,CursorMovedI * call s:record()
augroup END
