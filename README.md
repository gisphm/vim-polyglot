# vim-polyglot [![Build Status](https://travis-ci.org/gisphm/vim-polyglot.svg)](https://travis-ci.org/gisphm/vim-polyglot)

A collection of language packs for Vim.

> One to rule them all, one to find them, one to bring them all and in the darkness bind them.

- It **won't affect your startup time**, as scripts are loaded only on demand\*.
- It **installs 50+ times faster** than 50+ packages it consist of.
- Solid syntax and indentation support. Only the best language packs.
- All unnecessary files are ignored (like enormous documentation from php support).
- No support for esoteric languages, only most popular ones (modern too, like `slim`).
- Each build is tested by automated vimrunner script on CI. See `spec` directory.

\*To be completely honest, concatenated `ftdetect` script takes around `3ms` to load.

## Installation

1. Install Pathogen, Vundle, NeoBundle, or Plug package manager for Vim.
2. Use this repository as submodule or package.

## Language packs

- [arduino](https://github.com/sudar/vim-arduino-syntax) (syntax, indent, ftdetect)
- [asciidoc](https://github.com/asciidoc/vim-asciidoc) (syntax, ftdetect)
- [blade](https://github.com/jwalton512/vim-blade) (syntax, indent, ftdetect)
- [c++11](https://github.com/octol/vim-cpp-enhanced-highlight) (syntax)
- [cjsx](https://github.com/mtscout6/vim-cjsx) (ftdetect, syntax, ftplugin)
- [clojure](https://github.com/guns/vim-clojure-static) (syntax, indent, autoload, ftplugin, ftdetect, doc)
- [coffee-script](https://github.com/kchmck/vim-coffee-script) (syntax, indent, compiler, autoload, ftplugin, ftdetect, doc)
- [colors](https://github.com/flazz/vim-colorschemes) (colors)
- [css](https://github.com/JulesWang/css.vim) (syntax)
- [css-color](https://github.com/ap/vim-css-color) (autoload, syntax)
- [css3](https://github.com/hail2u/vim-css3-syntax) (syntax)
- [csscomplete](https://github.com/othree/csscomplete.vim) (data, autoload)
- [csv](https://github.com/chrisbra/csv.vim) (syntax, ftplugin, ftdetect, doc)
- [cucumber](https://github.com/tpope/vim-cucumber) (syntax, indent, compiler, ftplugin, ftdetect)
- [dockerfile](https://github.com/honza/dockerfile.vim) (syntax, ftdetect, doc)
- [elixir](https://github.com/elixir-lang/vim-elixir) (syntax, indent, compiler, ftplugin, ftdetect)
- [emberscript](https://github.com/heartsentwined/vim-ember-script) (syntax, indent, ftplugin, ftdetect)
- [emblem](https://github.com/heartsentwined/vim-emblem) (syntax, indent, ftplugin, ftdetect)
- [erlang](https://github.com/vim-erlang/vim-erlang-runtime) (syntax, indent, ftdetect)
- [es7](https://github.com/othree/es.next.syntax.vim) (syntax)
- [git](https://github.com/tpope/vim-git) (syntax, indent, ftplugin, ftdetect, doc)
- [gitignore](https://github.com/gisphm/vim-gitignore) (syntax, indent, ftplugin, ftdetect, neosnippets)
- [glsl](https://github.com/tikhomirov/vim-glsl) (syntax, indent, ftdetect)
- [go](https://github.com/fatih/vim-go) (syntax, indent, compiler, autoload, ftplugin, ftdetect, doc)
- [gradle](https://github.com/gisphm/vim-gradle) (syntax, compiler, ftplugin, ftdetect)
- [groovy](https://github.com/vim-scripts/groovy.vim) (syntax)
- [haml](https://github.com/tpope/vim-haml) (syntax, indent, compiler, ftplugin, ftdetect)
- [handlebars](https://github.com/mustache/vim-mustache-handlebars) (syntax, indent, ftplugin, ftdetect)
- [haskell](https://github.com/neovimhaskell/haskell-vim) (syntax, indent, ftplugin, ftdetect)
- [haxe](https://github.com/yaymukund/vim-haxe) (syntax, ftdetect)
- [html5](https://github.com/othree/html5.vim) (syntax, indent, autoload, ftplugin)
- [jade](https://github.com/digitaltoad/vim-jade) (syntax, indent, ftplugin, ftdetect)
- [jasmine](https://github.com/glanotte/vim-jasmine) (syntax, ftdetect)
- [javascript](https://github.com/pangloss/vim-javascript) (syntax, indent, ftplugin, ftdetect)
- [javascript-library](https://github.com/othree/javascript-libraries-syntax.vim) (autoload, syntax)
- [jinja](https://github.com/Glench/Vim-Jinja2-Syntax) (syntax, indent, ftdetect)
- [jsdoc](https://github.com/heavenshell/vim-jsdoc) (autoload, ftplugin, doc)
- [json](https://github.com/elzr/vim-json) (syntax, indent, ftplugin, ftdetect)
- [jspc](https://github.com/othree/jspc.vim) (data, autoload, ftplugin)
- [jst](https://github.com/briancollins/vim-jst) (syntax, indent, ftdetect)
- [jsx](https://github.com/mxw/vim-jsx) (ftdetect, after)
- [julia](https://github.com/dcjones/julia-minimalist-vim) (syntax, indent, ftdetect)
- [kotlin](https://github.com/udalov/kotlin-vim) (syntax, indent, ftdetect)
- [latex](https://github.com/LaTeX-Box-Team/LaTeX-Box) (syntax, indent, ftplugin, doc)
- [less](https://github.com/groenewege/vim-less) (syntax, indent, ftplugin, ftdetect)
- [lua](https://github.com/tbastos/vim-lua) (syntax, indent)
- [markdown](https://github.com/plasticboy/vim-markdown) (syntax, indent, ftplugin, ftdetect, doc)
- [nginx](https://github.com/moskytw/nginx-contrib-vim) (syntax, indent, ftdetect)
- [node](https://github.com/moll/vim-node) (autoload, ftdetect)
- [objc](https://github.com/b4winckler/vim-objc) (ftplugin, syntax, indent)
- [ocaml](https://github.com/jrk/vim-ocaml) (syntax, indent, ftplugin)
- [opencl](https://github.com/petRUShka/vim-opencl) (syntax, indent, ftplugin, ftdetect, syntax_checkers)
- [perl](https://github.com/vim-perl/vim-perl) (syntax, indent, ftplugin, ftdetect)
- [php](https://github.com/StanAngeloff/php.vim) (syntax)
- [powershell](https://github.com/Persistent13/vim-ps1) (syntax, indent, ftplugin, ftdetect, doc)
- [protobuf](https://github.com/uarun/vim-protobuf) (syntax, ftdetect)
- [puppet](https://github.com/rodjek/vim-puppet) (syntax, indent, ftplugin, ftdetect)
- [python](https://github.com/mitsuhiko/vim-python-combined) (indent)
- [python-syntax](https://github.com/me-vlad/python-syntax.vim) (syntax)
- [qml](https://github.com/peterhoeg/vim-qml) (syntax, indent, ftplugin, ftdetect)
- [ragel](https://github.com/jneen/ragel.vim) (syntax)
- [r-lang](https://github.com/jcfaria/Vim-R-plugin) (syntax, autoload, ftplugin, ftdetect, doc)
- [rspec](https://github.com/keith/rspec.vim) (syntax, ftdetect)
- [ruby](https://github.com/vim-ruby/vim-ruby) (syntax, indent, compiler, autoload, ftplugin, ftdetect, doc)
- [ruby-minitest](https://github.com/sunaku/vim-ruby-minitest) (doc, syntax)
- [rust](https://github.com/rust-lang/rust.vim) (syntax, indent, compiler, autoload, ftplugin, ftdetect, doc, syntax_checkers)
- [sbt](https://github.com/derekwyatt/vim-sbt) (syntax, ftdetect)
- [scala](https://github.com/derekwyatt/vim-scala) (syntax, indent, compiler, ftplugin, ftdetect, doc)
- [scss](https://github.com/cakebaker/scss-syntax.vim) (syntax, autoload, ftplugin, ftdetect)
- [slim](https://github.com/slim-template/vim-slim) (syntax, indent, ftdetect)
- [snippets](https://github.com/gisphm/vim-snippets-neosnippet) (neosnippets)
- [solidity](https://github.com/ethereum/vim-solidity) (syntax, indent, ftdetect)
- [sql](https://github.com/gisphm/dbext.vim) (autoload, doc)
- [stylus](https://github.com/wavded/vim-stylus) (syntax, indent, ftplugin, ftdetect)
- [swift](https://github.com/keith/swift.vim) (syntax, indent, ftplugin, ftdetect)
- [systemd](https://github.com/kurayama/systemd-vim-syntax) (syntax, ftdetect)
- [textile](https://github.com/timcharper/textile.vim) (syntax, ftplugin, ftdetect, doc)
- [thrift](https://github.com/solarnz/thrift.vim) (syntax, ftdetect)
- [tmux](https://github.com/tejr/vim-tmux) (syntax, ftdetect)
- [tomdoc](https://github.com/wellbredgrapefruit/tomdoc.vim) (syntax)
- [toml](https://github.com/cespare/vim-toml) (syntax, ftplugin, ftdetect)
- [twig](https://github.com/qbbr/vim-twig) (syntax, ftplugin)
- [typescript](https://github.com/leafgarland/typescript-vim) (syntax, indent, compiler, ftplugin, ftdetect)
- [vala](https://github.com/tkztmk/vim-vala) (syntax, indent, ftdetect)
- [vm](https://github.com/lepture/vim-velocity) (syntax, indent, ftdetect)
- [xml](https://github.com/sukima/xmledit) (ftplugin, doc)
- [yard](https://github.com/noprompt/vim-yardoc) (syntax)
- [yajs](https://github.com/othree/yajs.vim) (data, syntax)
- [zsh](https://github.com/chrisbra/vim-zsh) (syntax, indent, ftplugin)

## Updating

You can either wait for new patch release with updates or run the `./build` script by yourself.

## Contributing

Language packs are periodically updated using automated `build` script.

Feel free to add your language, and send pull-request.

## License

See linked repositories for detailed license information.
