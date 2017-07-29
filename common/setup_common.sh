#!/bin/bash

function setup_windows {
	echo Windows setup is not supported yet
	exit 1
}

function setup_ubuntu {
	echo Common Ubuntu setup started
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

echo Setup Complete

