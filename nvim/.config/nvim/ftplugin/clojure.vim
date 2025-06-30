" Extra syntax highlighting
let g:clojure_syntax_keywords = {
    \ 'clojureMacro': ["defproject", "defstate"],
    \ }

" Standard indentation
let g:clojure_align_subforms=1
let g:clojure_fuzzy_indent=1

" Special indentation forms
let defaults = ['^with', '^def', '^let']
let language_features = ['cond', 'comment', '^do$', '^try', '^finally', 'delay']
let spec = ['^fdef']
let core_async = ['^go']
let core_match = ['match']
let cljs_test = ['use-fixtures']
let re_frame = ['^fn-traced']
let g:clojure_fuzzy_indent_patterns=
      \ defaults + language_features +
      \ spec + core_async + core_match + cljs_test + re_frame

" default ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_fuzzy_indent_blacklist = []


" work
let g:conjure#client#clojure#nrepl#test#runner = 'kaocha'

" conjure is way better at this than lsp
" but not in cljc!
" let g:conjure#mapping#def_word = ['gd']
