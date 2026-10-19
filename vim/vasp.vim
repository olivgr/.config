let g:basedir = expand('~/.wine/drive_c/VASP')

" Sets filetype of files in basedir to 'amp' for syntax highlighting
augroup amp_syntax
	autocmd!
	autocmd BufRead,BufNewFile *
		\ if expand('%:p') =~# '^' . escape(g:basedir, '\') . '/' 
		\ | setfiletype amp | endif
augroup END

function! RunEXE(type)
	update
	execute 'cd ' . g:basedir
	call system('wineserver -p')
	call system('WINEDEBUG=-all wine ' . a:type . ' ' . expand('%'))
	!redraw
endfunction

nnoremap <leader>v :call RunEXE('vasp64.exe')<cr>jk
nnoremap <leader>a :call RunEXE('amp64.exe')<cr>jk
nnoremap <leader>u :call RunEXE('uc64.exe')<cr>jk
