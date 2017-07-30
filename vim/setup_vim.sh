#!/bin/bash

set -e

vim_root=~/.vim
vimrc=$vim_root/vimrc
vim_bundle=$vim_root/bundle
vim_autoload=$vim_root/autoload
vim_autoload_pathogen_vim=$vim_autoload/pathogen.vim
vimrc_github_address="https://raw.githubusercontent.com/TsvetanMilanov/environment-setup/master/vim/vimrc"
base_dir=$(dirname "$0")
setup_common=$base_dir/../common/setup_common.sh
setup_go=$base_dir/../go/setup_go.sh

# Common setup
$setup_common

# Functions
function ensure_dir {
	if ! test -d $1; then
		mkdir -p $1
	fi
}

function ensure_git_plugin {
	plugin_name=`echo $1 | sed 's-.*/--' | sed 's-\.git--'`
	if ! test -d $vim_bundle/$plugin_name; then
		echo installing plugin $1
		$(cd $vim_bundle && git clone https://github.com/$1.git)
	else
		echo plugin $1 already installed
	fi
}

function write_vimrc {
	# Download vimrc from GitHub
	echo Dowloading vimrc from GitHub
	curl -H 'Cache-Control: no-cache' $vimrc_github_address -o $vimrc
	echo vimrc created
}

# Setup Pathogen for plugins installation
echo Setup Pathogen
ensure_dir $vim_autoload
ensure_dir $vim_bundle
ls -la $vim_autoload_pathogen_vim &>/dev/null && echo Pathogen already installed ||\
	curl -LSso $vim_autoload_pathogen_vim https://tpo.pe/pathogen.vim
echo Pathogen setup complete

# Install plugins
echo Install plugins
ensure_git_plugin jiangmiao/auto-pairs
ensure_git_plugin scrooloose/nerdtree
ensure_git_plugin ervandew/supertab
ensure_git_plugin scrooloose/syntastic
ensure_git_plugin kien/ctrlp.vim
ack --help &>/dev/null &&\
	echo ack-grep already installed ||\
	(echo Installing ack-grep. This will require sudo. &&\
	sudo apt-get install ack-grep)
ensure_git_plugin mileszs/ack.vim
ensure_git_plugin leafgarland/typescript-vim
ensure_git_plugin modille/groovy.vim
ensure_git_plugin vim-scripts/groovyindent
ensure_git_plugin martinda/Jenkinsfile-vim-syntax
ensure_git_plugin fatih/vim-go
ensure_git_plugin Valloric/YouCompleteMe
echo All plugins installed

echo !!! IMPORTANT !!!
echo open $vim_bundle/supertab/plugin/supertab.vim and execute :source %

# Setup vim to use Pathogen
echo Setup vim to use Pathogen

if test -f $vimrc; then
	read -p "Warning vimrc already exists. Do you want to override it with the default settings? [y/N]" answer
	case $answer in
		[Yy]* ) echo "Creating backup of original vimrc"
			cp -f $vimrc $vimrc.BAK
			write_vimrc;;
		[Nn]* ) echo "Using current vimrc";;
		* ) echo "Using current vimrc";;
	esac
else
	echo Creating vimrc
	write_vimrc
fi

# Setup Go
$setup_go

# Build YoCompleteMe
echo Building YoCompleteMe
$(cd $vim_bundle/YouCompleteMe && \
	git submodule update --init --recursive && \
	./install.py --gocode-completer --tern-completer --clang-completer || exit 1)

