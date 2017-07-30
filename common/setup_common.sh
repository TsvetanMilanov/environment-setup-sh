#!/bin/bash

function setup_windows {
	echo Windows setup is not supported yet
	# curl is installed
	# install ack-grep
	exit 1
}

function setup_ubuntu {
	echo Common Ubuntu setup started
	ack-grep --help &>/dev/null || sudo apt-get install ack-grep || exit 1
	curl --help &>/dev/null || sudo apt-get install curl || exit 1
	dpkg -l build-essential &>/dev/null || sudo apt-get install build-essential || exit 1
	dpkg -l python-dev &>/dev/null || sudo apt-get install python-dev || exit 1
	dpkg -l python3-dev &>/dev/null || sudo apt-get install python3-dev || exit 1
	dpkg -l libxml2-dev &>/dev/null || sudo apt-get install libxml2-dev || exit 1
	dpkg -l libxslt-dev &>/dev/null || sudo apt-get install libxslt-dev || exit 1
	which cmake &>/dev/null || sudo apt-get install cmake
}

function setup_mac {
	echo Mac setup is not supported yet
	exit 1
}

uname_result="$(uname -s)"
case $uname_result in
	Linux*) setup_ubuntu;;
	Darwin*) setup_mac;;
	MINGW*) setup_windows;;
esac

echo Common setup complete

