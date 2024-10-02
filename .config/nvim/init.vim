"color
colorscheme slate

"numbered lines
set number

"Ctrl+b for Vertical Explorer
map <A-m> :Lexplore<CR>
map <C-t> :tabnew<CR>
map <C-Right> :tabn<CR>
map <C-Left> :tabp<CR>
"shift+t to open terminal
map <C-s> :w<CR>
map <C-x> :tabc<CR>

call plug#begin()
" List your plugins here
Plug 'prabirshrestha/vim-lsp'
call plug#end()
