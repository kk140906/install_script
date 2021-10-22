#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-13 09:06:58
 # @LastEditTime : 2021-10-21 17:13:33
 # @LastEditors  : KK
 # @Description  : Write vim configure to .vimrc
 # @FilePath     : \debian_install_script\vim_vimrc.sh
### 


set -e
set -o pipefail
SCRIPT_PATH=$(dirname $0)
if [[ ${SCRIPT_PATH} == "." ]]
then 
    SCRIPT_PATH=$(pwd)
fi

source ${SCRIPT_PATH}/common.sh

cd ~

backup_exist ~/.vimrc

# write .vimrc config file
cat > ~/.vimrc <<- EOF

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('${VIM_PLUGIN_AUTO_PATH}')

" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" Custom plugins
" Algin text
Plug 'junegunn/vim-easy-align' 
" Custom snippets
Plug 'honza/vim-snippets'
" Windows and IDE
"Plug 'preservim/nerdtree'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/winmanager'
" Theme
Plug 'dracula/vim',{'name':'dracula'}
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
" Auto completion
Plug 'jiangmiao/auto-pairs'
" Color bracket
Plug 'luochen1990/rainbow'
Plug 'universal-ctags/ctags'
" Syntax highlight
Plug 'sheerun/vim-polyglot'
" Switch .c .h
Plug 'vim-scripts/a.vim'
" Doxygen comment
Plug 'babaybus/DoxygenToolkit.vim'
" Surround edit
Plug 'tpope/vim-surround'
" Comment
Plug 'preservim/nerdcommenter'
" Find file
Plug 'vim-scripts/genutils'
Plug 'vim-scripts/lookupfile'
" Multiple cursor
Plug 'terryma/vim-multiple-cursors'
" Wiki
Plug 'vimwiki/vimwiki'
" Auto format
Plug 'vim-autoformat/vim-autoformat'

" Manual manage plugins
Plug '${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe'

" Initialize plugin system
call plug#end()

" youcompleteme plugin install from repository, it will load plugin automatically
" let g:ycm_global_ycm_extra_conf = "${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/ycm_extra_conf.py"

EOF


printf_color "Execute cmd ':PlugInstall' in vim to install plugins." ${TEXT_GREEN}
wait