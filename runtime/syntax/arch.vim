" Vim syntax file
" Language:         GNU Arch inventory file
" Maintainer:       Nikolai Weibull <nikolai+work.vim@bitwi.se>
" Latest Revision:  2005-07-04

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

setlocal iskeyword=@,48-57,_,-

syn keyword archTodo    TODO FIXME XXX NOTE

syn region  archComment display start='^\%(#\|\s\)' end='$'
                        \ contains=archTodo,@Spell

syn match   argBegin    display '^' nextgroup=archKeyword,archComment

syn keyword archKeyword contained implicit tagline explicit names
syn keyword archKeyword contained untagged-source
                        \ nextgroup=archTMethod skipwhite
syn keyword archKeyword contained exclude junk backup precious unrecognized
                        \ source nextgroup=archRegex skipwhite

syn keyword archTMethod contained source precious backup junk unrecognized

syn match   archRegex   contained '\s*\zs.*'

hi def link archTodo    Todo
hi def link archComment Comment
hi def link archKeyword Keyword
hi def link archTMethod Type
hi def link archRegex   String

let b:current_syntax = "arch"

let &cpo = s:cpo_save
unlet s:cpo_save
