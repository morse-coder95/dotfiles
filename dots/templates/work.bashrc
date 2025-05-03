# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


export ECN_ENVIRONMENT=${USER}_bzx
export TERM="screen-256color"
export DJANGO_SETTINGS_MODULE=intranet.batsint.settings


export VISUAL="~/.local/bin/nvim"
export EDITOR="$VISUAL"

# The following line allows for tab completion with git commands, branches, etc.
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# User specific aliases and functions
alias myssh='eval $(ssh-agent) && ssh-add && ln -sf ${SSH_AUTH_SOCK} ~/.ssh/ssh_auth_sock'
alias nodes="cd ~/db/nodes && ls"
alias cdp="cd ~/source/python"
alias jump="ssh lxlc-jump05"
alias jumpuk="ssh scolinjh1.uk.cboe.net"
alias mylogs="git log --author $(whoami) --stat"
alias npmrun='NODE_OPTIONS="--max-old-space-size=4096" npm run server'

alias sn='syseng-nodectl'
alias snl='syseng-nodectlv3 --environment=syseng-production  list '
alias sne='syseng-nodectlv3 --environment=syseng-production  update --message "Read Only" --edit '
function snu() {
    syseng-nodectlv3 --environment=syseng-production update --message "$1" --edit $2
}

function pt() {
    pytest -sv --disable-warnings $@
}

function ptx() {
    pytest -svx --disable-warnings $@
}

fzf-branch-widget() {
  local selected="$(git branch | fzf | sed -e 's/^[ \t]*//')"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT + ${#selected}))
}

function bs() {
    if [ "$1"  = "all" ]; then
        bootstrap_parallel.py -dv std;
    else
        DBENV=$(whoami)_$1
        if [ "$#" -lt 2  ]; then
            DBTYPES="mongo";
            shift 1
        else
            DBTYPES=$2
            shift 2
        fi

        set -x
        bootstrap.py -dfq --db-types=$DBTYPES --skip-vault --skip-kudu --skip-docs "$@" $DBENV
        set +x
    fi
}

cdir () {
    mkdir -p -- "$1" && cd -P -- "$1"
}

goto() {
    cd "$(find $1 -printf '%h')"
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

export PS1="\[\e[32m\]\@\[\e[m\] \[\e[35m\]\h\[\e[m\] \[\e[31m\]\w\[\e[m\]\n\[\e[34m\](\`parse_git_branch\`)\[\e[m\] >> "

# shortcut for sending files to Windows
function sendme()
{
    echo $HOSTNAME':'$PWD'/'$1 'File emailed from linux' | nail -a $1 -s container-files nmorse@cboe.com
}

function sendyou()
{
    if [[ $# < 2 ]] ; then
        echo "Need both file and email address"
    else
        echo $HOSTNAME':'$PWD'/'$1 'File emailed from linux' | nail -a $1 -s container-files $2
    fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f ~/source/util/bash_completions.sh ]; then
        export BSQL_ENVIRONMENT_FILTER="^${USER}_|^[^_]+\$"
       . ~/source/util/bash_completions.sh
fi

# auto completion for nosetests (tam)
. ~/source/util/pytest_complete
