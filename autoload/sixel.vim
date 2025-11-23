func sixel#show(path) abort
  if !a:path->filereadable()
    echohl ErrorMsg
    redraw | echo "not a file: " .. a:path
    echohl None
    return
  endif

  let seq = system("magick " .. shellescape(a:path) .. " -resize " .. shellescape("800x600>") .. " sixel:-")

  if v:shell_error
    echohl ErrorMsg
    redraw | echo seq
    echohl None
    return
  endif

  if &term =~# "tmux" || !empty($TMUX)
    let seq = "\033Ptmux;" .. seq->substitute("\033", "\033\033", "g") .. "\033\\"
  endif
  redraw!
  call echoraw("\033[1;1H" .. seq)
endfunc

func sixel#cursor_path() abort
  let cfile = expand("<cfile>")

  if cfile->isabsolutepath()
    return cfile
  endif

  if !empty(&buftype)
    return cfile
  endif

  let sep = (!exists("+shellslash") || &shellslash) ? "/" : "\\"

  if bufname()->isdirectory() " if netrw
    return bufname() .. sep .. cfile
  endif

  let rel2buf = bufname()->fnamemodify(":h") .. sep .. cfile
  if rel2buf->filereadable()
    return rel2buf
  endif

  return cfile
endfunc
