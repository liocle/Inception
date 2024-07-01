" Inspiration from: https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/
" to make change take effect: :source ~/.vimrc
syntax on
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set number
set numberwidth=5
set tabstop=4
set expandtab " use spaces instead of tabs
set shiftwidth=4 " number of spaces for autoindent
set softtabstop=4 " make <Tab> key insert  spaces
set autoindent
set smartindent
set smarttab
"set cursorline
"set cursorcolumn
set scrolloff=0 " Was 10, but can be large number to help to keep cursor in middle of page when at beginning or end of file
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=1000
set wildmenu "enable auto completion menu after pressing TAB
set wildmode=list:longest "Make wildmenu behave like similar to bash completion
set wildignore=*.o,*.swp
set splitright
set splitbelow

" to format text to 100th column, select line, paragraph e.g. < Shift + V> or
" <Shift + V> } and press: gq
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%101v.\+/

" MAP LEADER and other
" shortcuts --------------------------------------------------  
let mapleader=" " 
" remove highlighting 
nmap <leader>n :noh<cr>
" Save all files mapped to leader+s and Ctrl+s
nmap <leader>s :wa<cr>
nmap <C-s> :wa<cr>
" leader f to select all page and format
nnoremap <leader>f mzggVG=`z
" Ctrl direction to change pane
nnoremap <C-h> <C-w>h
nnoremap <C-r> <C-w>r
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Yank to clipboard
vnoremap <Leader>y :w !xclip -selection clipboard<CR><CR>
" Paste from clipboard
nnoremap <Leader>p :r !xclip -selection clipboard -o<CR>
" Map <Leader>a to select all, copy to clipboard, and return to original position
nnoremap <Leader>a mzggVGy`z :w !xclip -selection clipboard<CR><CR>
" Map <C-a> to select all, copy to clipboard, and return to original position
nnoremap <C-a> mzggVGy`z :w !xclip -selection clipboard<CR><CR>
" Remap delete commands to save deleted text in register 'd'
nnoremap d "dd
nnoremap dd "ddd
vnoremap d "dd
" Remap change commands to save changed text in register 'd'
nnoremap c "dc
vnoremap c "dc
" Map <Leader>p to paste from register 'd'
nnoremap <Leader>d "dp
vnoremap <Leader>d "dp
" Map <Leader>D to paste from register 'd' before the cursor/selection
nnoremap <Leader>D "dP
vnoremap <Leader>D "dP

set mouse=a

"Turn on backup option
set backup

"Where to store backups
set backupdir=~/.vim/backup//

"Make backup before overwriting the current buffer
set writebackup

"Overwrite the original backup file
set backupcopy=yes

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

runtime! ftplugin/man.vim

" STATUS LINE ------------------------------------------------------------
" Function to update the status line time
function! UpdateStatuslineTime(timer_id)
    let &statusline = substitute(&statusline, '\[[^\]]*\]', '[' . strftime('%H:%M:%S') . ']', '')
endfunction

" Update the time every second
call timer_start(1000, 'UpdateStatuslineTime', {'repeat': -1})

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F%m%r%h%w

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side with time.
set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%%\ [%{strftime('%H:%M:%S')}]

" Show the status on the second to last line.
set laststatus=2

set cursorcolumn



" Abbreviations -------------------------------------------------------------------------------- 
" Abbreviation for C++ class in .cpp file
iabbrev cppclass #include "<cfile>.hpp"<CR><CR>class <args> {<CR>public:<CR><Tab>

" Abbreviation for C++ class in .hpp file
iabbrev hppclass #pragma once<CR><CR>class <args> {<CR>public:<CR><Tab>};

" }}}


" COLORSCHEME -------------------------------------------------------------------------------- 
let colorschemes = ['habamax', 'slate']

function! RandomColorscheme()
    let index = rand() % len(g:colorschemes)
    let chosen_colorscheme = g:colorschemes[index]
    try
        execute 'colorscheme ' . chosen_colorscheme
    catch
        echom 'Colorscheme ' . chosen_colorscheme . ' not found'
    endtry
endfunction

if exists('*srand')
    call srand(localtime())
else
    let s:seed = localtime()
    let s:seed = (s:seed * 1103515245 + 12345) % (2**31)
endif

call RandomColorscheme()
" Function to set the tab name
function! SetTabName(name)
  let t:tabname = a:name
endfunction

" TABRENAMER -------------------------------------------------- 
" Cheat Sheet for Using Tabs in Vim

" Create a new tab
    " :tabnew [filename]        " Open a new tab (with optional filename)
    " 
" Navigate between tabs
    " :tabnext or :tabn         " Move to the next tab
    " :tabprevious or :tabp     " Move to the previous tab
    " :tabfirst                 " Move to the first tab
    " :tablast                  " Move to the last tab
    " {n}gt                     " Go to the nth tab (e.g., 2gt for the 2nd tab)
    " 
" Close tabs
    " :tabclose                 " Close the current tab
    " :tabonly                  " Close all tabs except the current one
    " 

" This command will set the name of the current tab to "MyTabName".
    " :Tabname MyTabName

" Function to get the tab name and modify tabline
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " Get tab number and name
    let tabnr = i + 1
    let tabname = gettabvar(tabnr, 'tabname', 'Tab ' . tabnr)

    " Highlight the current tab
    if tabnr == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " Set the tab label
    let s .= '%' . tabnr . 'T ' . tabname . ' '
  endfor
  let s .= '%#TabLineFill#%T'
  return s
endfunction

" Set the tabline to use the custom function
set tabline=%!MyTabLine()

" Command to name the current tab
command! -nargs=1 Tabname call SetTabName(<f-args>)


