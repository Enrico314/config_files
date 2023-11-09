#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		# original
		#PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
		PS1='\[\033[01;32m\][$PWD\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h [\w] \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ll="ls -hl"
alias l="ls -hl"

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;; *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}



alias wk="source ~/Documents/code/python/venv/bin/activate"


# alias connu2="pulsesvc -h vpn-ssl.unitn.it -u enrico.pierobon@unitn.it -U https://vpn-ssl.unitn.it/vpn-out -r   AR-unitn-ldap-ad"

alias connu="sudo openconnect --servercert pin-sha256:bauCRBH3aKnr9iSPqrHz0tyxWquS1XoCOh1maj4yWSQ= --csd-wrapper /usr/lib/openconnect/hipreport.sh --protocol=gp --user=enrico.pierobon@unitn.it vpn.icts.unitn.it"
alias connu2="sudo openconnect --csd-wrapper /usr/lib/openconnect/hipreport.sh --protocol=gp --user=enrico.pierobon@unitn.it vpn-out.icts.unitn.it"

# alias mk="make -j"

alias ss="autorandr -c"

# behave like vim
set -o vi

# set vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# autojump
source /usr/share/autojump/autojump.bash

alias ju='cd ~/Documents/code/python && jupyter-lab'

# topas alias
alias topa='export TOPAS_G4_DATA_DIR=~/Documents/topas/topasBin/G4Data && export PS1="topas "${PS1} && PATH=$PATH:~/Documents/topas/topasBin/bin'

# G4 alias
alias g4='source ~/Documents/geant4/geant4.10.07.p01-install/bin/geant4.sh && export PS1="[G4] "${PS1}'

G4_I="/home/questo/Documents/geant4/geant4.10.07.p01-install/lib/Geant4-10.7.1"

# alias for picocom
alias com0_fpga='picocom -b 115200 -r -l /dev/ttyUSB0'
alias com1_fpga='picocom -b 115200 -r -l /dev/ttyUSB1'
alias com2_fpga='picocom -b 115200 -r -l /dev/ttyUSB2'

# vi for neovim
alias vin='nvim'
# dtc
export PATH=$PATH:/opt/dtb/dtc/
PATH=$PATH:/opt/Xilinx2/Vivado/2022.2/bin/
PATH=$PATH:/opt/Xilinx2/Vitis/2022.2/bin/

# custom scripts
export PATH=$PATH:/home/questo/bin/

# petalinux

#alias pt='source /opt/Xilinx/petalinux/settings.sh && source ~/Documents/vEnv/python2/bin/activate && export PS1="petalinux "${PS1} '
alias pt='source /opt/Xilinx/petalinux/settings.sh && export PS1="petalinux "${PS1} '

alias ro='source /home/questo/Documents/root/root_install/bin/thisroot.sh && export PS1="[root] "${PS1} '

# xilinx 
alias xil='source /opt/Xilinx/SDK/2019.1/settings64.sh && export PS1="[xil] "${PS1}'
alias xil2='source /opt/Xilinx2/Vivado/2022.2/settings64.sh && export PS1="[xil2] "${PS1}'

# rstudio fix
export RSTUDIO_CHROMIUM_ARGUMENTS="--no-sandbox"

# export current working directory
export PROMPT_COMMAND="pwd > /tmp/whereami"

# kitty term over ssh, to replace ssh with sshkitty, copying information
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

