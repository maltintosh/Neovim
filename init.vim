scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題解決
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示
set cursorline " カーソルラインをハイライト
set virtualedit=onemore "行末に移動できるようにする
set list lcs=tab:\¦- "tab可視化"プラグインはスペース用
set clipboard=unnamed  "yank した文字列をクリップボードにコピー

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"キーマッピング
".zshrc
"start insert mode
"alias vi ="vim -c 'startinsert'"
"
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

"esc変更
inoremap <silent> jj <C-o>:call Return()<cr>
function! Return()
	if col(".")==1
		silent call feedkeys("\<ESC>","n")
	else
		silent call feedkeys("\<ESC>l","n")
	endif
endfunction

"leaderマッピング変更
let mapleader = "\<Space>"

"cat >> ~/.bashrc or .zshrc
"bind -r '\C-s' or bindkey -r '\C-s'
"stty -ixon
nnoremap <C-s> :w<CR>
nnoremap <Leader>s :w<CR>
inoremap <silent> <C-s> <C-o>:w<CR>

nnoremap <Leader>q :q<CR>

vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap <Leader>i I
nmap <Leader>v V

inoremap <S-C-z> <C-r>i

inoremap <C-d> <Del>
cnoremap <C-a> <Home>
inoremap <C-a> <Home>
" " 行末へ移動
cnoremap <C-e> <End>
inoremap <C-e> <End>

inoremap <silent> <C-c> <C-o>:call setreg("",getline("."))<CR><C-o>:call setreg("*",getline("."))<CR>
vnoremap <C-c> yi

inoremap <C-v> <C-o>P

inoremap <C-x> <C-o>:call setreg("",getline("."))<CR><C-o>:call setreg("*",getline("."))<CR><C-o>"_dd
vnoremap <C-x> xi
inoremap <S-Tab> <C-d>
vnoremap <S-Tab> <S-<>
vnoremap <Tab> <S->>

" commentary.vim
vmap <C-_> gci
imap <C-_> <ESC>vgci

inoremap <C-u> <ESC>ld0i

imap <C-k> jj<ESC>:call Killend()<cr>
function! Killend()
if col(".")==1
		silent call feedkeys("\<S-d>i", "n")
	else
		silent call feedkeys("l\<S-d>i","n")
	endif
endfunction

" Exコマンドを実装する関数を定義
function! ExecExCommand(cmd)
	silent exec a:cmd
	return ''
endfunction

inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal j')<CR>"

inoremap <silent> <expr> <C-b> "<C-r>=ExecExCommand('normal h')<CR>"
inoremap <silent> <expr> <C-f> "<C-r>=ExecExCommand('normal l')<CR>"


""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch " 括弧の対応関係を一瞬表示する
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

"マウス
if has('mouse')
	set mouse=a
endif

"ペースト設定
if &term =~ "xterm"
	let &t_SI .= "\e[?2004h"
	let &t_EI .= "\e[?2004l"
	let &pastetoggle = "\e[201~"

	function XTermPasteBegin(ret)
		set paste
		return a:ret
	endfunction

	inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

"========================================="
" plugin Manager: dein.vim setting
"========================================="
if &compatible
	set nocompatible
endif

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
	endif
	execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)

	" プラグインリストを収めた TOML ファイル
	" 予め TOML ファイル（後述）を用意しておく
	let g:rc_dir    = expand('~/.config/nvim/rc')
	let s:toml      = g:rc_dir . '/dein.toml'
	let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

	" TOML を読み込み、キャッシュしておく
	call dein#load_toml(s:toml,      {'lazy': 0})
	call dein#load_toml(s:lazy_toml, {'lazy': 1})
	call dein#end()
	call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
	call dein#install()
endif

let g:dein#install_max_processes = 16

"========================================="
" setting
"========================================="
filetype plugin indent on

syntax enable
colorscheme one
let g:airline_theme = 'one'
" powerline enable(最初に設定しないとダメ)
let g:airline_powerline_fonts = 1
" タブバーをかっこよく
let g:airline#extensions#tabline#enabled = 1
" 選択行列の表示をカスタム(デフォルトだと長くて横幅を圧迫するので最小限に)
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
" gitのHEADから変更した行の+-を非表示(vim-gitgutterの拡張)
let g:airline#extensions#hunks#enabled = 0

lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = {enable = true,disable = {'lua','ruby','toml','c_sharp','vue',}}
}
EOF

