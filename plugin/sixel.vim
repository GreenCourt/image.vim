if has("gui")
  finish
endif

command -nargs=? -complete=file Sixel call sixel#show(!empty("<args>") ? "<args>" : sixel#cursor_path())
