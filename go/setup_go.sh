#!/bin/bash

go_package=golang-1.8-go
go_deps=('golang.org/x/tools/cmd/goimports' \
	'github.com/nsf/gocode' \
	'github.com/rogpeppe/godef' \
	'github.com/golang/lint/golint' \
	'github.com/kisielk/errcheck' \
	'golang.org/x/tools/cmd/oracle')
go_comment_start="# Go variables start"
go_comment_end="# Go variables end"
go_rc_content="$go_comment_start\nexport GOROOT=/usr/lib/go-1.8\nexport GOPATH=~/go\n$go_comment_end"
bashrc=~/.bashrc

function clean_bashrc {
	result=""
	skip_line="false"
	while IFS='' read -r l || [[ -n "$l"  ]]; do
		if [ "$l" == "$go_comment_start" ]; then
			skip_line=true
			continue
		elif [ "$l" == "$go_comment_end" ]; then
			skip_line=false
			continue
		fi
		
		if [ "$skip_line" == "false" ]; then
			result+="$l\n"
		fi
	done < "$bashrc"
	echo -e $result > $bashrc
}

function install_go {
	echo Setting up Go
	sudo apt-get install $go_package || \
		(sudo add-apt-repository ppa:longsleep/golang-backports && \
		sudo apt-get update && \
		sudo apt-get install golang-go)
	cp -f $bashrc $bashrc.env-setup.BAK
	clean_bashrc
	echo -e $go_rc_content >> $bashrc
	echo !!! IMPORTANT !!! execute source $bashrc to be able to use Go
}

function get_executable_name {
	echo $1 | sed 's-.*/--'	
}

# Install Go
go help &>/dev/null || install_go

# Install Go deps
echo Installing Go deps
for d in $go_deps; do
	exec_name=$(get_executable_name $d)
	which $exec_name &>/dev/null || go get -u $d || exit 1
done
echo Go deps installed

