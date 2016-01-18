" Vim syntax file
" Language:     JavaScript
" Maintainer:   vim-javascript community
" URL:          https://github.com/pangloss/vim-javascript

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

if !exists('g:javascript_conceal')
  let g:javascript_conceal = 0
endif

"" Drop fold if it is set but VIM doesn't support it.
let b:javascript_fold='true'
if version < 600    " Don't support the old version
  unlet! b:javascript_fold
endif

"" dollar sign is permittd anywhere in an identifier
setlocal iskeyword+=$

syntax sync fromstart

syntax match   jsNoise           /\%(:\|,\|\;\|\.\)/

"" Program Keywords
syntax keyword jsStorageClass   const var let
syntax keyword jsOperator       delete instanceof typeof void new in
syntax match   jsOperator       /\(!\||\|&\|+\|-\|<\|>\|=\|%\|\/\|*\|\~\|\^\)/
syntax keyword jsBooleanTrue    true
syntax keyword jsBooleanFalse   false
syntax keyword jsModules        import export contained
syntax keyword jsModuleWords    default from as contained
syntax keyword jsOf             of contained
syntax keyword jsArgsObj        arguments

syntax region jsImportContainer      start="^\s\?import \?" end=";\|$" contains=jsModules,jsModuleWords,jsLineComment,jsComment,jsStringS,jsStringD,jsTemplateString,jsNoise,jsBlock

syntax region jsExportContainer      start="^\s\?export \?" end="$" contains=jsModules,jsModuleWords,jsComment,jsTemplateString,jsStringD,jsStringS,jsRegexpString,jsNumber,jsFloat,jsThis,jsOperator,jsBooleanTrue,jsBooleanFalse,jsNull,jsFunction,jsArrowFunction,jsGlobalObjects,jsExceptions,jsDomErrNo,jsDomNodeConsts,jsHtmlEvents,jsDotNotation,jsBracket,jsParen,jsFuncCall,jsUndefined,jsNan,jsKeyword,jsClass,jsStorageClass,jsPrototype,jsBuiltins,jsNoise,jsAssignmentExpr,jsArgsObj,jsBlock

"" JavaScript comments
syntax keyword jsCommentTodo    TODO FIXME XXX TBD contained
syntax region  jsLineComment    start=+\/\/+ end=+$+ keepend contains=jsCommentTodo,@Spell
syntax region  jsEnvComment     start="\%^#!" end="$" display
syntax region  jsLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=jsCommentTodo,@Spell fold
syntax region  jsCvsTag         start="\$\cid:" end="\$" oneline contained
syntax region  jsComment        start="/\*"  end="\*/" contains=jsCommentTodo,jsCvsTag,@Spell fold

"" JSDoc / JSDoc Toolkit
if !exists("javascript_ignore_javaScriptdoc")
  syntax case ignore

  "" syntax coloring for javadoc comments (HTML)
  "syntax include @javaHtml <sfile>:p:h/html.vim
  "unlet b:current_syntax

  syntax region jsBlockComment    matchgroup=jsComment start="/\*\s*"  end="\*/" contains=jsDocTags,jsCommentTodo,jsCvsTag,@jsHtml,@Spell fold

  " tags containing a param
  syntax match  jsDocTags         contained "@\(alias\|api\|augments\|borrows\|class\|constructs\|default\|defaultvalue\|emits\|exception\|exports\|extends\|file\|fires\|kind\|listens\|member\|member[oO]f\|mixes\|module\|name\|namespace\|requires\|template\|throws\|var\|variation\|version\)\>" nextgroup=jsDocParam skipwhite
  " tags containing type and param
  syntax match  jsDocTags         contained "@\(arg\|argument\|param\|property\|prop\)\>" nextgroup=jsDocType skipwhite
  " tags containing type but no param
  syntax match  jsDocTags         contained "@\(callback\|define\|enum\|external\|implements\|this\|type\|typedef\|return\|returns\)\>" nextgroup=jsDocTypeNoParam skipwhite
  " tags containing references
  syntax match  jsDocTags         contained "@\(lends\|see\|tutorial\)\>" nextgroup=jsDocSeeTag skipwhite
  " other tags (no extra syntax)
  syntax match  jsDocTags         contained "@\(abstract\|access\|author\|classdesc\|constant\|const\|constructor\|copyright\|deprecated\|desc\|description\|dict\|event\|example\|file[oO]verview\|final\|function\|global\|ignore\|inheritDoc\|inner\|instance\|interface\|license\|method\|mixin\|nosideeffects\|override\|overview\|preserve\|private\|protected\|public\|readonly\|since\|static\|struct\|todo\|summary\|undocumented\|virtual\)\>"

  syntax region jsDocType         start="{" end="}" oneline contained nextgroup=jsDocParam skipwhite
  syntax match  jsDocType         contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+" nextgroup=jsDocParam skipwhite
  syntax region jsDocTypeNoParam  start="{" end="}" oneline contained
  syntax match  jsDocTypeNoParam  contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+"
  syntax match  jsDocParam        contained "\%(#\|\"\|{\|}\|\w\|\.\|:\|\/\|\[\|]\|=\)\+"
  syntax region jsDocSeeTag       contained matchgroup=jsDocSeeTag start="{" end="}" contains=jsDocTags

  syntax case match
endif   "" JSDoc end

syntax case match

"" Syntax in the JavaScript code
syntax match   jsFuncCall         /\k\+\%(\s*(\)\@=/
syntax match   jsSpecial          "\v\\%(0|\\x\x\{2\}\|\\u\x\{4\}\|\c[A-Z]|.)" contained
syntax match   jsTemplateVar      "\${.\{-}}" contained
syntax region  jsStringD          start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@htmlPreproc,@Spell
syntax region  jsStringS          start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@htmlPreproc,@Spell
syntax region  jsTemplateString   start=+`+  skip=+\\\(`\|$\)+  end=+`+     contains=jsTemplateVar,jsSpecial,@htmlPreproc
syntax region  jsTaggedTemplate   start=/\k\+\(\(\n\|\s\)\+\)\?`/ end=+`+ contains=jsTemplateString keepend
syntax region  jsRegexpCharClass  start=+\[+ skip=+\\.+ end=+\]+ contained
syntax match   jsRegexpBoundary   "\v%(\<@![\^$]|\\[bB])" contained
syntax match   jsRegexpBackRef    "\v\\[1-9][0-9]*" contained
syntax match   jsRegexpQuantifier "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??" contained
syntax match   jsRegexpOr         "\v\<@!\|" contained
syntax match   jsRegexpMod        "\v\(@<=\?[:=!>]" contained
syntax cluster jsRegexpSpecial    contains=jsSpecial,jsRegexpBoundary,jsRegexpBackRef,jsRegexpQuantifier,jsRegexpOr,jsRegexpMod
syntax region  jsRegexpGroup      start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contained contains=jsRegexpCharClass,@jsRegexpSpecial keepend
syntax region  jsRegexpString     start=+\(\(\(return\|case\)\s\+\)\@<=\|\(\([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\(\\.\|[^]]\)*\]+ end=+/[gimy]\{,4}+ contains=jsRegexpCharClass,jsRegexpGroup,@jsRegexpSpecial,@htmlPreproc oneline keepend
syntax match   jsNumber           /\<-\=\d\+\(L\|[eE][+-]\=\d\+\)\=\>\|\<0[xX]\x\+\>/
syntax keyword jsNumber           Infinity
syntax match   jsFloat            /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syntax match   jsObjectKey        /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\)\@=/ contains=jsFunctionKey contained
syntax match   jsFunctionKey      /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\s*function\s*\)\@=/ contained
syntax match   jsDecorator        "@" display contains=jsDecoratorFunction nextgroup=jsDecoratorFunction skipwhite
syntax match   jsDecoratorFunction "[a-zA-Z_][a-zA-Z0-9_.]*" display contained nextgroup=jsFunc skipwhite

syntax match   jsAssignmentExpr     /\v%([a-zA-Z_$]\k*\.)*[a-zA-Z_$]\k*\s*\=\(>\)\@!/ contains=jsFuncAssignExpr,jsAssignExpIdent,jsPrototype,jsOperator,jsThis,jsNoise,jsArgsObj
syntax match   jsAssignExpIdent     /\v[a-zA-Z_$]\k*\ze%(\s*\=)/ contained
syntax match   jsFuncAssignExpr     /\v%(%([a-zA-Z_$]\k*\.)*[a-zA-Z_$]\k*\s*\=\s*){-1,}\ze%(function\s*\*?\s*\()/ contains=jsFuncAssignObjChain,jsFuncAssignIdent,jsFunction,jsPrototype,jsOperator,jsThis,jsArgsObj contained
syntax match   jsFuncAssignObjChain /\v%([a-zA-Z_$]\k*\.)+/ contains=jsPrototype,jsNoise contained
syntax match   jsFuncAssignIdent    /\v[a-zA-Z_$]\k*\ze%(\s*\=)/ contained

exe 'syntax keyword jsNull      null      '.(exists('g:javascript_conceal_null')        ? 'conceal cchar='.g:javascript_conceal_null        : '')
exe 'syntax keyword jsReturn    return    '.(exists('g:javascript_conceal_return')      ? 'conceal cchar='.g:javascript_conceal_return      : '')
exe 'syntax keyword jsUndefined undefined '.(exists('g:javascript_conceal_undefined')   ? 'conceal cchar='.g:javascript_conceal_undefined   : '')
exe 'syntax keyword jsNan       NaN       '.(exists('g:javascript_conceal_NaN')         ? 'conceal cchar='.g:javascript_conceal_NaN         : '')
exe 'syntax keyword jsPrototype prototype '.(exists('g:javascript_conceal_prototype')   ? 'conceal cchar='.g:javascript_conceal_prototype   : '')
exe 'syntax keyword jsThis      this      '.(exists('g:javascript_conceal_this')        ? 'conceal cchar='.g:javascript_conceal_this        : '')
exe 'syntax keyword jsStatic    static    '.(exists('g:javascript_conceal_static')      ? 'conceal cchar='.g:javascript_conceal_static      : '')
exe 'syntax keyword jsSuper     super     '.(exists('g:javascript_conceal_super')       ? 'conceal cchar='.g:javascript_conceal_super       : '')

"" Statement Keywords
syntax keyword jsStatement      break continue with
syntax keyword jsConditional    if else switch
syntax keyword jsRepeat         do while for
syntax keyword jsLabel          case default
syntax keyword jsKeyword        yield
syntax keyword jsClass          extends class
syntax keyword jsException      try catch throw finally
syntax keyword jsAsyncKeyword   async await

syntax keyword jsGlobalObjects   Array Boolean Date Function Iterator Number Object Symbol Map WeakMap Set RegExp String Proxy Promise ParallelArray ArrayBuffer DataView Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray Intl JSON Math console document window
syntax match   jsGlobalObjects  /\%(Intl\.\)\@<=\(Collator\|DateTimeFormat\|NumberFormat\)/

syntax keyword jsExceptions     Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError

syntax keyword jsBuiltins       decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval

syntax keyword jsFutureKeys     abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient debugger implements protected volatile double public

"" DOM/HTML/CSS specified things

" DOM2 Objects
syntax keyword jsGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword jsExceptions     DOMException

" DOM2 CONSTANT
syntax keyword jsDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword jsDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" HTML events and internal variables
syntax case ignore
syntax keyword jsHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize
syntax case match

" Follow stuff should be highligh within a special context
" While it can't be handled with context depended with Regex based highlight
" So, turn it off by default
if exists("javascript_enable_domhtmlcss")

    " DOM2 things
    syntax match jsDomElemAttrs     contained /\%(nodeName\|nodeValue\|nodeType\|parentNode\|childNodes\|firstChild\|lastChild\|previousSibling\|nextSibling\|attributes\|ownerDocument\|namespaceURI\|prefix\|localName\|tagName\)\>/
    syntax match jsDomElemFuncs     contained /\%(insertBefore\|replaceChild\|removeChild\|appendChild\|hasChildNodes\|cloneNode\|normalize\|isSupported\|hasAttributes\|getAttribute\|setAttribute\|removeAttribute\|getAttributeNode\|setAttributeNode\|removeAttributeNode\|getElementsByTagName\|getAttributeNS\|setAttributeNS\|removeAttributeNS\|getAttributeNodeNS\|setAttributeNodeNS\|getElementsByTagNameNS\|hasAttribute\|hasAttributeNS\)\>/ nextgroup=jsParen skipwhite
    " HTML things
    syntax match jsHtmlElemAttrs    contained /\%(className\|clientHeight\|clientLeft\|clientTop\|clientWidth\|dir\|id\|innerHTML\|lang\|length\|offsetHeight\|offsetLeft\|offsetParent\|offsetTop\|offsetWidth\|scrollHeight\|scrollLeft\|scrollTop\|scrollWidth\|style\|tabIndex\|title\)\>/
    syntax match jsHtmlElemFuncs    contained /\%(blur\|click\|focus\|scrollIntoView\|addEventListener\|dispatchEvent\|removeEventListener\|item\)\>/ nextgroup=jsParen skipwhite

    " CSS Styles in JavaScript
    syntax keyword jsCssStyles      contained color font fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight letterSpacing lineBreak lineHeight quotes rubyAlign rubyOverhang rubyPosition
    syntax keyword jsCssStyles      contained textAlign textAlignLast textAutospace textDecoration textIndent textJustify textJustifyTrim textKashidaSpace textOverflowW6 textShadow textTransform textUnderlinePosition
    syntax keyword jsCssStyles      contained unicodeBidi whiteSpace wordBreak wordSpacing wordWrap writingMode
    syntax keyword jsCssStyles      contained bottom height left position right top width zIndex
    syntax keyword jsCssStyles      contained border borderBottom borderLeft borderRight borderTop borderBottomColor borderLeftColor borderTopColor borderBottomStyle borderLeftStyle borderRightStyle borderTopStyle borderBottomWidth borderLeftWidth borderRightWidth borderTopWidth borderColor borderStyle borderWidth borderCollapse borderSpacing captionSide emptyCells tableLayout
    syntax keyword jsCssStyles      contained margin marginBottom marginLeft marginRight marginTop outline outlineColor outlineStyle outlineWidth padding paddingBottom paddingLeft paddingRight paddingTop
    syntax keyword jsCssStyles      contained listStyle listStyleImage listStylePosition listStyleType
    syntax keyword jsCssStyles      contained background backgroundAttachment backgroundColor backgroundImage backgroundPosition backgroundPositionX backgroundPositionY backgroundRepeat
    syntax keyword jsCssStyles      contained clear clip clipBottom clipLeft clipRight clipTop content counterIncrement counterReset cssFloat cursor direction display filter layoutGrid layoutGridChar layoutGridLine layoutGridMode layoutGridType
    syntax keyword jsCssStyles      contained marks maxHeight maxWidth minHeight minWidth opacity MozOpacity overflow overflowX overflowY verticalAlign visibility zoom cssText
    syntax keyword jsCssStyles      contained scrollbar3dLightColor scrollbarArrowColor scrollbarBaseColor scrollbarDarkShadowColor scrollbarFaceColor scrollbarHighlightColor scrollbarShadowColor scrollbarTrackColor

    " Highlight ways
    syntax match jsDotNotation      "\." nextgroup=jsPrototype,jsDomElemAttrs,jsDomElemFuncs,jsHtmlElemAttrs,jsHtmlElemFuncs
    syntax match jsDotNotation      "\.style\." nextgroup=jsCssStyles

endif "DOM/HTML/CSS

"" end DOM/HTML/CSS specified things

"" Code blocks
syntax cluster jsExpression contains=jsComment,jsLineComment,jsBlockComment,jsTaggedTemplate,jsTemplateString,jsStringD,jsStringS,jsRegexpString,jsNumber,jsFloat,jsThis,jsStatic,jsSuper,jsOperator,jsBooleanTrue,jsBooleanFalse,jsNull,jsFunction,jsArrowFunction,jsGlobalObjects,jsExceptions,jsFutureKeys,jsDomErrNo,jsDomNodeConsts,jsHtmlEvents,jsDotNotation,jsBracket,jsParen,jsBlock,jsFuncCall,jsUndefined,jsNan,jsKeyword,jsStorageClass,jsPrototype,jsBuiltins,jsNoise,jsCommonJS,jsAssignmentExpr,jsImportContainer,jsExportContainer,jsClass,jsArgsObj,jsDecorator,jsAsyncKeyword
syntax cluster jsAll        contains=@jsExpression,jsLabel,jsConditional,jsRepeat,jsReturn,jsStatement,jsTernaryIf,jsException
syntax region  jsBracket    matchgroup=jsBrackets     start="\[" end="\]" contains=@jsAll,jsParensErrB,jsParensErrC,jsBracket,jsParen,jsBlock,@htmlPreproc fold
syntax region  jsParen      matchgroup=jsParens       start="("  end=")"  contains=@jsAll,jsOf,jsParensErrA,jsParensErrC,jsParen,jsBracket,jsBlock,@htmlPreproc fold
syntax region  jsBlock      matchgroup=jsBraces       start="{"  end="}"  contains=@jsAll,jsParensErrA,jsParensErrB,jsParen,jsBracket,jsBlock,jsObjectKey,@htmlPreproc fold
syntax region  jsFuncBlock  matchgroup=jsFuncBraces   start="{"  end="}"  contains=@jsAll,jsParensErrA,jsParensErrB,jsParen,jsBracket,jsBlock,@htmlPreproc contained fold
syntax region  jsTernaryIf  matchgroup=jsTernaryIfOperator start=+?+  end=+:+  contains=@jsExpression,jsTernaryIf

"" catch errors caused by wrong parenthesis
syntax match   jsParensError    ")\|}\|\]"
syntax match   jsParensErrA     contained "\]"
syntax match   jsParensErrB     contained ")"
syntax match   jsParensErrC     contained "}"

if main_syntax == "javascript"
  syntax sync clear
  syntax sync ccomment jsComment minlines=200
  syntax sync match jsHighlight grouphere jsBlock /{/
endif

exe 'syntax match jsFunction /\<function\>/ nextgroup=jsGenerator,jsFuncName,jsFuncArgs skipwhite '.(exists('g:javascript_conceal_function') ? 'conceal cchar='.g:javascript_conceal_function : '')

syntax match   jsGenerator      contained '\*' nextgroup=jsFuncName skipwhite
syntax match   jsFuncName       contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ nextgroup=jsFuncArgs skipwhite
syntax region  jsFuncArgs       contained matchgroup=jsFuncParens start='(' end=')' contains=jsFuncArgCommas,jsFuncArgRest,jsAssignmentExpr nextgroup=jsFuncBlock keepend skipwhite skipempty
syntax match   jsFuncArgCommas  contained ','
syntax match   jsFuncArgRest    contained /\%(\.\.\.[a-zA-Z_$][0-9a-zA-Z_$]*\))/

syntax match jsArrowFunction /=>/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink jsFuncArgRest          Special
  HiLink jsComment              Comment
  HiLink jsLineComment          Comment
  HiLink jsEnvComment           PreProc
  HiLink jsBlockComment         Comment
  HiLink jsCommentTodo          Todo
  HiLink jsCvsTag               Function
  HiLink jsDocTags              Special
  HiLink jsDocSeeTag            Function
  HiLink jsDocType              Type
  HiLink jsDocTypeNoParam       Type
  HiLink jsDocParam             Label
  HiLink jsStringS              String
  HiLink jsStringD              String
  HiLink jsTemplateString       String
  HiLink jsTaggedTemplate       StorageClass
  HiLink jsTernaryIfOperator    Conditional
  HiLink jsRegexpString         String
  HiLink jsRegexpBoundary       SpecialChar
  HiLink jsRegexpQuantifier     SpecialChar
  HiLink jsRegexpOr             Conditional
  HiLink jsRegexpMod            SpecialChar
  HiLink jsRegexpBackRef        SpecialChar
  HiLink jsRegexpGroup          jsRegexpString
  HiLink jsRegexpCharClass      Character
  HiLink jsCharacter            Character
  HiLink jsPrototype            Special
  HiLink jsConditional          Conditional
  HiLink jsBranch               Conditional
  HiLink jsLabel                Label
  HiLink jsReturn               Statement
  HiLink jsRepeat               Repeat
  HiLink jsStatement            Statement
  HiLink jsException            Exception
  HiLink jsKeyword              Keyword
  HiLink jsAsyncKeyword         Keyword
  HiLink jsArrowFunction        Type
  HiLink jsFunction             Type
  HiLink jsGenerator            jsFunction
  HiLink jsFuncName             Function
  HiLink jsArgsObj              Special
  HiLink jsError                Error
  HiLink jsParensError          Error
  HiLink jsParensErrA           Error
  HiLink jsParensErrB           Error
  HiLink jsParensErrC           Error
  HiLink jsOperator             Operator
  HiLink jsOf                   Operator
  HiLink jsStorageClass         StorageClass
  HiLink jsClass                Structure
  HiLink jsThis                 Special
  HiLink jsStatic               Special
  HiLink jsSuper                Special
  HiLink jsNan                  Number
  HiLink jsNull                 Type
  HiLink jsUndefined            Type
  HiLink jsNumber               Number
  HiLink jsFloat                Float
  HiLink jsBooleanTrue          Boolean
  HiLink jsBooleanFalse         Boolean
  HiLink jsNoise                Noise
  HiLink jsBrackets             Noise
  HiLink jsParens               Noise
  HiLink jsBraces               Noise
  HiLink jsFuncBraces           Noise
  HiLink jsFuncParens           Noise
  HiLink jsSpecial              Special
  HiLink jsTemplateVar          Special
  HiLink jsGlobalObjects        Special
  HiLink jsExceptions           Special
  HiLink jsFutureKeys           Special
  HiLink jsBuiltins             Special
  HiLink jsModules              Include
  HiLink jsModuleWords          Include
  HiLink jsDecorator            Special

  HiLink jsDomErrNo             Constant
  HiLink jsDomNodeConsts        Constant
  HiLink jsDomElemAttrs         Label
  HiLink jsDomElemFuncs         PreProc

  HiLink jsHtmlEvents           Special
  HiLink jsHtmlElemAttrs        Label
  HiLink jsHtmlElemFuncs        PreProc

  HiLink jsCssStyles            Label

  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
syntax cluster  htmlJavaScript       contains=@jsAll,jsBracket,jsParen,jsBlock
syntax cluster  javaScriptExpression contains=@jsAll,jsBracket,jsParen,jsBlock,@htmlPreproc

" Vim's default html.vim highlights all javascript as 'Special'
hi! def link javaScript              NONE

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif
" Vim syntax file
" Language:     JavaScript
" Maintainer:   Kao Wei-Ko(othree) <othree@gmail.com>
" Last Change:  2015-09-11
" Version:      1.5
" Changes:      Go to https://github.com/othree/yajs.vim for recent changes.
" Origin:       https://github.com/jelera/vim-javascript-syntax
" Credits:      Jose Elera Campana, Zhao Yi, Claudio Fleiner, Scott Shattuck 
"               (This file is based on their hard work), gumnos (From the #vim 
"               IRC Channel in Freenode)


" if exists("b:yajs_loaded")
  " finish
" else
  " let b:yajs_loaded = 1
" endif
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  let did_javascript_hilink = 1
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
else
  finish
endif

"Dollar sign is permitted anywhere in an identifier
setlocal iskeyword-=$
if &filetype =~ 'javascript'
  setlocal iskeyword+=$
  syntax cluster htmlJavaScript                 contains=TOP
endif

syntax sync fromstart

"Syntax coloring for Node.js shebang line
syntax match   shellbang "^#!.*node\>"
syntax match   shellbang "^#!.*iojs\>"

syntax match   javascriptOpSymbols             /[+\-*/%\^~=!<>&|?]\+/ contains=javascriptOpSymbol,javascriptInvalidOp nextgroup=@javascriptComments,@javascriptExpression skipwhite skipempty

syntax match   javascriptInvalidOp             contained /[+\-*/%\^~=!<>&|?:]\+/

syntax match   javascriptOpSymbol              contained /\(=\|?\)/ nextgroup=@javascriptExpression skipwhite skipempty " 2
syntax match   javascriptOpSymbol              contained /\(===\|==\)/
syntax match   javascriptOpSymbol              contained /!\+/ nextgroup=javascriptRegexpString skipwhite skipempty " 1
syntax match   javascriptOpSymbol              contained /\(!==\|!=\)/
syntax match   javascriptOpSymbol              contained /\(>>>=\|>>>\|>>=\|>>\|>=\|>\)/
syntax match   javascriptOpSymbol              contained /\(<<=\|<<\|<=\|<\)/
syntax match   javascriptOpSymbol              contained /\(++\|+=\|+\)/
syntax match   javascriptOpSymbol              contained /\(--\|-=\|-\)/
syntax match   javascriptOpSymbol              contained /\(||\||=\||\)/
syntax match   javascriptOpSymbol              contained /\(&&\|&=\|&\)/
syntax match   javascriptOpSymbol              contained /\(*=\|*\)/
syntax match   javascriptOpSymbol              contained /\(%=\|%\)/
syntax match   javascriptOpSymbol              contained /\(\/=\|\/\)/
syntax match   javascriptOpSymbol              contained /\(\^\|\~\)/

" 37 operators
" syntax match   javascriptOpSymbol              contained /\(<\|>\|<=\|>=\|==\|!=\|===\|!==\|+\|*\|%\|++\|--\|<<\|>>\|>>>\|&\||\|^\|!\|\~\|&&\|||\|?\|=\|+=\|-=\|*=\|%=\|<<=\|>>=\|>>>=\|&=\||=\|^=\|\/\|\/=\)/ nextgroup=javascriptInvalidOp skipwhite skipempty

"JavaScript comments
syntax keyword javascriptCommentTodo           contained TODO FIXME XXX TBD
syntax region  javascriptLineComment           start="//" end="\n" contains=@Spell,javascriptCommentTodo 
syntax region  javascriptComment               start="/\*"  end="\*/" contains=@Spell,javascriptCommentTodo extend
syntax cluster javascriptComments              contains=javascriptDocComment,javascriptComment,javascriptLineComment

"JSDoc
syntax case ignore

syntax region  javascriptDocComment            start="/\*\*"  end="\*/" contains=javascriptDocNotation,javascriptCommentTodo,@Spell fold keepend
syntax match   javascriptDocNotation           contained /\W@/ nextgroup=javascriptDocTags

syntax keyword javascriptDocTags               contained constant constructor constructs function ignore inner private public readonly static
syntax keyword javascriptDocTags               contained const dict expose inheritDoc interface nosideeffects override protected struct
syntax keyword javascriptDocTags               contained example global

" syntax keyword javascriptDocTags               contained ngdoc nextgroup=javascriptDocNGDirective
syntax keyword javascriptDocTags               contained ngdoc scope priority animations
syntax keyword javascriptDocTags               contained ngdoc restrict methodOf propertyOf eventOf eventType nextgroup=javascriptDocParam skipwhite
syntax keyword javascriptDocNGDirective        contained overview service object function method property event directive filter inputType error

syntax keyword javascriptDocTags               contained abstract virtual access augments

syntax keyword javascriptDocTags               contained arguments callback lends memberOf name type kind link mixes mixin tutorial nextgroup=javascriptDocParam skipwhite
syntax keyword javascriptDocTags               contained variation nextgroup=javascriptDocNumParam skipwhite

syntax keyword javascriptDocTags               contained author class classdesc copyright default defaultvalue nextgroup=javascriptDocDesc skipwhite
syntax keyword javascriptDocTags               contained deprecated description external host nextgroup=javascriptDocDesc skipwhite
syntax keyword javascriptDocTags               contained file fileOverview overview namespace requires since version nextgroup=javascriptDocDesc skipwhite
syntax keyword javascriptDocTags               contained summary todo license preserve nextgroup=javascriptDocDesc skipwhite

syntax keyword javascriptDocTags               contained borrows exports nextgroup=javascriptDocA skipwhite
syntax keyword javascriptDocTags               contained param arg argument property prop module nextgroup=javascriptDocNamedParamType,javascriptDocParamName skipwhite
syntax keyword javascriptDocTags               contained type nextgroup=javascriptDocParamType skipwhite
syntax keyword javascriptDocTags               contained define enum extends implements this typedef nextgroup=javascriptDocParamType skipwhite
syntax keyword javascriptDocTags               contained return returns throws exception nextgroup=javascriptDocParamType,javascriptDocParamName skipwhite
syntax keyword javascriptDocTags               contained see nextgroup=javascriptDocRef skipwhite

"syntax for event firing
syntax keyword javascriptDocTags               contained emits fires nextgroup=javascriptDocEventRef skipwhite

syntax keyword javascriptDocTags               contained function func method nextgroup=javascriptDocName skipwhite
syntax match   javascriptDocName               contained /\h\w*/

syntax keyword javascriptDocTags               contained fires event nextgroup=javascriptDocEventRef skipwhite
syntax match   javascriptDocEventRef           contained /\h\w*#\(\h\w*\:\)\?\h\w*/

syntax match   javascriptDocNamedParamType     contained /{.\+}/ nextgroup=javascriptDocParamName skipwhite
syntax match   javascriptDocParamName          contained /\(\[.\{-}\]\|[0-9a-zA-Z_\.]\+\)/ nextgroup=javascriptDocDesc skipwhite
syntax match   javascriptDocParamType          contained /{.\+}/ nextgroup=javascriptDocDesc skipwhite
syntax match   javascriptDocA                  contained /\%(#\|\w\|\.\|:\|\/\)\+/ nextgroup=javascriptDocAs skipwhite
syntax match   javascriptDocAs                 contained /\s*as\s*/ nextgroup=javascriptDocB skipwhite
syntax match   javascriptDocB                  contained /\%(#\|\w\|\.\|:\|\/\)\+/
syntax match   javascriptDocParam              contained /\%(#\|\w\|\.\|:\|\/\|-\)\+/
syntax match   javascriptDocNumParam           contained /\d\+/
syntax match   javascriptDocRef                contained /\%(#\|\w\|\.\|:\|\/\)\+/
syntax region  javascriptDocLinkTag            contained matchgroup=javascriptDocLinkTag start=/{/ end=/}/ contains=javascriptDocTags

syntax cluster javascriptDocs                  contains=javascriptDocParamType,javascriptDocNamedParamType,javascriptDocParam

if main_syntax == "javascript"
  syntax sync clear
  syntax sync ccomment javascriptComment minlines=200 linebreaks=2
endif

syntax case match

syntax cluster javascriptAfterIdentifier       contains=javascriptDotNotation,javascriptFuncCallArg,javascriptComputedProperty,javascriptWSymbols,@javascriptSymbols
syntax match   javascriptIdentifierName        /\<[^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^0-9][^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^]*/ nextgroup=@javascriptAfterIdentifier contains=@_semantic
" runtime syntax/semhl.vim

"Block VariableStatement EmptyStatement ExpressionStatement IfStatement IterationStatement ContinueStatement BreakStatement ReturnStatement WithStatement LabelledStatement SwitchStatement ThrowStatement TryStatement DebuggerStatement

syntax cluster javascriptStatement             contains=javascriptBlock,javascriptVariable,@javascriptExpression,javascriptConditional,javascriptRepeat,javascriptBranch,javascriptLabel,javascriptStatementKeyword,javascriptTry,javascriptDebugger

"Syntax in the JavaScript code
" syntax match   javascriptASCII                 contained /\\\d\d\d/
" syntax region  javascriptTemplateSubstitution  contained matchgroup=javascriptTemplateSB start=/\${/ end=/}/ contains=javascriptTemplateSBlock,javascriptTemplateSString 
syntax region  javascriptTemplateSubstitution  contained matchgroup=javascriptTemplateSB start=/\${/ end=/}/ contains=@javascriptExpression
syntax region  javascriptTemplateSBlock        contained start=/{/ end=/}/ contains=javascriptTemplateSBlock,javascriptTemplateSString transparent
syntax region  javascriptTemplateSString       contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ extend contains=javascriptTemplateSStringRB transparent
syntax match   javascriptTemplateSStringRB     /}/ contained 
syntax region  javascriptString                start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=@javascriptComments skipwhite skipempty
syntax region  javascriptTemplate              start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/ contains=javascriptTemplateSubstitution nextgroup=@javascriptComments,@javascriptSymbols skipwhite skipempty
" syntax match   javascriptTemplateTag           /\k\+/ nextgroup=javascriptTemplate
syntax region  javascriptArray                 matchgroup=javascriptBrackets start=/\[/ end=/]/ contains=@javascriptValue,javascriptComma,javascriptForComprehension,@javascriptComments nextgroup=@javascriptComments,@javascriptSymbols,@javascriptAfterIdentifier skipwhite skipempty

syntax match   javascriptNumber                /\<0[bB][01]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /\<0[oO][0-7]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /\<0[xX][0-9a-fA-F]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /[+-]\=\%(\d\+\.\d\+\|\d\+\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/ nextgroup=@javascriptComments skipwhite skipempty

syntax cluster javascriptTypes                 contains=javascriptString,javascriptTemplate,javascriptRegexpString,javascriptNumber,javascriptBoolean,javascriptNull,javascriptArray
syntax cluster javascriptValue                 contains=@javascriptTypes,@javascriptExpression,javascriptFuncKeyword,javascriptClassKeyword,javascriptObjectLiteral,javascriptIdentifier,javascriptIdentifierName,javascriptOperator,@javascriptSymbols

syntax match   javascriptLabel                 /[a-zA-Z_$]\k*\_s*:/he=e-1 contains=javascriptReserved nextgroup=@javascriptValue,@javascriptStatement skipwhite skipempty
syntax match   javascriptObjectLabel           contained /\k\+\_s*:/he=e-1 contains=javascriptObjectLabelColon nextgroup=@javascriptComments,@javascriptValue,@javascriptStatement skipwhite skipempty
syntax match   javascriptObjectLabelColon      contained /\s*:/ nextgroup=@javascriptValue skipwhite skipempty
" syntax match   javascriptPropertyName          contained /"[^"]\+"\s*:/he=e-1 nextgroup=@javascriptValue skipwhite skipempty
" syntax match   javascriptPropertyName          contained /'[^']\+'\s*:/he=e-1 nextgroup=@javascriptValue skipwhite skipempty
syntax region  javascriptPropertyName          contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=javascriptObjectLabelColon skipwhite skipempty
syntax region  javascriptComputedPropertyName  contained matchgroup=javascriptPropertyName start=/\[/rs=s+1 end=/]/ contains=@javascriptValue nextgroup=javascriptObjectLabelColon skipwhite skipempty
syntax region  javascriptComputedProperty      contained matchgroup=javascriptProperty start=/\[/rs=s+1 end=/]/ contains=@javascriptValue,@javascriptSymbols nextgroup=@javascriptAfterIdentifier skipwhite skipempty
" Value for object, statement for label statement

syntax cluster javascriptTemplates             contains=javascriptTemplate,javascriptTemplateSubstitution,javascriptTemplateSBlock,javascriptTemplateSString,javascriptTemplateSStringRB,javascriptTemplateSB
syntax cluster javascriptStrings               contains=javascriptProp,javascriptString,@javascriptTemplates,@javascriptComments,javascriptDocComment,javascriptRegexpString,javascriptPropertyName
syntax cluster javascriptNoReserved            contains=@javascriptStrings,@javascriptDocs,shellbang,javascriptObjectLiteral,javascriptObjectLabel,javascriptClassBlock,javascriptMethodName,javascriptMethod
"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved break catch class const continue
" syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved,javascriptSwitchBlock case
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved debugger default delete do else export
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved extends finally for function if 
"import,javascriptRegexpString,javascriptPropertyName
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved in instanceof let new return super
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved switch throw try typeof var
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved void while with yield

syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved enum implements package protected static
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved interface private public abstract boolean
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved byte char double final float goto int
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved long native short synchronized transient
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved volatile

"this

"JavaScript Prototype
syntax keyword javascriptPrototype             prototype

"Program Keywords
syntax keyword javascriptIdentifier            arguments this nextgroup=@javascriptAfterIdentifier
syntax keyword javascriptVariable              let var const
syntax keyword javascriptOperator              delete new instanceof typeof void in nextgroup=@javascriptValue,@javascriptTypes skipwhite skipempty
syntax keyword javascriptForOperator           contained in of
syntax keyword javascriptBoolean               true false nextgroup=@javascriptComments skipwhite skipempty
syntax keyword javascriptNull                  null undefined nextgroup=@javascriptComments skipwhite skipempty
syntax keyword javascriptMessage               alert confirm prompt status
syntax keyword javascriptGlobal                self top parent

"Statement Keywords
syntax keyword javascriptConditional           if else
syntax keyword javascriptConditionalElse       else
syntax keyword javascriptRepeat                do while for nextgroup=javascriptLoopParen skipwhite skipempty
syntax keyword javascriptBranch                break continue
syntax keyword javascriptSwitch                switch nextgroup=javascriptSwitchExp skipwhite
syntax keyword javascriptCase                  contained case nextgroup=@javascriptTypes,javascriptCaseLabel skipwhite
syntax keyword javascriptDefault               default nextgroup=javascriptCaseColon skipwhite
syntax keyword javascriptStatementKeyword      return with yield
syntax keyword javascriptReturn                return nextgroup=@javascriptValue skipwhite
syntax keyword javascriptYield                 yield nextgroup=javascriptYieldGen skipwhite skipempty
syntax match   javascriptYieldGen              contained /\*/

syntax keyword javascriptTry                   try
syntax keyword javascriptExceptions            catch throw finally
syntax keyword javascriptDebugger              debugger

syntax region  javascriptSwitchExp             contained start=/(/ end=/)/ matchgroup=javascriptParens contains=javascriptFuncKeyword,javascriptComma,javascriptDefaultAssign,@javascriptComments nextgroup=javascriptSwitchBlock skipwhite skipwhite skipempty
syntax region  javascriptSwitchBlock           matchgroup=javascriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=javascriptCaseColon,javascriptCaseRegion,@htmlJavaScript
syntax region  javascriptCaseRegion            contained start=/case/ end=/:/ contains=javascriptCase,@javascriptExpression nextgroup=javascriptBlock skipwhite skipempty
syntax match   javascriptCaseColon             contained /:/ nextgroup=javascriptBlock skipwhite skipempty

syntax match   javascriptProp                  contained /[a-zA-Z_$][a-zA-Z0-9_$]*/ contains=@props,@_semantic transparent nextgroup=@javascriptAfterIdentifier
syntax match   javascriptMethod                contained /[a-zA-Z_$][a-zA-Z0-9_$]*\ze(/ contains=@props transparent nextgroup=javascriptFuncCallArg
syntax match   javascriptDotNotation           /\./ nextgroup=javascriptProp,javascriptMethod skipwhite skipempty
syntax match   javascriptDotStyleNotation      /\.style\./ nextgroup=javascriptDOMStyle transparent

runtime syntax/yajs/javascript.vim
runtime syntax/yajs/es6-number.vim
runtime syntax/yajs/es6-string.vim
runtime syntax/yajs/es6-array.vim
runtime syntax/yajs/es6-object.vim
runtime syntax/yajs/es6-symbol.vim
runtime syntax/yajs/es6-function.vim
runtime syntax/yajs/es6-math.vim
runtime syntax/yajs/es6-date.vim
runtime syntax/yajs/es6-json.vim
runtime syntax/yajs/es6-regexp.vim
runtime syntax/yajs/es6-map.vim
runtime syntax/yajs/es6-set.vim
runtime syntax/yajs/es6-proxy.vim
runtime syntax/yajs/es6-promise.vim
runtime syntax/yajs/ecma-402.vim
runtime syntax/yajs/node.vim
runtime syntax/yajs/web.vim
runtime syntax/yajs/web-window.vim
runtime syntax/yajs/web-navigator.vim
runtime syntax/yajs/web-location.vim
runtime syntax/yajs/web-history.vim
runtime syntax/yajs/web-console.vim
runtime syntax/yajs/web-xhr.vim
runtime syntax/yajs/web-blob.vim
runtime syntax/yajs/web-crypto.vim
runtime syntax/yajs/web-fetch.vim
runtime syntax/yajs/web-service-worker.vim
runtime syntax/yajs/dom-node.vim
runtime syntax/yajs/dom-elem.vim
runtime syntax/yajs/dom-document.vim
runtime syntax/yajs/dom-event.vim
runtime syntax/yajs/dom-storage.vim
runtime syntax/yajs/css.vim

let javascript_props = 1

runtime syntax/yajs/event.vim
syntax region  javascriptEventString           contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ contains=javascriptASCII,@events

"Import
syntax region  javascriptImportDef             start=/import/ end=/;\|\n/ contains=javascriptImport,javascriptImportBlock,javascriptString,javascriptEndColons
syntax keyword javascriptImport                contained from as import
syntax keyword javascriptImportAs              contained as
syntax region  javascriptImportBlock           matchgroup=javascriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=javascriptImportAs
syntax keyword javascriptExport                export nextgroup=javascriptExportDefault skipwhite
syntax keyword javascriptExport                module
syntax keyword javascriptExportDefault         contained default

syntax region  javascriptBlock                 matchgroup=javascriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=@htmlJavaScript

syntax match   javascriptObjectMethodName      contained /[a-zA-Z_$]\k*\ze\_s*(/ nextgroup=javascriptFuncArg skipwhite skipempty
syntax cluster javascriptObjectMethod          contains=javascriptMethodAccessor,javascriptObjectMethodName

syntax match   javascriptMethodName            contained /[a-zA-Z_$]\k*/ nextgroup=javascriptFuncArg skipwhite skipempty
syntax match   javascriptMethodAccessor        contained /\(\(set\|get\)\>\|\*\)\ze\_s*\(\[\|\k\)/ contains=@javascriptMethodAccessorWords nextgroup=javascriptMethodName skipwhite
syntax keyword javascriptMethodAccessorWords   contained get set
syntax region  javascriptMethodName            contained matchgroup=javascriptMethodName start=/\[/ end=/]/ contains=@javascriptValue nextgroup=javascriptFuncArg skipwhite skipempty

" syntax keyword javascriptFuncKeyword           function nextgroup=javascriptAsyncFunc,javascriptSyncFunc
syntax match   javascriptSyncFunc              contained /\s*/ nextgroup=javascriptFuncName,javascriptFuncArg
syntax match   javascriptAsyncFunc             contained /\s*\*\s*/ nextgroup=javascriptFuncName,javascriptFuncArg skipwhite skipempty
syntax match   javascriptFuncName              contained /[a-zA-Z_$]\k*/ nextgroup=javascriptFuncArg skipwhite
syntax region  javascriptFuncArg               contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptFuncKeyword,javascriptComma,javascriptDefaultAssign,@javascriptComments nextgroup=javascriptBlock skipwhite skipwhite skipempty

syntax match   javascriptComma                 contained /,/
syntax match   javascriptDefaultAssign         contained /=/ nextgroup=@javascriptExpression skipwhite skipempty


"Class
syntax keyword javascriptClassKeyword          class nextgroup=javascriptClassName skipwhite
syntax keyword javascriptClassSuper            super
syntax match   javascriptClassName             contained /\k\+/ nextgroup=javascriptClassBlock,javascriptClassExtends skipwhite
syntax match   javascriptClassSuperName        contained /[a-zA-Z_$][a-zA-Z_$\[\]\.]*/ nextgroup=javascriptClassBlock skipwhite
syntax keyword javascriptClassExtends          contained extends nextgroup=javascriptClassSuperName skipwhite
syntax region  javascriptClassBlock            contained matchgroup=javascriptBraces start=/{/ end=/}/ contains=javascriptMethodName,javascriptMethodAccessor,javascriptClassStatic,@javascriptComments
syntax keyword javascriptClassStatic           contained static nextgroup=javascriptMethodName,javascriptMethodAccessor skipwhite


syntax keyword javascriptForComprehension      contained for nextgroup=javascriptForComprehensionTail skipwhite skipempty
syntax region  javascriptForComprehensionTail  contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptOfComprehension,@javascriptExpression nextgroup=javascriptForComprehension,javascriptIfComprehension,@javascriptExpression skipwhite skipempty
syntax keyword javascriptOfComprehension       contained of
syntax keyword javascriptIfComprehension       contained if nextgroup=javascriptIfComprehensionTail
syntax region  javascriptIfComprehensionTail   contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptExpression nextgroup=javascriptForComprehension,javascriptIfComprehension skipwhite skipempty

syntax region  javascriptObjectLiteral         contained matchgroup=javascriptBraces start=/{/ end=/}/ contains=@javascriptComments,javascriptObjectLabel,javascriptComma,@javascriptObjectMethod,javascriptPropertyName,javascriptComputedPropertyName,@javascriptValue

" syntax match   javascriptBraces                /[\[\]]/
syntax match   javascriptParens                /[()]/
" syntax match   javascriptOpSymbols             /[^+\-*/%\^=!<>&|?]\@<=\(<\|>\|<=\|>=\|==\|!=\|===\|!==\|+\|-\|*\|%\|++\|--\|<<\|>>\|>>>\|&\||\|^\|!\|\~\|&&\|||\|?\|=\|+=\|-=\|*=\|%=\|<<=\|>>=\|>>>=\|&=\||=\|^=\|\/\|\/=\)\ze\_[^+\-*/%\^=!<>&|?]/ nextgroup=@javascriptExpression skipwhite
syntax region  htmlScriptTag     contained start=+<script+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syntax match   javascriptWOpSymbols            contained /\_s\+/ nextgroup=javascriptOpSymbols
syntax match   javascriptEndColons             /[;,]/
syntax match   javascriptLogicSymbols          /[&|]\+/ contains=javascriptInvalidOp,javascriptLogicSymbol nextgroup=@javascriptExpression,@javascriptComments skipwhite skipempty
syntax match   javascriptLogicSymbol           /\(&&\|||\)/
syntax cluster javascriptSymbols               contains=javascriptOpSymbols,javascriptLogicSymbols
syntax match   javascriptWSymbols              contained /\_s\+/ nextgroup=@javascriptSymbols,@javascriptComments,javascriptDotNotation

syntax region  javascriptRegexpString          start="\(^\|&\||\|=\|(\|{\|;\|:\|\[\|!\|?\)\@<=\_s*/\ze[^/*]" skip="\\\\\|[^\\]\@<=\\/" end="/[gimy]\{0,2\}" oneline contains=javascriptRegexpSet,javascriptRegexpLeftBracket
syntax region  javascriptRegexpSet             contained start="\[" skip="[^\\]\@<=\\\]" end="\]" extend 
syntax match   javascriptRegexpLeftBracket     contained /\\\[/ 

syntax cluster javascriptEventTypes            contains=javascriptEventString,javascriptTemplate,javascriptNumber,javascriptBoolean,javascriptNull
syntax cluster javascriptOps                   contains=javascriptOpSymbols,javascriptLogicSymbols,javascriptOperator
syntax region  javascriptParenExp              matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptExpression nextgroup=@javascriptComments,@javascriptSymbols skipwhite skipempty
syntax cluster javascriptExpression            contains=javascriptArrowFuncDef,javascriptParenExp,@javascriptValue,javascriptObjectLiteral,javascriptFuncKeyword,javascriptYield,javascriptIdentifierName,javascriptRegexpString,@javascriptTypes,@javascriptOps,javascriptGlobal,javascriptGlobalMethod,jsxRegion
syntax cluster javascriptEventExpression       contains=javascriptArrowFuncDef,javascriptParenExp,@javascriptValue,javascriptObjectLiteral,javascriptFuncKeyword,javascriptIdentifierName,javascriptRegexpString,@javascriptEventTypes,@javascriptOps,javascriptGlobal,jsxRegion

syntax region  javascriptLoopParen             contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptVariable,javascriptForOperator,javascriptEndColons,@javascriptExpression nextgroup=javascriptBlock skipwhite skipempty

" syntax match   javascriptFuncCall              contained /[a-zA-Z]\k*\ze(/ nextgroup=javascriptFuncCallArg
syntax region  javascriptFuncCallArg           contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptComma,@javascriptExpression,@javascriptComments nextgroup=@javascriptAfterIdentifier skipwhite skipempty 
syntax cluster javascriptSymbols               contains=javascriptOpSymbols,javascriptLogicSymbols
" syntax match   javascriptWSymbols              contained /\_s\+/ nextgroup=@javascriptSymbols
syntax region  javascriptEventFuncCallArg      contained matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptEventExpression,@javascriptComments

syntax match   javascriptArrowFuncDef          /(\_[^)]*)\_s*=>/ contains=javascriptFuncArg,javascriptComma,javascriptArrowFunc nextgroup=javascriptOperator,javascriptIdentifierName,javascriptBlock,javascriptArrowFuncDef skipwhite skipempty
syntax match   javascriptArrowFuncDef          /[a-zA-Z_$][a-zA-Z0-9_$]*\_s*=>/ contains=javascriptArrowFuncArg,javascriptArrowFunc nextgroup=javascriptOperator,javascriptIdentifierName,javascriptBlock,javascriptArrowFuncDef skipwhite skipempty
syntax match   javascriptArrowFunc             /=>/
syntax match   javascriptArrowFuncArg          contained /[a-zA-Z_$]\k*/
syntax keyword javascriptFuncKeyword           function nextgroup=javascriptAsyncFunc,javascriptSyncFunc

if exists("did_javascript_hilink")
  HiLink javascriptReserved             Error
  HiLink javascriptInvalidOp            Error

  HiLink javascriptEndColons            Statement
  HiLink javascriptOpSymbol             Normal
  HiLink javascriptLogicSymbol          Boolean
  HiLink javascriptBraces               Function
  HiLink javascriptBrackets             Function
  HiLink javascriptParens               Normal
  HiLink javascriptComment              Comment
  HiLink javascriptLineComment          Comment
  HiLink javascriptDocComment           Comment
  HiLink javascriptCommentTodo          Todo
  HiLink javascriptDocNotation          SpecialComment
  HiLink javascriptDocTags              SpecialComment
  HiLink javascriptDocNGParam           javascriptDocParam
  HiLink javascriptDocParam             Function
  HiLink javascriptDocNumParam          Function
  HiLink javascriptDocEventRef          Function
  HiLink javascriptDocNamedParamType    Type
  HiLink javascriptDocParamName         Type
  HiLink javascriptDocParamType         Type
  HiLink javascriptString               String
  HiLink javascriptTemplate             String
  HiLink javascriptEventString          String
  HiLink javascriptASCII                Label
  HiLink javascriptTemplateSubstitution Label
  " HiLink javascriptTemplateSBlock       Label
  " HiLink javascriptTemplateSString      Label
  HiLink javascriptTemplateSStringRB    javascriptTemplateSubstitution
  HiLink javascriptTemplateSB           javascriptTemplateSubstitution
  HiLink javascriptRegexpString         String
  HiLink javascriptRegexpSet            javascriptRegexpString
  HiLink javascriptRegexpLeftBracket    javascriptRegexpString
  HiLink javascriptGlobal               Constant
  HiLink javascriptCharacter            Character
  HiLink javascriptPrototype            Type
  HiLink javascriptConditional          Conditional
  HiLink javascriptConditionalElse      Conditional
  HiLink javascriptSwitch               Conditional
  HiLink javascriptCase                 Conditional
  HiLink javascriptDefault              javascriptCase
  HiLink javascriptExportDefault        javascriptCase
  HiLink javascriptBranch               Conditional
  HiLink javascriptIdentifier           Structure
  HiLink javascriptVariable             Identifier
  HiLink javascriptRepeat               Repeat
  HiLink javascriptForComprehension     Repeat
  HiLink javascriptIfComprehension      Repeat
  HiLink javascriptOfComprehension      Repeat
  HiLink javascriptForOperator          Repeat
  HiLink javascriptStatementKeyword     Statement
  HiLink javascriptReturn               Statement
  HiLink javascriptYield                Statement
  HiLink javascriptYieldGen             Statement
  HiLink javascriptMessage              Keyword
  HiLink javascriptOperator             Identifier
  " HiLink javascriptType                 Type
  HiLink javascriptNull                 Boolean
  HiLink javascriptNumber               Number
  HiLink javascriptBoolean              Boolean
  HiLink javascriptObjectLabel          javascriptLabel
  HiLink javascriptLabel                Label
  HiLink javascriptPropertyName         Label
  HiLink javascriptImport               Special
  HiLink javascriptImportAs             Special
  HiLink javascriptExport               Special
  HiLink javascriptTry                  Statement
  HiLink javascriptExceptions           Statement

  HiLink javascriptMethodName           Function
  HiLink javascriptMethodAccessor       Operator
  HiLink javascriptObjectMethodName     Function

  HiLink javascriptFuncKeyword          Keyword
  HiLink javascriptAsyncFunc            Keyword
  HiLink javascriptArrowFunc            Type
  HiLink javascriptFuncName             Function
  HiLink javascriptFuncArg              Special
  HiLink javascriptArrowFuncArg         javascriptFuncArg
  HiLink javascriptComma                Normal

  HiLink javascriptClassKeyword         Keyword
  HiLink javascriptClassExtends         Keyword
  HiLink javascriptClassName            Function
  HiLink javascriptClassSuperName       Function
  HiLink javascriptClassStatic          StorageClass
  HiLink javascriptClassSuper           keyword

  HiLink shellbang                      Comment

  highlight link javaScript             NONE

  delcommand HiLink
  unlet did_javascript_hilink
endif

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

