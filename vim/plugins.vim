call plug#begin()
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'https://codeberg.org/ziglang/zig.vim'
call plug#end()

let g:fzf_vim = {}
"let g:fzf_vim.preview_window = []
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }

nnoremap <leader>f :Files<cr>
nnoremap <leader>o :History<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>s :Rg <C-r><C-w><cr>
nnoremap <leader>g :Rg<space>
