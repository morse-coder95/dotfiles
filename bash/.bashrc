# .bashrc

set -o vi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export ECN_ENVIRONMENT=${USER}_bzx
export TERM="screen-256color"
export DJANGO_SETTINGS_MODULE=intranet.batsint.settings


export PSQL_EDITOR="/opt/bats/bin/nvim"

# The following line allows for tab completion with git commands, branches, etc.
source ~/git-completion.bash

# User specific aliases and functions
alias vim="/opt/bats/bin/nvim"
alias pycharm="~/apps/pycharm/bin/pycharm.sh"
alias vimbrc="vim ~/.bashrc"
alias srcbrc="source ~/.bashrc"
alias srcp="cd ~/source/python/ecn/prog/"
alias srcop="cd ~/source/python/opt/prog/"
alias nodes="cd ~/db/nodes && ls"
alias dbcode="cd ~/db/code"
alias cdp="cd ~/source/python"
alias tr="tree -C"
alias st="git status"
alias add="git add -A"
alias ntac="nosetests --verbose -a current"
alias nt="nosetests --verbose"
alias src="cd ~/source"
alias cl="clear"
alias cdw="cd ~/source/web"
alias jump="ssh lxlc-jump04"
alias vimconf="vim ~/.config/nvim/init.vim"
alias wttr="curl wttr.in"
alias mylogs="git log --author $(whoami)"


function fif() {
      # Shamelessly ripped from fzf wiki examples
      if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
      SELECTION=$(rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}");
      if [ "$SELECTION" != '' ]; then vim "$SELECTION"; fi
  }


gb () {
    git checkout $(git branch | fzf)
}

cdir () {
    mkdir -p -- "$1" && cd -P -- "$1"
}

# nosetests with coverage
ntcov () {
    set -x # echo on
    nosetests $1 --with-cov --cov=../"${1//test_}" --cov-report=term-missing --cov-config ~/.coveragerc --verbose
    set +x # echo off
}

# creates empty files for batch script and test script
new () {
    if [ ! -f __init__.py ]; then
        echo "Creating __init__.py"
        touch __init__.py
    fi
    echo "Creating $1.py"
    touch $1.py
    if [ ! -d "tests" ]; then
        mkdir tests
    fi
    echo "Creating tests/test_$1.py"
    touch tests/test_$1.py
}

boot() {
    if [[ $1 =~ ^("bzx"|"byx"|"edga"|"edgx"|"opt"|"exo"|"ctwo"|"cone"|"cfe"|"idx"|"usc"|"global")$ ]]; then
        set -x
        ~/source/db/code/bootstrap.py -dfq --db-types=mongo $2 nmorse_$1
        set +x
    else
        set -x 
        ~/source/db/code/bootstrap.py -dfq --db-types=mongo $2 $1
        set +x
    fi
}

bsql() {
    if [[ $1 =~ ^("bzx"|"byx"|"edga"|"edgx"|"opt"|"exo"|"ctwo"|"cone"|"cfe"|"idx"|"usc"|"global")$ ]]; then
        bsql.sh $(whoami)_$1 $2 $3
    else
        bsql.sh $1 $2 $3
    fi
}
csql() {
    if [[ $1 =~ ^("bzx"|"byx"|"edga"|"edgx"|"opt"|"exo"|"ctwo"|"cone"|"cfe"|"idx"|"usc"|"global")$ ]]; then
        csql.sh $(whoami)_$1 $2 $3
    else
        csql.sh $1 $2 $3
    fi
}

goto() {
    cd "$(find $1 -printf '%h')"
}


parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

cleanup() {
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" != "master" ]]; then
        echo "Aborting: make sure you're on master";
    else
        git branch -D $1;
        git push --delete origin $1;
    fi
}

export PS1="\[\e[32m\]\@\[\e[m\] \[\e[35m\]\h\[\e[m\] \[\e[31m\]\w\[\e[m\]\n\[\e[34m\](\`parse_git_branch\`)\[\e[m\] >> "


# Shamelessly stolen straing off DeWeese's container. Faster version of gf
ft(){
    if [ "$#" -ne 2 ]; then
        PATT="*.py";
    else PATT=$2
    fi

    find -L . -name "${PATT}" -print | grep -v '\.svn' | xargs egrep -H --color -n "$1";
}

fti() {
    if [ "$#" -ne 2 ]; then
        PATT="*.py";
    else
        PATT=$2
    fi

    find -L . -name "${PATT}" -print | grep -v '\.svn' | xargs egrep -H --color -in "$1";
}

function conn()
{

    if [[ "$#" < 1 ]] ; then
        echo -e  "\nMust supply db name to connect to\n"
    else
        bsql.sh $(whoami)_${1}
    fi
}

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

alias 'build_batch'='builtin cd ~/cpp;./bb configure -f;./bb debug -j 64 --use-ib -T ecn_py_wire ecn_pg ecn_py_pg ecn_py_util get_param ecn_fee_code_util'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f ~/source/util/bash_completions.sh ]; then
        export BSQL_ENVIRONMENT_FILTER="^${USER}_|^[^_]+\$"
       . ~/source/util/bash_completions.sh
fi

# auto completion for nosetests (tam)
. ~/source/util/nosetests_complete
