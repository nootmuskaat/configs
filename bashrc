# $HOME/.bash_profile
set -o vi
export EDITOR=$(command -v nvim &>/dev/null && echo "nvim" || echo "vim")

export IPYTHONDIR="$HOME/.config/ipython"
export sysd="/etc/systemd/system"

# My standared aliases
alias vi=${EDITOR}
alias view="${EDITOR} -R"
alias lx='exa -F'
alias lxl='exa -la --git'
alias lxltr='exa -lrs modified --git'
alias lxtree='exa -F --tree --git-ignore'
alias ls='command ls -F'
alias ll='command ls -lA'
alias lsltr='ls -ltr'
alias o='less'
alias O='less -R'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias .bash_profile='source $HOME/.bash_profile'
alias bash_profile="${EDITOR}"' $HOME/.bash_profile && .bash_profile'
alias q='2>/dev/null'
alias wr='while read'

# like regular mktemp, but exports to a global variable
function mktemp() {
    local -r tmpfile=$(command mktemp)
    export TMPFILE=${tmpfile}
    echo ${tmpfile}
}

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline


# easier scripting
function _first() { awk "$@" '{ print $1 }' ; }
function _last() { awk "$@" '{ print $NF }' ; }
function _split() { cut -d"$1" -f"$2" ; }
function _split_ws() { sed 's/\s\+/\t/g' | cut -f"$1" | tr '\t' ' ' ; }
function _is_dir() { test -d "$1" ; }
function _is_empty() { test ! -s "$1" ; }
function _isnt_empty() { test -s "$1" ; }

if ! command -v rg &>/dev/null ;  then
    alias rg='grep -r --color -E'
else
    alias rg='rg --hidden'
fi

# This is sadly necessary
alias wq="echo you're not in vim"
alias q=wq
alias :q=wq
alias :wq=wq


# Generic prompt setup for the most common Linux distros
if [[ -e "${PROMPT_SETUP:=$HOME/.prompt-setup.sh}" ]]; then
    source "${PROMPT_SETUP}"
fi

# Any host specific functions or actions
if [[ -f "${HOSTRC:=$HOME/.bash_profile_$(hostname)}" ]]; then
    source "$HOSTRC"
fi

function cal() {
    command cal -m -3 -n9 $@ 2>/dev/null || command cal -m -3 $@
}

function sorted() {
    local src="$1"
    local temp="$(mktemp)"
    cp "${src}" "${temp}" &&
        sort "${temp}" > "${src}" &&
        rm "${temp}"
}

function python() {
    if [[ $# == 0 ]] && command -v ipython &>/dev/null ; then
        ipython
    else
        python3 "$@"
    fi
}

function cat_all() {
    for path in "$@" ; do
        echo "##################"
        echo "# ${path}"
        echo "##################"
        cat ${path}
        echo
    done
}

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

function exists_and_absent_from_path() {
  for path in "$@"; do
    if [[ -d "${path}" ]] && ! grep -qE '(:|^)'"$path"'(:|$)' <<< "$PATH" ; then
      echo "${path}"
    fi
  done
}

function _latest_ver() {
    command ls -d $1 2>/dev/null | sort -V | tail -n 1
}

# Add optional PATH
declare -a _optional_dirs=(
    $(_latest_ver "$HOME/.gem/ruby/*/bin")
    "$HOME/.cargo/bin"
    "$HOME/node_modules/.bin"
    $(_latest_ver "$HOME/Library/Python/*/bin")
)

for d in $(exists_and_absent_from_path ${_optional_dirs[@]}) ; do
  export PATH="${d}:$PATH"
done

# If opening a new terminal window, count open tmux sessions
if [[ -z "$TMUX" && -n "$(which tmux)" && -f "$HOME/.tmux.conf" ]]; then
    printf '\e[30;47m %d open tmux sessions \e[m\n' \
        $(tmux ls 2>/dev/null | wc -l)
elif [[ -z "$(which tmux)" ]]; then
    printf '\e[30;47m tmux is not installed \e[m\n'
elif [[ ! -f "$HOME/.tmux.conf" ]]; then
    printf '\e[30;47m no tmux configuration \e[m\n'
fi


function mk_pwd() {
  local -ri length=${1:-20}

  python -c "
import random
import string
chars = string.ascii_letters + string.digits + string.punctuation
print(''.join(random.choice(chars) for _ in range(${length})))
"
}

if [[ -f "$HOME/.cargo/env" ]] ; then
    source "$HOME/.cargo/env"
fi

function imports() {
    rg '^\s*(from|import)\s' "$@"
}

# prevent unintended local copy by verifying a `:` is present somewhere
function scp() {
    if grep -q ":" <<< "$@" ; then
        command scp "$@"
    else
        echo "You forgot to add the ':' !!!"
    fi
}

# treat `cd ...` as `cd ../../` and so on
function cd() {
    if grep -qE '^\.\.+$' <<< "$1" ; then
        local -r depth=$((( ${#1} - 1 )))
        local dest=""
        for i in $(seq $depth) ; do
            dest+="../"
        done
        echo "cd $dest"
        builtin cd $dest
    elif [[ $# == 0 ]] ; then
        builtin cd
    else
        builtin cd "$1"
    fi
}


function lines() {
    head -n $2 | tail -n $((( $2 - $1 + 1)))
}

function scpable() {
    echo "$(hostname):$(readlink -f "$1")"
}

function clean_xml() { < "$1" tr -d '\n' | xmllint --format - ;}

# systemctl cat but resolves the %'s
function systemctl-cat() {
    local perc_n=$1
    local perc_i=$(echo $perc_n | cut -d'@' -f2 | cut -d. -f1)
    systemctl cat $perc_n | sed -e "s/%N/$perc_n/g" -e "s/%i/$perc_i/g" -e 's/=/ = /g'
}

alias pip-install-cryptography='env LDFLAGS="-L$(brew --prefix openssl@1.1)/lib" CFLAGS="-I$(brew --prefix openssl@1.1)/include" pip install cryptography'
