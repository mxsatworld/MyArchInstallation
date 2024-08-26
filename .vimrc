"color
colorscheme slate

"numbered lines
set number

"Ctrl+b for Vertical Explorer
map <C-b> :Lexplore<CR>
map <C-t> :tabnew<CR>
map <C-Right> :tabn<CR>
map <C-Left> :tabp<CR>
"shift+t to open terminal
map <S-t> :terminal<CR>
map <C-s> :w<CR>
map <C-w> :tabc<CR>

call plug#begin()
" List your plugins here
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
call plug#end()
