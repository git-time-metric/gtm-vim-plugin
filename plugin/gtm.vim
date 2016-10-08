" Git Time Metric Vim plugin
" Author: Michael Schenk
" License: MIT

if exists('g:gtm_plugin_loaded') || &cp
  finish
endif
let g:gtm_plugin_loaded = 0

let s:gtm_ver_req = '>= 1.1.0'

let s:no_gtm_err = 'GTM exe not found, install GTM or update your path'
let s:gtm_ver_err = 'GTM exe is out of date and may not work properly, please install the latest GTM exe'
let s:gtm_url = 'see https://www.github.com/git-time-metric/gtm'

if executable('gtm') == 0
  echomsg '.'
  echomsg s:no_gtm_err
  echomsg s:gtm_url
  echomsg '.'
  finish
endif

function! s:verify(ver)
    let output=system('gtm verify ' . shellescape(a:ver))
    if v:shell_error
      return 0
    else
      if output != 'true'
        return 0
      endif
    endif
    return 1
endfunction

let g:gtm_verify_version = get(g:, 'gtm_verify_version', 1)

if g:gtm_verify_version == 1 && s:verify(s:gtm_ver_req) == 0
  echomsg '.'
  echomsg s:gtm_ver_err
  echomsg s:gtm_url
  echomsg '.'
endif

" plug-in is loading successfully
let g:gtm_plugin_loaded = 1

let g:gtm_plugin_status_enabled = get(g:, 'gtm_plugin_status_enabled', 0)

let s:last_update = 0
let s:last_file = ''
let s:update_interval = 30
let s:gtm_plugin_status = ''

function! s:record()
  let fpath = expand('%:p')
  " record if file path has changed or last update is greater than update_interval
  if s:last_file != fpath || localtime() - s:last_update > s:update_interval
    let s:cmd = (g:gtm_plugin_status_enabled == 1 ? 'gtm record --status' : 'gtm record')
    let output=system(s:cmd . ' ' . shellescape(fpath))
    if v:shell_error
      echomsg s:no_gtm_err
    else
      let s:gtm_plugin_status = (g:gtm_plugin_status_enabled ? output : '')
    endif
    let s:last_update = localtime()
    let s:last_file = fpath
  endif
endfunction

function! GTMStatusline()
  return s:gtm_plugin_status
endfunction

augroup gtm_plugin
  autocmd!
  autocmd BufReadPost,BufWritePost,CursorMoved,CursorMovedI * call s:record()
augroup END
