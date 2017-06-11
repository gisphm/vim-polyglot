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

" Dollar sign is permitted anywhere in an identifier
if v:version > 704 || v:version == 704 && has('patch1142')
  syntax iskeyword @,48-57,_,192-255,$
else
  setlocal iskeyword+=$
endif

syntax sync fromstart
" TODO: Figure out what type of casing I need
" syntax case ignore
syntax case match

syntax match   jsNoise          /[:,\;]\{1}/
syntax match   jsNoise          /[\.]\{1}/ skipwhite skipempty nextgroup=jsObjectProp,jsFuncCall,jsPrototype,jsTaggedTemplate
syntax match   jsObjectProp     contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>/
syntax match   jsFuncCall       /\k\+\%(\s*(\)\@=/
syntax match   jsParensError    /[)}\]]/

" Program Keywords
syntax keyword jsStorageClass   const var let skipwhite skipempty nextgroup=jsDestructuringBlock,jsDestructuringArray,jsVariableDef
syntax match   jsVariableDef    contained /\k\+/ skipwhite skipempty nextgroup=jsFlowDefinition
syntax keyword jsOperator       delete instanceof typeof void new in of skipwhite skipempty nextgroup=@jsExpression
syntax match   jsOperator       /[\!\|\&\+\-\<\>\=\%\/\*\~\^]\{1}/ skipwhite skipempty nextgroup=@jsExpression
syntax match   jsOperator       /::/ skipwhite skipempty nextgroup=@jsExpression
syntax keyword jsBooleanTrue    true
syntax keyword jsBooleanFalse   false

" Modules
syntax keyword jsImport                       import skipwhite skipempty nextgroup=jsModuleAsterisk,jsModuleKeyword,jsModuleGroup,jsFlowImportType
syntax keyword jsExport                       export skipwhite skipempty nextgroup=@jsAll,jsModuleGroup,jsExportDefault,jsModuleAsterisk,jsModuleKeyword
syntax match   jsModuleKeyword      contained /\k\+/ skipwhite skipempty nextgroup=jsModuleAs,jsFrom,jsModuleComma
syntax keyword jsExportDefault      contained default skipwhite skipempty nextgroup=@jsExpression
syntax keyword jsExportDefaultGroup contained default skipwhite skipempty nextgroup=jsModuleAs,jsFrom,jsModuleComma
syntax match   jsModuleAsterisk     contained /\*/ skipwhite skipempty nextgroup=jsModuleKeyword,jsModuleAs,jsFrom
syntax keyword jsModuleAs           contained as skipwhite skipempty nextgroup=jsModuleKeyword,jsExportDefaultGroup
syntax keyword jsFrom               contained from skipwhite skipempty nextgroup=jsString
syntax match   jsModuleComma        contained /,/ skipwhite skipempty nextgroup=jsModuleKeyword,jsModuleAsterisk,jsModuleGroup

" Strings, Templates, Numbers
syntax region  jsString           start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend
syntax region  jsString           start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend
syntax region  jsTemplateString   start=+`+  skip=+\\\(`\|$\)+  end=+`+     contains=jsTemplateExpression,jsSpecial,@Spell extend
syntax match   jsTaggedTemplate   /\k\+\%(`\)\@=/ nextgroup=jsTemplateString
syntax match   jsNumber           /\<\d\+\%([eE][+-]\=\d\+\)\=\>\|\<0[bB][01]\+\>\|\<0[oO]\o\+\>\|\<0[xX]\x\+\>/
syntax keyword jsNumber           Infinity
syntax match   jsFloat            /\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/

" Regular Expressions
syntax match   jsSpecial            contained "\v\\%(0|\\x\x\{2\}\|\\u\x\{4\}\|\c[A-Z]|.)"
syntax region  jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend
syntax region  jsRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+
syntax match   jsRegexpBoundary     contained "\v%(\<@![\^$]|\\[bB])"
syntax match   jsRegexpBackRef      contained "\v\\[1-9][0-9]*"
syntax match   jsRegexpQuantifier   contained "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??"
syntax match   jsRegexpOr           contained "\v\<@!\|"
syntax match   jsRegexpMod          contained "\v\(@<=\?[:=!>]"
syntax region  jsRegexpGroup        contained start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contains=jsRegexpCharClass,@jsRegexpSpecial keepend
if v:version > 703 || v:version == 603 && has("patch1088")
  syntax region  jsRegexpString   start=+\%(\%(\%(return\|case\)\s\+\)\@50<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@50<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimyu]\{,5}+ contains=jsRegexpCharClass,jsRegexpGroup,@jsRegexpSpecial oneline keepend extend
else
  syntax region  jsRegexpString   start=+\%(\%(\%(return\|case\)\s\+\)\@<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimyu]\{,5}+ contains=jsRegexpCharClass,jsRegexpGroup,@jsRegexpSpecial oneline keepend extend
endif
syntax cluster jsRegexpSpecial    contains=jsSpecial,jsRegexpBoundary,jsRegexpBackRef,jsRegexpQuantifier,jsRegexpOr,jsRegexpMod

" Objects
syntax match   jsObjectKey         contained /\<[0-9a-zA-Z_$]*\>\(\s*:\)\@=/ contains=jsFunctionKey skipwhite skipempty nextgroup=jsObjectValue
syntax match   jsObjectColon       contained /:/ skipwhite skipempty
syntax region  jsObjectKeyString   contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell skipwhite skipempty nextgroup=jsObjectValue
syntax region  jsObjectKeyString   contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell skipwhite skipempty nextgroup=jsObjectValue
syntax region  jsObjectKeyComputed contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsObjectValue,jsFuncArgs extend
syntax match   jsObjectSeparator   contained /,/
syntax region  jsObjectValue       contained matchgroup=jsNoise start=/:/ end=/\%(,\|}\)\@=/ contains=@jsExpression extend
syntax match   jsObjectFuncName    contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>[\r\n\t ]*(\@=/ skipwhite skipempty nextgroup=jsFuncArgs
syntax match   jsFunctionKey       contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\s*function\s*\)\@=/
syntax match   jsObjectMethodType  contained /\%(get\|set\)\%( \k\+\)\@=/ skipwhite skipempty nextgroup=jsObjectFuncName
syntax region  jsObjectStringKey   contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs,jsObjectValue
syntax region  jsObjectStringKey   contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs,jsObjectValue

exe 'syntax keyword jsNull      null             '.(exists('g:javascript_conceal_null')      ? 'conceal cchar='.g:javascript_conceal_null       : '')
exe 'syntax keyword jsReturn    return contained '.(exists('g:javascript_conceal_return')    ? 'conceal cchar='.g:javascript_conceal_return     : '').' skipwhite skipempty nextgroup=@jsExpression'
exe 'syntax keyword jsUndefined undefined        '.(exists('g:javascript_conceal_undefined') ? 'conceal cchar='.g:javascript_conceal_undefined  : '')
exe 'syntax keyword jsNan       NaN              '.(exists('g:javascript_conceal_NaN')       ? 'conceal cchar='.g:javascript_conceal_NaN        : '')
exe 'syntax keyword jsPrototype prototype        '.(exists('g:javascript_conceal_prototype') ? 'conceal cchar='.g:javascript_conceal_prototype  : '')
exe 'syntax keyword jsThis      this             '.(exists('g:javascript_conceal_this')      ? 'conceal cchar='.g:javascript_conceal_this       : '')
exe 'syntax keyword jsSuper     super  contained '.(exists('g:javascript_conceal_super')     ? 'conceal cchar='.g:javascript_conceal_super      : '')

" Statement Keywords
syntax match   jsBlockLabel              /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\s*::\@!/    contains=jsNoise skipwhite skipempty nextgroup=jsBlock
syntax match   jsBlockLabelKey contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\%(\s*\%(;\|\n\)\)\@=/
syntax keyword jsStatement    contained with yield debugger
syntax keyword jsStatement    contained break continue skipwhite skipempty nextgroup=jsBlockLabelKey
syntax keyword jsConditional            if             skipwhite skipempty nextgroup=jsParenIfElse
syntax keyword jsConditional            else           skipwhite skipempty nextgroup=jsCommentIfElse,jsIfElseBlock
syntax keyword jsConditional            switch         skipwhite skipempty nextgroup=jsParenSwitch
syntax keyword jsRepeat                 while for      skipwhite skipempty nextgroup=jsParenRepeat,jsForAwait
syntax keyword jsDo                     do             skipwhite skipempty nextgroup=jsRepeatBlock
syntax region  jsSwitchCase   contained matchgroup=jsLabel start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@jsExpression,jsLabel skipwhite skipempty nextgroup=jsSwitchColon keepend
syntax keyword jsTry                    try            skipwhite skipempty nextgroup=jsTryCatchBlock
syntax keyword jsFinally      contained finally        skipwhite skipempty nextgroup=jsFinallyBlock
syntax keyword jsCatch        contained catch          skipwhite skipempty nextgroup=jsParenCatch
syntax keyword jsException              throw
syntax keyword jsAsyncKeyword           async await
syntax match   jsSwitchColon   contained /::\@!/       skipwhite skipempty nextgroup=jsSwitchBlock

" Keywords
syntax keyword jsGlobalObjects      Array Boolean Date Function Iterator Number Object Symbol Map WeakMap Set RegExp String Proxy Promise Buffer ParallelArray ArrayBuffer DataView Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray JSON Math console document window Intl Collator DateTimeFormat NumberFormat fetch
syntax keyword jsGlobalNodeObjects  module exports global process __dirname __filename
syntax match   jsGlobalNodeObjects  /\<require\>/ containedin=jsFuncCall
syntax keyword jsExceptions         Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError
syntax keyword jsBuiltins           decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval
" DISCUSS: How imporant is this, really? Perhaps it should be linked to an error because I assume the keywords are reserved?
syntax keyword jsFutureKeys         abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient implements protected volatile double public

" DISCUSS: Should we really be matching stuff like this?
" DOM2 Objects
syntax keyword jsGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword jsExceptions     DOMException

" DISCUSS: Should we really be matching stuff like this?
" DOM2 CONSTANT
syntax keyword jsDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword jsDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" DISCUSS: Should we really be special matching on these props?
" HTML events and internal variables
syntax keyword jsHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize

" Code blocks
syntax region  jsBracket                      matchgroup=jsBrackets            start=/\[/ end=/\]/ contains=@jsExpression,jsSpreadExpression extend fold
syntax region  jsParen                        matchgroup=jsParens              start=/(/  end=/)/  contains=@jsAll extend fold
syntax region  jsParenDecorator     contained matchgroup=jsParensDecorator     start=/(/  end=/)/  contains=@jsAll extend fold
syntax region  jsParenIfElse        contained matchgroup=jsParensIfElse        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsCommentIfElse,jsIfElseBlock extend fold
syntax region  jsParenRepeat        contained matchgroup=jsParensRepeat        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsCommentRepeat,jsRepeatBlock extend fold
syntax region  jsParenSwitch        contained matchgroup=jsParensSwitch        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsSwitchBlock extend fold
syntax region  jsParenCatch         contained matchgroup=jsParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=jsTryCatchBlock extend fold
syntax region  jsFuncArgs           contained matchgroup=jsFuncParens          start=/(/  end=/)/  contains=jsFuncArgCommas,jsComment,jsFuncArgExpression,jsDestructuringBlock,jsDestructuringArray,jsRestExpression,jsFlowArgumentDef skipwhite skipempty nextgroup=jsCommentFunction,jsFuncBlock,jsFlowReturn extend fold
syntax region  jsClassBlock         contained matchgroup=jsClassBraces         start=/{/  end=/}/  contains=jsClassFuncName,jsClassMethodType,jsArrowFunction,jsArrowFuncArgs,jsComment,jsGenerator,jsDecorator,jsClassProperty,jsClassPropertyComputed,jsClassStringKey,jsAsyncKeyword,jsNoise extend fold
syntax region  jsFuncBlock          contained matchgroup=jsFuncBraces          start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsIfElseBlock        contained matchgroup=jsIfElseBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsTryCatchBlock      contained matchgroup=jsTryCatchBraces      start=/{/  end=/}/  contains=@jsAll,jsBlock skipwhite skipempty nextgroup=jsCatch,jsFinally extend fold
syntax region  jsFinallyBlock       contained matchgroup=jsFinallyBraces       start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsSwitchBlock        contained matchgroup=jsSwitchBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock,jsSwitchCase extend fold
syntax region  jsRepeatBlock        contained matchgroup=jsRepeatBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsDestructuringBlock contained matchgroup=jsDestructuringBraces start=/{/  end=/}/  contains=jsDestructuringProperty,jsDestructuringAssignment,jsDestructuringNoise,jsDestructuringPropertyComputed,jsSpreadExpression,jsComment extend fold
syntax region  jsDestructuringArray contained matchgroup=jsDestructuringBraces start=/\[/ end=/\]/ contains=jsDestructuringPropertyValue,jsNoise,jsDestructuringProperty,jsSpreadExpression,jsComment extend fold
syntax region  jsObject             contained matchgroup=jsObjectBraces        start=/{/  end=/}/  contains=jsObjectKey,jsObjectKeyString,jsObjectKeyComputed,jsObjectSeparator,jsObjectFuncName,jsObjectMethodType,jsGenerator,jsComment,jsObjectStringKey,jsSpreadExpression,jsDecorator,jsAsyncKeyword extend fold
syntax region  jsBlock                        matchgroup=jsBraces              start=/{/  end=/}/  contains=@jsAll,jsSpreadExpression extend fold
syntax region  jsModuleGroup        contained matchgroup=jsModuleBraces        start=/{/ end=/}/   contains=jsModuleKeyword,jsModuleComma,jsModuleAs,jsComment skipwhite skipempty nextgroup=jsFrom
syntax region  jsSpreadExpression   contained matchgroup=jsSpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@jsExpression
syntax region  jsRestExpression     contained matchgroup=jsRestOperator        start=/\.\.\./ end=/[,)]\@=/
syntax region  jsTernaryIf                    matchgroup=jsTernaryIfOperator   start=/?/  end=/\%(:\|[\}]\@=\)/  contains=@jsExpression extend skipwhite skipempty nextgroup=@jsExpression

syntax match   jsGenerator            contained /\*/ skipwhite skipempty nextgroup=jsFuncName,jsFuncArgs
syntax match   jsFuncName             contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>/ skipwhite skipempty nextgroup=jsFuncArgs,jsFlowFunctionGroup
syntax region  jsFuncArgExpression    contained matchgroup=jsFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@jsExpression extend
syntax match   jsFuncArgCommas        contained ','
syntax keyword jsArguments            contained arguments
syntax keyword jsForAwait             contained await skipwhite skipempty nextgroup=jsParenRepeat

" Matches a single keyword argument with no parens
syntax match   jsArrowFuncArgs  /\k\+\s*\%(=>\)\@=/ skipwhite contains=jsFuncArgs skipwhite skipempty nextgroup=jsArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match   jsArrowFuncArgs  /([^()]*)\s*\(=>\)\@=/ contains=jsFuncArgs skipempty skipwhite nextgroup=jsArrowFunction extend

exe 'syntax match jsFunction /\<function\>/ skipwhite skipempty nextgroup=jsGenerator,jsFuncName,jsFuncArgs skipwhite '.(exists('g:javascript_conceal_function')       ? 'conceal cchar='.g:javascript_conceal_function : '')
exe 'syntax match jsArrowFunction /=>/      skipwhite skipempty nextgroup=jsFuncBlock,jsCommentFunction               '.(exists('g:javascript_conceal_arrow_function') ? 'conceal cchar='.g:javascript_conceal_arrow_function : '')
exe 'syntax match jsArrowFunction /()\s*\(=>\)\@=/   skipwhite skipempty nextgroup=jsArrowFunction                    '.(exists('g:javascript_conceal_noarg_arrow_function') ? 'conceal cchar='.g:javascript_conceal_noarg_arrow_function : '').(' contains=jsArrowFuncArgs')
exe 'syntax match jsArrowFunction /_\s*\(=>\)\@=/    skipwhite skipempty nextgroup=jsArrowFunction                    '.(exists('g:javascript_conceal_underscore_arrow_function') ? 'conceal cchar='.g:javascript_conceal_underscore_arrow_function : '')

" Classes
syntax keyword jsClassKeyword           contained class
syntax keyword jsExtendsKeyword         contained extends skipwhite skipempty nextgroup=@jsExpression
syntax match   jsClassNoise             contained /\./
syntax match   jsClassMethodType        contained /\%(get\|set\|static\)\%( \k\+\)\@=/ skipwhite skipempty nextgroup=jsAsyncKeyword,jsFuncName,jsClassProperty
syntax region  jsClassDefinition                  start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=jsClassKeyword,jsExtendsKeyword,jsClassNoise,@jsExpression skipwhite skipempty nextgroup=jsCommentClass,jsClassBlock,jsFlowClassGroup
syntax match   jsClassProperty          contained /\<[0-9a-zA-Z_$]*\>\(\s*=\)\@=/ skipwhite skipempty nextgroup=jsClassValue
syntax region  jsClassValue             contained start=/=/ end=/\%(;\|}\|\n\)\@=/ contains=@jsExpression
syntax region  jsClassPropertyComputed  contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsFuncArgs,jsClassValue extend
syntax match   jsClassFuncName          contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\%(\s*(\)\@=/ skipwhite skipempty nextgroup=jsFuncArgs
syntax region  jsClassStringKey         contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs
syntax region  jsClassStringKey         contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs

" Destructuring
syntax match   jsDestructuringPropertyValue     contained /\<[0-9a-zA-Z_$]*\>/
syntax match   jsDestructuringProperty          contained /\<[0-9a-zA-Z_$]*\>\(\s*=\)\@=/ skipwhite skipempty nextgroup=jsDestructuringValue
syntax match   jsDestructuringAssignment        contained /\<[0-9a-zA-Z_$]*\>\(\s*:\)\@=/ skipwhite skipempty nextgroup=jsDestructuringValueAssignment
syntax region  jsDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@jsExpression extend
syntax region  jsDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=jsDestructuringPropertyValue,jsDestructuringBlock,jsNoise,jsDestructuringNoise skipwhite skipempty nextgroup=jsDestructuringValue extend
syntax match   jsDestructuringNoise             contained /[,\[\]]/
syntax region  jsDestructuringPropertyComputed  contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsDestructuringValue,jsDestructuringNoise extend fold

" Comments
syntax keyword jsCommentTodo    contained TODO FIXME XXX TBD
syntax region  jsComment        start=/\/\// end=/$/ contains=jsCommentTodo,@Spell extend keepend
syntax region  jsComment        start=/\/\*/  end=/\*\// contains=jsCommentTodo,@Spell fold extend keepend
syntax region  jsEnvComment     start=/\%^#!/ end=/$/ display

" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make jsComment a skippable type of group for nextgroup
syntax region  jsCommentFunction    contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsFuncBlock,jsFlowReturn extend keepend
syntax region  jsCommentFunction    contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsFuncBlock,jsFlowReturn fold extend keepend
syntax region  jsCommentClass       contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsClassBlock,jsFlowClassGroup extend keepend
syntax region  jsCommentClass       contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsClassBlock,jsFlowClassGroup fold extend keepend
syntax region  jsCommentIfElse      contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsIfElseBlock extend keepend
syntax region  jsCommentIfElse      contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsIfElseBlock fold extend keepend
syntax region  jsCommentRepeat      contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsRepeatBlock extend keepend
syntax region  jsCommentRepeat      contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsRepeatBlock fold extend keepend

" Decorators
syntax match   jsDecorator                    /^\s*@/ nextgroup=jsDecoratorFunction
syntax match   jsDecoratorFunction  contained /[a-zA-Z_][a-zA-Z0-9_.]*/ nextgroup=jsParenDecorator

if exists("javascript_plugin_jsdoc")
  runtime extras/jsdoc.vim
  " NGDoc requires JSDoc
  if exists("javascript_plugin_ngdoc")
    runtime extras/ngdoc.vim
  endif
endif

if exists("javascript_plugin_flow")
  runtime extras/flow.vim
endif

syntax cluster jsExpression  contains=jsBracket,jsParen,jsObject,jsTernaryIf,jsTaggedTemplate,jsTemplateString,jsString,jsRegexpString,jsNumber,jsFloat,jsOperator,jsBooleanTrue,jsBooleanFalse,jsNull,jsFunction,jsArrowFunction,jsGlobalObjects,jsExceptions,jsFutureKeys,jsDomErrNo,jsDomNodeConsts,jsHtmlEvents,jsFuncCall,jsUndefined,jsNan,jsPrototype,jsBuiltins,jsNoise,jsClassDefinition,jsArrowFunction,jsArrowFuncArgs,jsParensError,jsComment,jsArguments,jsThis,jsSuper,jsDo,jsForAwait
syntax cluster jsAll         contains=@jsExpression,jsStorageClass,jsConditional,jsRepeat,jsReturn,jsStatement,jsException,jsTry,jsAsyncKeyword,jsNoise,jsBlockLabel

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
  HiLink jsComment              Comment
  HiLink jsEnvComment           PreProc
  HiLink jsParensIfElse         jsParens
  HiLink jsParensRepeat         jsParens
  HiLink jsParensSwitch         jsParens
  HiLink jsParensCatch          jsParens
  HiLink jsCommentTodo          Todo
  HiLink jsString               String
  HiLink jsObjectKeyString      String
  HiLink jsTemplateString       String
  HiLink jsObjectStringKey      String
  HiLink jsClassStringKey       String
  HiLink jsTaggedTemplate       StorageClass
  HiLink jsTernaryIfOperator    Operator
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
  HiLink jsDo                   Repeat
  HiLink jsStatement            Statement
  HiLink jsException            Exception
  HiLink jsTry                  Exception
  HiLink jsFinally              Exception
  HiLink jsCatch                Exception
  HiLink jsAsyncKeyword         Keyword
  HiLink jsForAwait             Keyword
  HiLink jsArrowFunction        Type
  HiLink jsFunction             Type
  HiLink jsGenerator            jsFunction
  HiLink jsArrowFuncArgs        jsFuncArgs
  HiLink jsFuncName             Function
  HiLink jsClassFuncName        jsFuncName
  HiLink jsObjectFuncName       Function
  HiLink jsArguments            Special
  HiLink jsError                Error
  HiLink jsParensError          Error
  HiLink jsOperator             Operator
  HiLink jsOf                   Operator
  HiLink jsStorageClass         StorageClass
  HiLink jsClassKeyword         Keyword
  HiLink jsExtendsKeyword       Keyword
  HiLink jsThis                 Special
  HiLink jsSuper                Constant
  HiLink jsNan                  Number
  HiLink jsNull                 Type
  HiLink jsUndefined            Type
  HiLink jsNumber               Number
  HiLink jsFloat                Float
  HiLink jsBooleanTrue          Boolean
  HiLink jsBooleanFalse         Boolean
  HiLink jsObjectColon          jsNoise
  HiLink jsNoise                Noise
  HiLink jsBrackets             Noise
  HiLink jsParens               Noise
  HiLink jsBraces               Noise
  HiLink jsFuncBraces           Noise
  HiLink jsFuncParens           Noise
  HiLink jsClassBraces          Noise
  HiLink jsClassNoise           Noise
  HiLink jsIfElseBraces         Noise
  HiLink jsTryCatchBraces       Noise
  HiLink jsModuleBraces         Noise
  HiLink jsObjectBraces         Noise
  HiLink jsObjectSeparator      Noise
  HiLink jsFinallyBraces        Noise
  HiLink jsRepeatBraces         Noise
  HiLink jsSwitchBraces         Noise
  HiLink jsSpecial              Special
  HiLink jsTemplateBraces       Noise
  HiLink jsGlobalObjects        Constant
  HiLink jsGlobalNodeObjects    Constant
  HiLink jsExceptions           Constant
  HiLink jsBuiltins             Constant
  HiLink jsImport               Include
  HiLink jsExport               Include
  HiLink jsExportDefault        StorageClass
  HiLink jsExportDefaultGroup   jsExportDefault
  HiLink jsModuleAs             Include
  HiLink jsModuleComma          jsNoise
  HiLink jsModuleAsterisk       Noise
  HiLink jsFrom                 Include
  HiLink jsDecorator            Special
  HiLink jsDecoratorFunction    Function
  HiLink jsParensDecorator      jsParens
  HiLink jsFuncArgOperator      jsFuncArgs
  HiLink jsClassProperty        jsObjectKey
  HiLink jsSpreadOperator       Operator
  HiLink jsRestOperator         Operator
  HiLink jsRestExpression       jsFuncArgs
  HiLink jsSwitchColon          Noise
  HiLink jsClassMethodType      Type
  HiLink jsObjectMethodType     Type
  HiLink jsClassDefinition      jsFuncName
  HiLink jsBlockLabel           Identifier
  HiLink jsBlockLabelKey        jsBlockLabel

  HiLink jsDestructuringBraces     Noise
  HiLink jsDestructuringProperty   jsFuncArgs
  HiLink jsDestructuringAssignment jsObjectKey
  HiLink jsDestructuringNoise      Noise

  HiLink jsCommentFunction      jsComment
  HiLink jsCommentClass         jsComment
  HiLink jsCommentIfElse        jsComment
  HiLink jsCommentRepeat        jsComment

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
syntax cluster  htmlJavaScript       contains=@jsAll,jsImport,jsExport
syntax cluster  javaScriptExpression contains=@jsAll

" Vim's default html.vim highlights all javascript as 'Special'
hi! def link javaScript              NONE

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif
" Vim syntax file
" Language:     JavaScript (ECMAScript 2015)
" Maintainer:   Kao Wei-Ko(othree) <othree@gmail.com>
" Last Change:  2016-10-20
" Version:      1.5
" Changes:      Go to https://github.com/othree/yajs.vim for recent changes.
" Repository:   https://github.com/othree/yajs.vim
" Upstream:     https://github.com/jelera/vim-javascript-syntax
" Credits:      Jose Elera Campana, Zhao Yi, Claudio Fleiner, Scott Shattuck 
"               (This file is based on their hard work), gumnos (From the #vim 
"               IRC Channel in Freenode)


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

" Dollar sign is permitted anywhere in an identifier
" Patch 7.4.1142
if has("patch-7.4-1142")
  if has("win32")
    syn iskeyword @,48-57,_,128-167,224-235,$
  else
    syn iskeyword @,48-57,_,192-255,$
  endif
endif


syntax sync fromstart

" Syntax coloring for Node.js shebang line
syntax match   shellbang "^#!.*node\>"
syntax match   shellbang "^#!.*iojs\>"


" Operator
syntax match   javascriptOpSymbols             /[+\-*/%\^~=<>&|?]\+/ contains=javascriptOpSymbol,javascriptInvalidOp nextgroup=@javascriptComments,@javascriptExpression skipwhite skipempty

syntax match   javascriptInvalidOp             contained /[+\-*/%\^~=!<>&|?:]\+/

syntax match   javascriptOpSymbol              contained /\(=\|?\)/ nextgroup=@javascriptExpression skipwhite skipempty " 2: =, ?
syntax match   javascriptOpSymbol              contained /===\?/ " 2: ==, ===
syntax match   javascriptOpSymbol              contained /\(>>>=\|>>>\|>>=\|>>\|>=\|>\)/ " 6: >>>=, >>>, >>=, >>, >=, >
syntax match   javascriptOpSymbol              contained /\(<<=\|<<\|<=\|<\)/ " 4: <<=, <<, <=, <
syntax match   javascriptOpSymbol              contained /\(||\||=\||\)/ " 3: ||, |=, |
syntax match   javascriptOpSymbol              contained /\(&&\|&=\|&\)/ " 3: &&, &=, &
syntax match   javascriptOpSymbol              contained /\(*=\|*\)/ " 2: *=, *
syntax match   javascriptOpSymbol              contained /\(%=\|%\)/ " 2: %=, %
syntax match   javascriptOpSymbol              contained /\(\/=\|\/\)/ " 2: /=, /
syntax match   javascriptOpSymbol              contained /\(\^\|\~\)/ " 2: ^, ~

syntax match   javascriptOpSymbols             /!\+/ nextgroup=javascriptRegexpString,javascriptInvalidOp " 1: !
syntax match   javascriptOpSymbols             /!==\?/ nextgroup=javascriptRegexpString,javascriptInvalidOp " 2: !=, !==
syntax match   javascriptOpSymbols             /+\(+\|=\)\?/ nextgroup=javascriptRegexpString,javascriptInvalidOp " 3: +, ++, +=
syntax match   javascriptOpSymbols             /-\(-\|=\)\?/ nextgroup=javascriptRegexpString,javascriptInvalidOp " 3: -, --, -=
" spread operator
syntax match   javascriptSpreadOp              contained /\.\.\./ " 1
" exponentiation operator
syntax match   javascriptOpSymbol              contained /\(**\|**=\)/ " 2: **, **=


" Comment
syntax keyword javascriptCommentTodo           contained TODO FIXME XXX TBD
syntax region  javascriptLineComment           start="//" end="\n" contains=@Spell,javascriptCommentTodo 
syntax region  javascriptComment               start="/\*"  end="\*/" contains=@Spell,javascriptCommentTodo extend fold
syntax region  javascriptComment               start="<!--"  end="--\s*>" contains=@Spell,javascriptCommentTodo extend fold
syntax cluster javascriptComments              contains=javascriptDocComment,javascriptComment,javascriptLineComment

" JSDoc
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
syntax keyword javascriptDocTags               contained deprecated description desc external host nextgroup=javascriptDocDesc skipwhite
syntax keyword javascriptDocTags               contained file fileOverview overview namespace requires since version nextgroup=javascriptDocDesc skipwhite
syntax keyword javascriptDocTags               contained summary todo license preserve nextgroup=javascriptDocDesc skipwhite

syntax keyword javascriptDocTags               contained borrows exports nextgroup=javascriptDocA skipwhite
syntax keyword javascriptDocTags               contained param arg argument property prop module nextgroup=javascriptDocNamedParamType,javascriptDocParamName skipwhite
syntax keyword javascriptDocTags               contained type nextgroup=javascriptDocParamType skipwhite
syntax keyword javascriptDocTags               contained define enum extends implements this typedef nextgroup=javascriptDocParamType skipwhite
syntax keyword javascriptDocTags               contained return returns throws exception nextgroup=javascriptDocParamType,javascriptDocParamName skipwhite
syntax keyword javascriptDocTags               contained see nextgroup=javascriptDocRef skipwhite

" plugins
syntax keyword javascriptDocTags               contained category inheritparams nextgroup=javascriptDocParam skipwhite
syntax keyword javascriptDocTags               contained toparam nextgroup=javascriptDocNamedParamType,javascriptDocParamName skipwhite

"syntax for event firing
syntax keyword javascriptDocTags               contained emits fires nextgroup=javascriptDocEventRef skipwhite

syntax keyword javascriptDocTags               contained function func method nextgroup=javascriptDocName skipwhite
syntax match   javascriptDocName               contained /\h\w*/

syntax keyword javascriptDocTags               contained fires event nextgroup=javascriptDocEventRef skipwhite
syntax match   javascriptDocEventRef           contained /\h\w*#\(\h\w*\:\)\?\h\w*/

syntax match   javascriptDocNamedParamType     contained /{.\+}/ nextgroup=javascriptDocParamName skipwhite
syntax match   javascriptDocParamName          contained /\[\?[0-9a-zA-Z_=\.]\+\]\?/ nextgroup=javascriptDocDesc skipwhite
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

syntax cluster javascriptAfterIdentifier       contains=javascriptDotNotation,javascriptFuncCallArg,javascriptComputedProperty,javascriptOpSymbols,@javascriptComments
" syntax match   javascriptIdentifierName        /\<[^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^0-9][^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^]*/ nextgroup=@javascriptAfterIdentifier contains=@_semantic skipwhite skipempty
syntax match   javascriptIdentifierName        /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ nextgroup=@javascriptAfterIdentifier contains=javascriptGlobal,@_semantic skipwhite skipempty
syntax match   javascriptTagRef                /\<[a-zA-Z_$][0-9a-zA-Z_$]*\ze`/ nextgroup=javascriptTemplate
" runtime syntax/semhl.vim

"Block VariableStatement EmptyStatement ExpressionStatement IfStatement IterationStatement ContinueStatement BreakStatement ReturnStatement WithStatement LabelledStatement SwitchStatement ThrowStatement TryStatement DebuggerStatement

syntax cluster javascriptStatement             contains=javascriptBlock,javascriptVariable,@javascriptExpression,javascriptConditional,javascriptRepeat,javascriptBranch,javascriptLabel,javascriptStatementKeyword,javascriptTry,javascriptDebugger

syntax match   javascriptDotNotation           /\./ nextgroup=javascriptProp,javascriptMethod skipwhite skipempty
syntax match   javascriptDotStyleNotation      /\.style\./ nextgroup=javascriptDOMStyle transparent

" String
syntax region  javascriptString                start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=@javascriptComments skipwhite skipempty extend
syntax region  javascriptTemplate              start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/ contains=javascriptTemplateSubstitution nextgroup=@javascriptComments,javascriptOpSymbols skipwhite skipempty keepend
syntax region  javascriptTemplateSubstitution  contained matchgroup=javascriptTemplateSB start=/\${/ end=/}/ contains=javascriptGlobal,javascriptBOMWindowProp,javascriptBOMWindowMethod,@javascriptExpression extend
" syntax match   javascriptTemplateTag           /\k\+/ nextgroup=javascriptTemplate
syntax region  javascriptArray                 matchgroup=javascriptBrackets start=/\[/ end=/]/ contains=@javascriptValue,javascriptComma,javascriptForComprehension,@javascriptComments,javascriptSpreadOp nextgroup=@javascriptComments,javascriptOpSymbols,@javascriptAfterIdentifier skipwhite skipempty

" Unicode Escape
syntax match   javascriptUnicodeEscapeSequence /\\u[0-9a-fA-F]\{4}/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptUnicodeEscapeSequence /\\u{[0-9a-fA-F]\+}/ nextgroup=@javascriptComments skipwhite skipempty

" Number
syntax match   javascriptNumber                /\<0[bB][01]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /\<0[oO][0-7]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /\<0[xX][0-9a-fA-F]\+\>/ nextgroup=@javascriptComments skipwhite skipempty
syntax match   javascriptNumber                /[+-]\=\%(\d\+\.\d*\|\d\+\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/ nextgroup=@javascriptComments skipwhite skipempty

syntax cluster javascriptTypes                 contains=javascriptString,javascriptTemplate,javascriptTagRef,javascriptRegexpString,javascriptNumber,javascriptBoolean,javascriptNull,javascriptArray
syntax cluster javascriptValue                 contains=@javascriptTypes,@javascriptExpression,javascriptFuncKeyword,javascriptClassKeyword,javascriptObjectLiteral,javascriptIdentifier,javascriptIdentifierName,javascriptOperator,javascriptOpSymbols

syntax match   javascriptLabel                 /[a-zA-Z_$]\k*\_s*:/he=e-1 contains=javascriptReserved nextgroup=@javascriptValue,@javascriptStatement skipwhite skipempty
syntax match   javascriptObjectLabel           contained /\k\+\_s*:/he=e-1 contains=javascriptObjectLabelColon nextgroup=@javascriptComments,@javascriptValue,@javascriptStatement skipwhite skipempty
syntax match   javascriptObjectLabelColon      contained /\s*:/ nextgroup=@javascriptValue skipwhite skipempty
" syntax match   javascriptPropertyName          contained /"[^"]\+"\s*:/he=e-1 nextgroup=@javascriptValue skipwhite skipempty
" syntax match   javascriptPropertyName          contained /'[^']\+'\s*:/he=e-1 nextgroup=@javascriptValue skipwhite skipempty
syntax region  javascriptPropertyNameString    contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=javascriptObjectLabelColon,javascriptFuncArg skipwhite skipempty
syntax region  javascriptComputedPropertyName  contained matchgroup=javascriptPropertyNameString start=/\[/rs=s+1 end=/]/ contains=@javascriptValue nextgroup=javascriptFuncArg,javascriptObjectLabelColon skipwhite skipempty
syntax region  javascriptComputedProperty      contained matchgroup=javascriptProperty start=/\[/rs=s+1 end=/]/ contains=@javascriptValue,javascriptOpSymbols nextgroup=@javascriptAfterIdentifier skipwhite skipempty
" Value for object, statement for label statement

syntax cluster javascriptTemplates             contains=javascriptTemplate,javascriptTemplateSubstitution,javascriptTemplateSB
syntax cluster javascriptStrings               contains=javascriptProp,javascriptString,@javascriptTemplates,javascriptTagRef,@javascriptComments,javascriptDocComment,javascriptRegexpString,javascriptPropertyNameString
syntax cluster javascriptNoReserved            contains=@javascriptStrings,@javascriptDocs,shellbang,javascriptObjectLiteral,javascriptParenObjectLiteral,javascriptObjectLabel,javascriptClassBlock,javascriptMethodName,javascriptMethod
"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved break do catch class const continue
syntax keyword javascriptReservedCase          containedin=ALLBUT,@javascriptNoReserved,javascriptCaseBlock case
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved debugger default delete do else export
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved extends finally for function if import
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved in instanceof let new null return super
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved switch throw try typeof 
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved,javascriptObjectMethodName var
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved void while with yield await

syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved enum implements package protected static
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved interface private public abstract boolean
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved byte char double final float goto int
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved long native short synchronized transient
syntax keyword javascriptReserved              containedin=ALLBUT,@javascriptNoReserved volatile

" JavaScript Prototype
syntax keyword javascriptPrototype             prototype

syntax keyword javascriptImport                from as
syntax keyword javascriptImport                import nextgroup=javascriptImportPattern skipwhite skipempty
syntax keyword javascriptExport                export from default

syntax match   javascriptImportPattern         contained /\*/

" Keywords
syntax keyword javascriptIdentifier            arguments this nextgroup=@javascriptAfterIdentifier
syntax keyword javascriptVariable              let var const nextgroup=javascriptIdentifierName skipwhite
syntax keyword javascriptOperator              delete instanceof typeof void in nextgroup=@javascriptValue,@javascriptTypes skipwhite skipempty
syntax keyword javascriptOperator              new nextgroup=javascriptNewTarget,@javascriptValue,@javascriptTypes skipwhite skipempty
syntax match   javascriptNewTarget             contained /.target/ contains=javascriptTarget
syntax keyword javascriptTarget                contained target
syntax keyword javascriptForOperator           contained in of
syntax keyword javascriptBoolean               true false nextgroup=@javascriptComments skipwhite skipempty
syntax keyword javascriptNull                  null undefined nextgroup=@javascriptComments skipwhite skipempty

" Statement Keywords
syntax keyword javascriptConditional           if else
syntax keyword javascriptConditionalElse       else
syntax keyword javascriptRepeat                do while for nextgroup=javascriptLoopParen skipwhite skipempty
syntax keyword javascriptBranch                break continue
syntax keyword javascriptSwitch                switch nextgroup=javascriptSwitchExpression skipwhite skipempty
syntax keyword javascriptCase                  contained case
syntax keyword javascriptDefault               contained default nextgroup=javascriptCaseColon skipwhite skipempty
syntax keyword javascriptStatementKeyword      with yield
syntax keyword javascriptReturn                return nextgroup=@javascriptValue,javascriptClassSuper,@javascriptComments skipwhite
syntax keyword javascriptYield                 yield nextgroup=javascriptYieldGen skipwhite
syntax match   javascriptYieldGen              contained /\*/

syntax keyword javascriptTry                   try
syntax keyword javascriptExceptions            catch throw finally
syntax keyword javascriptDebugger              debugger

syntax region  javascriptSwitchExpression      contained matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptExpression,@javascriptComments nextgroup=javascriptCaseBlock skipwhite skipempty
if &filetype =~ 'javascript'
  syntax cluster htmlJavaScriptForCase         contains=TOP,javascriptReservedCase
else
  syntax cluster htmlJavaScriptForCase         contains=@htmlJavaScript
  syntax cluster htmlJavaScript                remove=javascriptReservedCase
endif
syntax region  javascriptCaseBlock             matchgroup=javascriptBraces start=/{/ end=/}/ contains=javascriptCaseColon,javascriptCaseExpression,@htmlJavaScriptForCase,javascriptDefault fold
syntax region  javascriptCaseExpression        contained start=/case/ end=/:/ contains=javascriptCase,@javascriptExpression nextgroup=javascriptBlock skipwhite skipempty keepend
syntax match   javascriptCaseColon             contained /:/ nextgroup=javascriptBlock skipwhite skipempty

syntax match   javascriptProp                  contained /[a-zA-Z_$][a-zA-Z0-9_$]*/ contains=@props,@javascriptProps,@_semantic transparent nextgroup=@javascriptAfterIdentifier skipwhite skipempty
syntax match   javascriptMethod                contained /[a-zA-Z_$][a-zA-Z0-9_$]*\ze(/ contains=@props,javascriptProps transparent nextgroup=javascriptFuncCallArg

" runtime syntax/web.vim
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
runtime syntax/yajs/es6-reflect.vim
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
runtime syntax/yajs/web-broadcast.vim
runtime syntax/yajs/web-payment.vim
runtime syntax/yajs/web-encoding.vim
runtime syntax/yajs/dom-node.vim
runtime syntax/yajs/dom-elem.vim
runtime syntax/yajs/dom-form.vim
runtime syntax/yajs/dom-document.vim
runtime syntax/yajs/dom-event.vim
runtime syntax/yajs/dom-storage.vim
runtime syntax/yajs/css.vim

let javascript_props = 1

runtime syntax/yajs/event.vim
syntax region  javascriptEventString           contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ contains=javascriptASCII,@events


if &filetype =~ 'javascript'
  syntax region  javascriptBlock                 matchgroup=javascriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=TOP fold
else
  syntax region  javascriptBlock                 matchgroup=javascriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=@htmlJavaScript fold
endif

syntax match   javascriptObjectMethodName      contained /\k*\ze\_s*(/ nextgroup=javascriptFuncArg skipwhite skipempty
syntax cluster javascriptObjectMethod          contains=javascriptMethodAccessor,javascriptObjectMethodName

syntax match   javascriptMethodName            contained /\k\+/ nextgroup=javascriptFuncArg skipwhite skipempty
syntax region  javascriptMethodName            contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=javascriptFuncArg skipwhite skipempty extend
syntax match   javascriptMethodAccessor        contained /\(\(set\|get\)\>\|\*\)\ze\_s*\(\[\|\k\|["']\)/ contains=javascriptMethodAccessorWords nextgroup=javascriptMethodName skipwhite
syntax keyword javascriptMethodAccessorWords   contained get set
syntax region  javascriptMethodName            contained matchgroup=javascriptMethodName start=/\[/ end=/]/ contains=@javascriptValue nextgroup=javascriptFuncArg skipwhite skipempty

" syntax keyword javascriptFuncKeyword           function nextgroup=javascriptAsyncFunc,javascriptSyncFunc
syntax match   javascriptSyncFunc              contained /\s*/ nextgroup=javascriptFuncName,javascriptFuncArg
syntax match   javascriptAsyncFunc             contained /\s*\*\s*/ nextgroup=javascriptFuncName,javascriptFuncArg skipwhite skipempty
syntax match   javascriptFuncName              contained /[a-zA-Z_$]\k*/ nextgroup=javascriptFuncArg skipwhite
syntax region  javascriptFuncArgArray          contained matchgroup=javascriptBrackets start=/\[/ end=/]/ contains=@javascriptFuncArgElements transparent
syntax region  javascriptFuncArgObject         contained matchgroup=javascriptBraces start=/{/ end=/}/ contains=@javascriptFuncArgElements transparent
syntax cluster javascriptFuncArgElements       contains=javascriptFuncKeyword,javascriptComma,javascriptDefaultAssign,@javascriptComments,javascriptFuncArgArray,javascriptFuncArgObject,javascriptSpreadOp
syntax region  javascriptFuncArg               contained matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptFuncArgElements nextgroup=javascriptBlock skipwhite skipwhite skipempty

syntax match   javascriptComma                 contained /,/
syntax match   javascriptDefaultAssign         contained /=/ nextgroup=@javascriptExpression skipwhite skipempty

" Class
syntax keyword javascriptClassKeyword          class nextgroup=javascriptClassName,javascriptClassBlock,javascriptClassExtends skipwhite
syntax keyword javascriptClassSuper            super nextgroup=@javascriptAfterIdentifier skipwhite skipempty
syntax match   javascriptClassName             contained /\k\+/ nextgroup=javascriptClassBlock,javascriptClassExtends skipwhite
syntax match   javascriptClassSuperName        contained /[a-zA-Z_$][0-9a-zA-Z_$\[\]\.\(\)]*/ nextgroup=javascriptClassBlock skipwhite
syntax keyword javascriptClassExtends          contained extends nextgroup=javascriptClassSuperName,javascriptClassExtendsNew skipwhite
syntax keyword javascriptClassExtendsNew       contained new nextgroup=javascriptClassSuperName skipwhite
syntax region  javascriptClassBlock            contained matchgroup=javascriptBraces start=/{/ end=/}/ contains=javascriptMethodName,javascriptMethodAccessor,javascriptClassStatic,@javascriptComments fold
syntax keyword javascriptClassStatic           contained static nextgroup=javascriptMethodName,javascriptMethodAccessor skipwhite


syntax keyword javascriptForComprehension      contained for nextgroup=javascriptForComprehensionTail skipwhite skipempty
syntax region  javascriptForComprehensionTail  contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptOfComprehension,@javascriptExpression nextgroup=javascriptForComprehension,javascriptIfComprehension,@javascriptExpression skipwhite skipempty
syntax keyword javascriptOfComprehension       contained of
syntax keyword javascriptIfComprehension       contained if nextgroup=javascriptIfComprehensionTail
syntax region  javascriptIfComprehensionTail   contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptExpression nextgroup=javascriptForComprehension,javascriptIfComprehension skipwhite skipempty

syntax region  javascriptObjectLiteral         contained matchgroup=javascriptBraces start=/{/ end=/}/ contains=@javascriptComments,javascriptObjectLabel,javascriptComma,@javascriptObjectMethod,javascriptPropertyNameString,javascriptComputedPropertyName,@javascriptValue fold

" syntax match   javascriptBraces                /[\[\]]/
" syntax match   javascriptParens                /[()]/

syntax region  htmlScriptTag                   contained start=+<script+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syntax match   javascriptEndColons             /[;,]/

" From vim runtime
" <https://github.com/vim/vim/blob/master/runtime/syntax/javascript.vim#L48>
syntax region  javascriptRegexpString          start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gimuy]\{0,5\}\s*$+ end=+/[gimuy]\{0,5\}\s*[;.,)\]}]+me=e-1 oneline

syntax cluster javascriptEventTypes            contains=javascriptEventString,javascriptTemplate,javascriptTagRef,javascriptNumber,javascriptBoolean,javascriptNull
syntax cluster javascriptOps                   contains=javascriptOpSymbols,javascriptLogicSymbols,javascriptOperator
syntax cluster javascriptExpression            contains=javascriptArrowFuncDef,javascriptParenExp,@javascriptValue,javascriptObjectLiteral,javascriptFuncKeyword,javascriptYield,javascriptIdentifierName,javascriptRegexpString,@javascriptTypes,@javascriptOps,javascriptGlobal,jsxRegion,javascriptClassSuper
syntax cluster javascriptEventExpression       contains=javascriptArrowFuncDef,javascriptParenExp,@javascriptValue,javascriptObjectLiteral,javascriptFuncKeyword,javascriptIdentifierName,javascriptRegexpString,@javascriptEventTypes,@javascriptOps,javascriptGlobal,jsxRegion

syntax region  javascriptLoopParen             contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptVariable,javascriptForOperator,javascriptEndColons,@javascriptExpression nextgroup=javascriptBlock skipwhite skipempty

" syntax match   javascriptFuncCall              contained /[a-zA-Z]\k*\ze(/ nextgroup=javascriptFuncCallArg
syntax region  javascriptFuncCallArg           contained matchgroup=javascriptParens start=/(/ end=/)/ contains=javascriptComma,@javascriptExpression,@javascriptComments nextgroup=@javascriptAfterIdentifier skipwhite skipempty 
syntax region  javascriptEventFuncCallArg      contained matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptEventExpression,@javascriptComments

syntax match   javascriptArrowFuncDef          /(\_[^)]*)\_s*=>/ contains=javascriptArrowFuncArg,javascriptComma,javascriptArrowFunc nextgroup=javascriptOperator,javascriptIdentifierName,javascriptBlock,javascriptArrowFuncDef,javascriptParenObjectLiteral,javascriptClassSuper,javascriptClassKeyword,@afterArrowFunc skipwhite skipempty
syntax match   javascriptArrowFuncDef          /[a-zA-Z_$]\k*\_s*=>/ contains=javascriptArrowFuncArg,javascriptArrowFunc nextgroup=javascriptOperator,javascriptIdentifierName,javascriptBlock,javascriptArrowFuncDef,javascriptParenObjectLiteral,javascriptClassSuper,javascriptClassKeyword,@afterArrowFunc skipwhite skipempty
syntax match   javascriptArrowFunc             /=>/
syntax match   javascriptArrowFuncArg          contained /[a-zA-Z_$]\k*/
syntax region  javascriptArrowFuncArg          contained matchgroup=javascriptParens start=/(/ end=/)/ contains=@javascriptFuncArgElements nextgroup=javascriptArrowFunc skipwhite skipwhite skipempty
syntax keyword javascriptFuncKeyword           function nextgroup=javascriptAsyncFunc,javascriptSyncFunc

" Special object for arrow function direct return
syntax region  javascriptParenObjectLiteral    start=/(\_s*\ze{/ end=/)/ contains=javascriptObjectLiteral,@javascriptComments fold
" Special object for jsx return
syntax region  javascriptParenTagLiteral       containedin=@javascriptValue start=/(\ze\_s*</ end=/)/ contains=@javascriptExpression,@javascriptComments fold

" For ((foo) => {})
syntax region  javascriptParenExp              matchgroup=javascriptParens start=/(\ze\_s*(/ end=/)/ contains=@javascriptExpression nextgroup=@javascriptComments,javascriptOpSymbols skipwhite skipempty

" async await
syntax keyword javascriptAsyncFuncKeyword      async nextgroup=javascriptFuncKeyword,javascriptArrowFuncDef skipwhite
syntax keyword javascriptAwaitFuncKeyword      await nextgroup=@javascriptExpression skipwhite

syntax cluster javascriptExpression            add=javascriptAsyncFuncKeyword,javascriptAwaitFuncKeyword
syntax cluster afterArrowFunc                  add=javascriptAsyncFuncKeyword

if exists("did_javascript_hilink")
  HiLink javascriptReserved             Error
  HiLink javascriptReservedCase         Error
  HiLink javascriptInvalidOp            Error

  HiLink javascriptEndColons            Statement
  HiLink javascriptOpSymbol             Normal
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
  HiLink javascriptTemplateSB           javascriptTemplateSubstitution
  HiLink javascriptRegexpString         String
  HiLink javascriptGlobal               Constant
  HiLink javascriptCharacter            Character
  HiLink javascriptPrototype            Type
  HiLink javascriptConditional          Conditional
  HiLink javascriptConditionalElse      Conditional
  HiLink javascriptSwitch               Conditional
  HiLink javascriptCase                 Label
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
  HiLink javascriptTarget               Identifier
  " HiLink javascriptType                 Type
  HiLink javascriptNull                 Boolean
  HiLink javascriptNumber               Number
  HiLink javascriptBoolean              Boolean
  HiLink javascriptObjectLabel          javascriptLabel
  HiLink javascriptLabel                Label
  HiLink javascriptPropertyNameString   Label
  HiLink javascriptImport               Include
  HiLink javascriptExport               Include
  HiLink javascriptTry                  Statement
  HiLink javascriptExceptions           Statement

  HiLink javascriptMethodName           Function
  HiLink javascriptMethodAccessor       Operator
  HiLink javascriptObjectMethodName     javascriptLabel

  HiLink javascriptFuncKeyword          Keyword
  HiLink javascriptAsyncFunc            Keyword
  HiLink javascriptArrowFunc            Statement
  HiLink javascriptFuncName             Function
  HiLink javascriptFuncArg              Special
  HiLink javascriptArrowFuncArg         javascriptFuncArg
  HiLink javascriptTagRef               Function
  HiLink javascriptComma                Normal

  HiLink javascriptClassKeyword         Keyword
  HiLink javascriptClassExtends         Keyword
  HiLink javascriptClassExtendsNew      Operator
  HiLink javascriptClassName            Function
  HiLink javascriptClassSuperName       Function
  HiLink javascriptClassStatic          Keyword
  HiLink javascriptMethodAccessorWords  Keyword
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

