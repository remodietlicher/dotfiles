" Vim syntax file for Bruno (.bru) API request files.
"
" The format is a flat list of named blocks:
"
"   meta { name: foo }          key: value pairs
"   post { url: ... }           key: value pairs
"   body:json { {...} }         embedded JSON
"   script:pre-request { ... }  embedded JavaScript
"   vars:secret [ cookie ]      bare list
"
" Highlights block names, keys, {{template}} vars and Bruno's `~` disabled-line
" prefix, and hands JSON/JS bodies to the runtime syntax files for those.

if exists("b:current_syntax")
  finish
endif

syn case match

" Embedded languages. Each `syn include` sets b:current_syntax, which would
" abort this file on the next include and mislabel the buffer, so clear it.
syn include @bruJson syntax/json.vim
unlet! b:current_syntax
syn include @bruJavascript syntax/javascript.vim
unlet! b:current_syntax

syn match bruComment "^\s*#.*$" contains=@Spell

" `{{baseUrl}}` interpolation, valid anywhere including inside bodies.
syn match bruTemplate "{{[^}]*}}" containedin=ALLBUT,bruComment

" NOTE: when two regions can start at the same position the one defined LAST
" wins, so the catch-all block has to come before the specialised ones below.
"
" Catch-all: key: value pairs. Bruno disables a line by prefixing `~`.
" Bodies are indented, so only a `}` in column 0 closes a block.
syn region bruBlock matchgroup=bruBlockName
      \ start="^\s*[a-z][a-zA-Z0-9:_-]*\s*{"
      \ end="^}"
      \ keepend contains=bruKey,bruDisabled,bruComment,bruTemplate
syn match bruKey "^\s*\zs[A-Za-z_][A-Za-z0-9._:/-]*\ze\s*:" contained
syn match bruDisabled "^\s*\zs\~[A-Za-z_][A-Za-z0-9._:/-]*\ze\s*:" contained

syn region bruJsonBlock matchgroup=bruBlockName
      \ start="^\s*\%(body:json\|body:graphql:vars\)\s*{"
      \ end="^}"
      \ keepend contains=@bruJson,bruTemplate

syn region bruScriptBlock matchgroup=bruBlockName
      \ start="^\s*\%(script:pre-request\|script:post-response\|tests\)\s*{"
      \ end="^}"
      \ keepend contains=@bruJavascript,bruTemplate

" Free-form prose and non-JSON bodies: no key: value parsing, just templates.
syn region bruTextBlock matchgroup=bruBlockName
      \ start="^\s*\%(docs\|body:text\|body:xml\|body:sparql\|body:graphql\)\s*{"
      \ end="^}"
      \ keepend contains=bruTemplate

" `vars:secret [ ... ]` and friends: one bare name per line.
syn region bruListBlock matchgroup=bruBlockName
      \ start="^\s*[a-z][a-zA-Z0-9:_-]*\s*\["
      \ end="^\]"
      \ keepend contains=bruListItem,bruComment
syn match bruListItem "^\s\+\~\?[^\[\]#]\+$" contained contains=bruTemplate

hi def link bruComment   Comment
hi def link bruBlockName Statement
hi def link bruKey       Identifier
hi def link bruDisabled  Comment
hi def link bruListItem  Identifier
hi def link bruTemplate  Special

let b:current_syntax = "bru"
