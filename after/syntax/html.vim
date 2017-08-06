" Language:     Colorful CSS Color Preview
" Author:       Aristotle Pagaltzis <pagaltzis@gmx.de>

" default html syntax should already be including the css syntax
call css_color#init('none', 'none', 'htmlString,htmlCommentPart')
syn include @htmlCss syntax/css/compositing-1.vim
syn include @htmlCss syntax/css/css-align-3.vim
syn include @htmlCss syntax/css/css-backgrounds-4.vim
syn include @htmlCss syntax/css/css-break-3.vim
syn include @htmlCss syntax/css/css-cascade-3.vim
syn include @htmlCss syntax/css/css-cascade-4.vim
syn include @htmlCss syntax/css/css-color-4.vim
syn include @htmlCss syntax/css/css-contain-1.vim
syn include @htmlCss syntax/css/css-content-3.vim
syn include @htmlCss syntax/css/css-counter-styles-3.vim
syn include @htmlCss syntax/css/css-device-adapt-1.vim
syn include @htmlCss syntax/css/css-display-3.vim
syn include @htmlCss syntax/css/css-flexbox-1.vim
syn include @htmlCss syntax/css/css-font-loading-3.vim
syn include @htmlCss syntax/css/css-fonts-3.vim
syn include @htmlCss syntax/css/css-fonts-4.vim
syn include @htmlCss syntax/css/css-gcpm-3.vim
syn include @htmlCss syntax/css/css-grid-1.vim
syn include @htmlCss syntax/css/css-images-4.vim
syn include @htmlCss syntax/css/css-inline-3.vim
syn include @htmlCss syntax/css/css-line-grid-1.vim
syn include @htmlCss syntax/css/css-lists-3.vim
syn include @htmlCss syntax/css/css-logical-1.vim
syn include @htmlCss syntax/css/css-masking-1.vim
syn include @htmlCss syntax/css/css-overflow-3.vim
syn include @htmlCss syntax/css/css-overflow-4.vim
syn include @htmlCss syntax/css/css-page-floats-3.vim
syn include @htmlCss syntax/css/css-paint-api-1.vim
syn include @htmlCss syntax/css/css-position-3.vim
syn include @htmlCss syntax/css/css-properties-values-api-1.vim
syn include @htmlCss syntax/css/css-pseudo-4.vim
syn include @htmlCss syntax/css/css-regions-1.vim
syn include @htmlCss syntax/css/css-rhythm-1.vim
syn include @htmlCss syntax/css/css-round-display-1.vim
syn include @htmlCss syntax/css/css-ruby-1.vim
syn include @htmlCss syntax/css/css-scoping-1.vim
syn include @htmlCss syntax/css/css-scroll-snap-1.vim
syn include @htmlCss syntax/css/css-shapes-1.vim
syn include @htmlCss syntax/css/css-sizing-3.vim
syn include @htmlCss syntax/css/css-style-attr.vim
syn include @htmlCss syntax/css/css-syntax-3.vim
syn include @htmlCss syntax/css/css-text-3.vim
syn include @htmlCss syntax/css/css-text-4.vim
syn include @htmlCss syntax/css/css-text-decor-3.vim
syn include @htmlCss syntax/css/css-timing-1.vim
syn include @htmlCss syntax/css/css-transforms-1.vim
syn include @htmlCss syntax/css/css-typed-om-1.vim
syn include @htmlCss syntax/css/css-ui-3.vim
syn include @htmlCss syntax/css/css-ui-4.vim
syn include @htmlCss syntax/css/css-values-3.vim
syn include @htmlCss syntax/css/css-variables-1.vim
syn include @htmlCss syntax/css/css-will-change-1.vim
syn include @htmlCss syntax/css/css-writing-modes-3.vim
syn include @htmlCss syntax/css/css3-animations.vim
syn include @htmlCss syntax/css/css3-background.vim
syn include @htmlCss syntax/css/css3-box.vim
syn include @htmlCss syntax/css/css3-color.vim
syn include @htmlCss syntax/css/css3-conditional.vim
syn include @htmlCss syntax/css/css3-exclusions.vim
syn include @htmlCss syntax/css/css3-images.vim
syn include @htmlCss syntax/css/css3-multicol.vim
syn include @htmlCss syntax/css/css3-namespace.vim
syn include @htmlCss syntax/css/css3-page.vim
syn include @htmlCss syntax/css/css3-speech.vim
syn include @htmlCss syntax/css/css3-transitions.vim
syn include @htmlCss syntax/css/cssom-1.vim
syn include @htmlCss syntax/css/cssom-view-1.vim
syn include @htmlCss syntax/css/fill-stroke-3.vim
syn include @htmlCss syntax/css/filter-effects-1.vim
syn include @htmlCss syntax/css/geometry-1.vim
syn include @htmlCss syntax/css/html5.vim
syn include @htmlCss syntax/css/motion-1.vim
syn include @htmlCss syntax/css/pointerevents.vim
syn include @htmlCss syntax/css/selectors-nonelement-1.vim
syn include @htmlCss syntax/css/selectors.vim
syn include @htmlCss syntax/css/selectors4.vim
syn include @htmlCss syntax/css/svg2.vim
syn include @htmlCss syntax/css/web-animations-1.vim
syn include @htmlCss syntax/css/worklets-1.vim
" Vim syntax file
" Language:     HTML (version 5.1)
" Last Change:  2017 Feb 15
" License:      Public domain
"               (but let me know if you like :) )
"
" Maintainer:   Kao, Wei-Ko(othree) ( othree AT gmail DOT com )

" Comment
" https://github.com/w3c/html/issues/694
syntax region htmlComment start=+<!--+ end=+-->+ contains=@Spell
syntax region htmlComment start=+<!DOCTYPE+ keepend end=+>+
" Vim plugin file
" Language:    
" Maintainer:  othree <othree@gmail.com>
" Last Change: 2017/04/18
" Version:     0.4.2
" URL:         https://github.com/othree/javascript-libraries-syntax.vim

if exists('b:current_syntax') && b:current_syntax == 'html'
  call jslibsyntax#load()
endif
