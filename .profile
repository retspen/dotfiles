# ~/.profile

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# add local bin path
[ -d $HOME/.local/bin ] && PATH=$HOME/.local/bin:$PATH
[ -d $HOME/.local/sbin ] && PATH=$HOME/.local/sbin:$PATH
[ -d /usr/local/bin ] && PATH=/usr/local/bin:$PATH
[ -d /usr/local/sbin ] && PATH=/usr/local/sbin:$PATH

# LANGUAGE
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# FTP passive mode
: ${FTP_PASSIVE:=1}
export FTP_PASSIVE

# Bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    . /usr/local/bin/virtualenvwrapper.sh
fi

# Grep colorize
alias grep="grep --color=auto"
unset GREP_OPTIONS

# Add Visual Studio Code (code)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Python ENV
export PATH="~/Library/Python/2.7/bin:~/Library/Python/3.6/bin:$PATH"

# GNU sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Don't put duplicate lines in the history
export HISTCONTROL=ignoreboth

# setup color variables
color_is_on=
color_red=
color_green=
color_yellow=
color_blue=
color_white=
color_gray=
color_bg_red=
color_off=
color_user=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_is_on=true
    color_red="\[$(/usr/bin/tput setaf 1)\]"
    color_green="\[$(/usr/bin/tput setaf 2)\]"
    color_yellow="\[$(/usr/bin/tput setaf 3)\]"
    color_blue="\[$(/usr/bin/tput setaf 6)\]"
    color_white="\[$(/usr/bin/tput setaf 7)\]"
    color_gray="\[$(/usr/bin/tput setaf 8)\]"
    color_off="\[$(/usr/bin/tput sgr0)\]"

    color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
    color_error_off="$(/usr/bin/tput sgr0)"

    # set user color
    case `id -u` in
        0) color_user=$color_red ;;
        *) color_user=$color_green ;;
    esac
fi

# some kind of optimization - check if git installed only on config load
PS1_GIT_BIN=$(which git 2>/dev/null)

function prompt_command {
    local PS1_GIT=
    local PS1_VENV=
    local GIT_BRANCH=
    local GIT_DIRTY=
    local PWDNAME=$PWD

    # beautify working directory name
    if [[ "${HOME}" == "${PWD}" ]]; then
        PWDNAME="~"
    elif [[ "${HOME}" == "${PWD:0:${#HOME}}" ]]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi

    # parse git status and get git variables
    if [[ ! -z $PS1_GIT_BIN ]]; then
        # check we are in git repo
        local CUR_DIR=$PWD
        while [[ ! -d "${CUR_DIR}/.git" ]] && [[ ! "${CUR_DIR}" == "/" ]] && [[ ! "${CUR_DIR}" == "~" ]] && [[ ! "${CUR_DIR}" == "" ]]; do CUR_DIR=${CUR_DIR%/*}; done
        if [[ -d "${CUR_DIR}/.git" ]]; then
            # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
            if [[ "${CUR_DIR}" != "${HOME}" ]] || [[ "${PWD}" == "${HOME}" ]]; then
                # get git branch
                GIT_BRANCH=$($PS1_GIT_BIN symbolic-ref HEAD 2>/dev/null)
                if [[ ! -z $GIT_BRANCH ]]; then
                    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

                    # get git status
                    local GIT_STATUS=$($PS1_GIT_BIN status --porcelain 2>/dev/null)
                    [[ -n $GIT_STATUS ]] && GIT_DIRTY=1
                fi
            fi
        fi
    fi

    # build b/w prompt for git and virtual env
    [[ ! -z $GIT_BRANCH ]] && PS1_GIT=" [git: ${GIT_BRANCH}]"
    [[ ! -z $VIRTUAL_ENV ]] && PS1_VENV="(venv: ${VIRTUAL_ENV#$WORKON_HOME})"

    if $color_is_on; then
        # build git status for prompt
        if [[ ! -z $GIT_BRANCH ]]; then
            if [[ -z $GIT_DIRTY ]]; then
                PS1_GIT=" [git: ${color_green}${GIT_BRANCH}${color_off}]"
            else
                PS1_GIT=" [git: ${color_red}${GIT_BRANCH}${color_off}]"
            fi
        fi

        # build python venv status for prompt
        [[ ! -z $VIRTUAL_ENV ]] && PS1_VENV="(venv: ${color_blue}${VIRTUAL_ENV#$WORKON_HOME}${color_off})"
    fi

    # set new color prompt
    if [[ ! -z $VIRTUAL_ENV ]]; then
        PS1="${color_white}${PWDNAME}${color_off}${PS1_GIT} ${PS1_VENV}\n${color_yellow}➜${color_off} "
    else
        PS1="${color_white}${PWDNAME}${color_off}${PS1_GIT}\n${color_yellow}➜${color_off} "
    fi

    # get cursor position and add new line if we're not in first column
    # cool'n'dirty trick (http://stackoverflow.com/a/2575525/1164595)
    # echo -en "\033[6n" && read -sdR CURPOS
    # [[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"
}

# set prompt command (title update and color prompt)
PROMPT_COMMAND=prompt_command
# set new b/w prompt (will be overwritten in 'prompt_command' later for color prompt)
PS1='\u@${LOCAL_HOSTNAME}:\w\$ '

function weather {
    curl -s wttr.in/zaporizhzhy?lang=ru
}

function moon {
    curl -s wttr.in/Moon
}
