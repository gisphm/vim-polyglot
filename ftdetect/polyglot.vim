autocmd BufNewFile,BufRead *.asciidoc,*.adoc
	\ set ft=asciidoc
autocmd BufNewFile,BufRead *.blade.php set filetype=blade
au BufRead,BufNewFile *.csv,*.dat,*.tsv,*.tab set filetype=csv
autocmd BufNewFile,BufReadPost *.feature,*.story set filetype=cucumber
au BufNewFile,BufRead Dockerfile set filetype=dockerfile
au BufNewFile,BufRead .gitignore set filetype=gitignore
autocmd BufNewFile,BufRead *.git/{,modules/**/,worktrees/*/}{COMMIT_EDIT,TAG_EDIT,MERGE_,}MSG set ft=gitcommit
autocmd BufNewFile,BufRead *.git/config,.gitconfig,gitconfig,.gitmodules set ft=gitconfig
autocmd BufNewFile,BufRead */.config/git/config                          set ft=gitconfig
autocmd BufNewFile,BufRead *.git/modules/**/config                       set ft=gitconfig
autocmd BufNewFile,BufRead git-rebase-todo                               set ft=gitrebase
autocmd BufNewFile,BufRead .gitsendemail.*                               set ft=gitsendemail
autocmd BufNewFile,BufRead *.git/**
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   set ft=git |
      \ endif
autocmd BufNewFile,BufRead,StdinReadPost *
      \ if getline(1) =~ '^\(commit\|tree\|object\) \x\{40\}\>\|^tag \S\+$' |
      \   set ft=git |
      \ endif
autocmd BufNewFile,BufRead *
      \ if getline(1) =~ '^From \x\{40\} Mon Sep 17 00:00:00 2001$' |
      \   set filetype=gitsendemail |
      \ endif
au BufNewFile,BufRead *.{js,jsm,es,es6},Jakefile setf javascript
fun! s:SourceFlowSyntax()
  if !exists('javascript_plugin_flow') && !exists('b:flow_active') &&
        \ search('\v\C%^\_s*%(//\s*|/\*[ \t\n*]*)\@flow>','nw')
    runtime extras/flow.vim
    let b:flow_active = 1
  endif
endfun
au FileType javascript au BufRead,BufWritePost <buffer> call s:SourceFlowSyntax()
fun! s:SelectJavascript()
  if getline(1) =~# '^#!.*/bin/\%(env\s\+\)\?node\>'
    set ft=javascript
  endif
endfun
au BufNewFile,BufRead * call s:SelectJavascript()
if !exists('g:jsx_ext_required')
  let g:jsx_ext_required = 1
endif
if !exists('g:jsx_pragma_required')
  let g:jsx_pragma_required = 0
endif
if g:jsx_pragma_required
  " Look for the @jsx pragma.  It must be included in a docblock comment before
  " anything else in the file (except whitespace).
  let s:jsx_pragma_pattern = '\%^\_s*\/\*\*\%(\_.\%(\*\/\)\@!\)*@jsx\_.\{-}\*\/'
  let b:jsx_pragma_found = search(s:jsx_pragma_pattern, 'npw')
endif
fu! <SID>EnableJSX()
  if g:jsx_pragma_required && !b:jsx_pragma_found | return 0 | endif
  if g:jsx_ext_required && !exists('b:jsx_ext_found') | return 0 | endif
  return 1
endfu
autocmd BufNewFile,BufRead *.jsx let b:jsx_ext_found = 1
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.js
  \ if <SID>EnableJSX() | set filetype=javascript.jsx | endif
autocmd BufNewFile,BufRead *.json setlocal filetype=json
autocmd BufNewFile,BufRead *.jsonp setlocal filetype=json
autocmd BufNewFile,BufRead *.geojson setlocal filetype=json
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead *.jst set filetype=jst
au BufNewFile,BufRead *.djs set filetype=jst
au BufNewFile,BufRead *.hamljs set filetype=jst
au BufNewFile,BufRead *.ect set filetype=jst
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
au BufRead,BufNewFile *.nginx set ft=nginx
au BufRead,BufNewFile */etc/nginx/* set ft=nginx
au BufRead,BufNewFile */usr/local/nginx/conf/* set ft=nginx
au BufRead,BufNewFile nginx.conf set ft=nginx
function! s:isNode()
	let shebang = getline(1)
	if shebang =~# '^#!.*/bin/env\s\+node\>' | return 1 | en
	if shebang =~# '^#!.*/bin/node\>' | return 1 | en
	return 0
endfunction
au BufRead,BufNewFile * if !did_filetype() && s:isNode() | setf javascript | en
au BufNewFile,BufRead *.pgsql           setf pgsql
autocmd BufNewFile,BufReadPost *.pug set filetype=pug
autocmd BufNewFile,BufReadPost *.jade set filetype=pug
autocmd BufNewFile,BufRead *_spec.rb set syntax=rspec
function! s:setf(filetype) abort
  if &filetype !=# a:filetype
    let &filetype = a:filetype
  endif
endfunction
au BufNewFile,BufRead Appraisals		call s:setf('ruby')
au BufNewFile,BufRead .autotest			call s:setf('ruby')
au BufNewFile,BufRead [Bb]uildfile		call s:setf('ruby')
au BufNewFile,BufRead Capfile,*.cap		call s:setf('ruby')
au BufNewFile,BufRead Cheffile			call s:setf('ruby')
au BufNewFile,BufRead Berksfile			call s:setf('ruby')
au BufNewFile,BufRead Podfile,*.podspec		call s:setf('ruby')
au BufNewFile,BufRead Guardfile,.Guardfile	call s:setf('ruby')
au BufNewFile,BufRead *.jbuilder		call s:setf('ruby')
au BufNewFile,BufRead KitchenSink		call s:setf('ruby')
au BufNewFile,BufRead *.opal			call s:setf('ruby')
au BufNewFile,BufRead .pryrc			call s:setf('ruby')
au BufNewFile,BufRead Puppetfile		call s:setf('ruby')
au BufNewFile,BufRead *.rabl			call s:setf('ruby')
au BufNewFile,BufRead [rR]outefile		call s:setf('ruby')
au BufNewFile,BufRead .simplecov		call s:setf('ruby')
au BufNewFile,BufRead [tT]horfile,*.thor	call s:setf('ruby')
au BufNewFile,BufRead [vV]agrantfile		call s:setf('ruby')
function! s:setf(filetype) abort
  if &filetype !~# '\<'.a:filetype.'\>'
    let &filetype = a:filetype
  endif
endfunction
func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc
au BufNewFile,BufRead *.erb,*.rhtml				call s:setf('eruby')
au BufNewFile,BufRead .irbrc,irbrc				call s:setf('ruby')
au BufNewFile,BufRead *.rb,*.rbw,*.gemspec			call s:setf('ruby')
au BufNewFile,BufRead *.ru					call s:setf('ruby')
au BufNewFile,BufRead Gemfile					call s:setf('ruby')
au BufNewFile,BufRead *.builder,*.rxml,*.rjs,*.ruby		call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile,*.rake			call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile*				call s:StarSetf('ruby')
au BufNewFile,BufRead [rR]antfile,*.rant			call s:setf('ruby')
au BufNewFile,BufRead *.automount set filetype=systemd
au BufNewFile,BufRead *.mount     set filetype=systemd
au BufNewFile,BufRead *.path      set filetype=systemd
au BufNewFile,BufRead *.service   set filetype=systemd
au BufNewFile,BufRead *.socket    set filetype=systemd
au BufNewFile,BufRead *.swap      set filetype=systemd
au BufNewFile,BufRead *.target    set filetype=systemd
au BufNewFile,BufRead *.timer     set filetype=systemd
autocmd BufNewFile,BufRead {.,}tmux*.conf set ft=tmux | compiler tmux
