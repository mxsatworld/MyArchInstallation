#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
PS1='[\u@\h \W]\$ '

function wifiList() {
	nmcli dev wifi list
}
function wifiConnect() {
	sudo nmcli --ask dev wifi connect "$1"
}
function wifiDisconnect() {
	nmcli con down "$1"
}
function wifiStatus(){
	nmcli con show --active
}
