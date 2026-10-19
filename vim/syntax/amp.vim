" File: amp.vim
" Author: Oliver Grimm
" Email: ogr@fastmail.fm
" Codeberg: https://codeberg.org/ogr
" Created: 2025-05-21
" Last Modified: 2026-01-02
" Description: Vim syntax file for VASP and AMP scripts. Mainly to distinguish Comments.
" License: MIT

" Quit if a syntax file is already loaded
if exists("b:current_syntax")
  finish
end

" define comments starting with * at the beginning of the line
syntax match Comment /^\*.*/

" define comments starting with " anywhere in the line to the end
syntax match Comment /".*/

" Define multi-line comment starting after END until the end of the file
syntax match ampEndCommentStart /\zsEND/ nextgroup=ampEndComment
syntax region ampEndComment start=/END\s*\n/ end=/\%$/ contains=ampEndCommentStart

" Define multi-line comment between SKIP and CONTINUE
syntax region ampSkipComment start=/SKIP\s*\n/ end=/CONTINUE/ keepend

" Keywords
syntax keyword ampKeyword SYS PAR PARLIST SER INLIST SEQPROC POSTPROC VASP A B C D

" structures ($)
syntax match myDollar "\$"

" Link
highlight link ampEndComment Comment
highlight link ampSkipComment Comment
highlight link ampKeyword Keyword
highlight myDollar ctermfg=Green guifg=Green

