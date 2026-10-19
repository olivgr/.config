if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetAmpIndent()
setlocal indentkeys=o,O,*<Return>,},0{,0}

function! GetAmpIndent() abort
  let lnum = v:lnum
  let prev = prevnonblank(lnum - 1)

  if prev == 0
    return 0
  endif

  let indent = indent(prev)

  " Indent after {
  if getline(prev) =~ '{\s*$'
    let indent += shiftwidth()
  endif

  " Outdent before }
  if getline(lnum) =~ '^\s*}'
    let indent -= shiftwidth()
  endif

  return max([indent, 0])
endfunction
