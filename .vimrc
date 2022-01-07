set nocompatible
set history=1000 
" makes tab to be 4 spaces 
set ts=4 sw=4



" general 
set number             " line numbers
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commandso
set incsearch          " do incremental searching
set linebreak          " wrap lines on 'word' boundaries (vashe nice shtuka)
set scrolloff=5        " don't let the cursor touch the edge of the viewport
set t_Co=126

" changes the colour of the nubmerline
highlight LineNr ctermfg=grey 

syntax on	" syntax hightlighting on

if exists('&breakindent')
  set breakindent      " Indent wrapped lines up to the same level
endif


" rebinds commonly mistyped commands 
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" Force write readonly files using sudo
command! WS w !sudo tee %

" enable the mouse
if has('mouse')
  set mouse=a
endif

