" Vim filetype plugin file
" Language:     JavaScript
" Maintainer:   vim-javascript community
" URL:          https://github.com/pangloss/vim-javascript

setlocal iskeyword+=$ suffixesadd+=.js

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal iskeyword< suffixesadd<'
else
  let b:undo_ftplugin = 'setlocal iskeyword< suffixesadd<'
endif
" Vim plugin file
" Language:    JavaScript Parameter Complete function
" Maintainer:  othree <othree@gmail.com>
" Last Change: 2014/11/11
" Version:     0.1
" URL:         https://github.com/othree/jspc.vim

call jspc#init()


