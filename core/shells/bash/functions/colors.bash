#!/bin/bash
nocolor() {
	tput sgr0
}
black() {
	tput setaf 6
}

red() {
	tput setaf 1
}

orange() {
	tput setaf 208
}

green() {
	tput setaf 2
}

yellow() {
	tput setaf 3
}

blue() {
	tput setaf 4
}

magenta() {
	tput setaf 5
}

cyan() {
	tput setaf 6
}
white() {
	tput setaf 7
}
export nocolor
export black
export red
export orange
export green
export yellow
export blue
export magenta
export cyan
export white
