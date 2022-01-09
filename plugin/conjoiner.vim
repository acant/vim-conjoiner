" GPLv3 License. Copyright (c) 2014 Andrew Sullivan Cant.

if exists("g:loaded_conjoiner") || &cp
  finish
endif
let g:loaded_conjoiner = 1

function! s:conjoiner_aspect_root_path()
  if !exists("g:conjoiner_aspect_root_path")
    let g:conjoiner_aspect_root_path = $HOME . "/reference/log/"
  endif

  return g:conjoiner_aspect_root_path
endfunction

function! s:conjoiner_default_aspect()
  if !exists("g:conjoiner_default_aspect")
    let g:conjoiner_default_aspect = "prime"
  endif

  return g:conjoiner_default_aspect
endfunction

function! s:conjoiner_aspects()
  if !exists("g:conjoiner_aspects")
    let g:conjoiner_aspects = ["prime"]
  endif

  return g:conjoiner_aspects
endfunction

function! s:open_log(...)
  " assert a:0 > 1

  let log_type = a:1
  " assert log_type == 'journal' or 'inbox'

  " Set the defaults for the aspect and date_string.
  let aspect      = s:conjoiner_default_aspect()
  let date_string = strftime("%Y-%m-%d") " today

  " Override aspect or date_string if they are present in the arguments.
  if a:0 == 2
    if s:is_aspect(a:2)
      let aspect      = a:2
    else
      let date_string = a:2
    endif
  elseif a:0 == 3
    let aspect      = a:2
    let date_string = a:3
  end

  " TODO: Convert special date strings (last, yesterday, 08, 08-05)

  " Check the values of the parameters
  if !s:is_aspect(aspect)
    echoerr("'" . aspect . "' is not a valid aspect")
    return 0
  endif
  if match(date_string, '^\d\d\d\d-\d\d-\d\d$') != 0
    echoerr("'" . date_string . "' is not a valid date string")
    return 0
  endif

  " Ensure the path exists
  let date_path = substitute(date_string, "-", "/", "g")
  let path = s:conjoiner_aspect_root_path() . "/" . aspect . "/" . date_path
  if !isdirectory(path)
    call mkdir(path, "p")
  endif

  " Open the file
  let filename = simplify(path . "/" . log_type)
  execute "e " . fnameescape(filename)
  return filename
endfunction

function! s:log_setup()
  setfiletype votl
endfunction

function! s:is_aspect(aspect_string)
  for aspect in s:conjoiner_aspects()
    if aspect == a:aspect_string
      return 1
    endif
  endfor
  return 0
endfunction

function! s:read_checklist(type)
  let path = $HOME . "/gtd/" . s:conjoiner_default_aspect() . "/checklists/" . a:type . ".otl"
  exec "read " . path
endfunction

function! s:open_gtd(type)
  let path = $HOME . "/gtd/" . s:conjoiner_default_aspect() . "/" . a:type . ".otl"
  execute "e " . path
  " fnameescape(filename)
  " exec "read " . path
endfunction

"- Setup commands --------------------------------------------------------------
command! -nargs=* Journal :call s:open_log("journal", <f-args>)
command! -nargs=* Inbox   :call s:open_log("inbox", <f-args>)
" TODO: Consider limiting these commands to only run in Journal files.
command! -nargs=0 Daily   :call s:read_checklist("daily_review")
command! -nargs=0 Weekly  :call s:read_checklist("weekly_review")
command! -nargs=0 NextAction :call s:open_gtd("next_actions")
command! -nargs=0 WaitingFor :call s:open_gtd("waiting_for")
command! -nargs=0 Plans :call s:open_gtd("plans")

autocmd BufRead,BufNewFile ~/reference/log/*/{inbox,journal} :call s:log_setup()
