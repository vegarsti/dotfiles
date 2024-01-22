# Profile zsh startup time
# zmodload zsh/zprof

##########
# BASIC SETUP
##########

# Make PATH not include duplicates
typeset -U PATH

# zsh settings
setopt nobeep
setopt autocd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt auto_menu
setopt complete_in_word
setopt always_to_end

# zsh plugin manager??
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=5000000000
SAVEHIST=5000000000

# docs: https://zsh.sourceforge.io/Doc/Release/Options.html
setopt hist_expire_dups_first    # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups          # Don't record an entry that was just recorded again.
setopt hist_ignore_all_dups      # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups         # Don't display a line previously found.
setopt hist_ignore_space         # Don't record an entry starting with a space.
setopt hist_save_no_dups         # Don't write duplicate entries in the history file.
setopt share_history             # Immediately share history between concurrent terminal sessions,
                                 # and store history with timestamps


#############
# COMPLETION
#############

# TODO: How does this actually work?

# This seems to load completions for git etc, possibly others as well?
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'z

#########
# Aliases
#########
alias history='history 1' # longer

# extended ..
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias k='kubectl'
alias kx='kubectx'

alias g=git
alias gg="git status --short"
alias c="clear"

alias amend="git commit --amend --no-edit"

alias ls=exa
alias ll="exa -l"
# how to set exa colors? pretty ugly right now

# work
export GOPRIVATE=github.com/duneanalytics

. /opt/homebrew/etc/profile.d/z.sh


########
# ENV
########

export LANG=en_US.UTF-8 # turns off man complaining about locale

# Add brew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# History completions using zsh-autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# syntax highlithignt
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# colors kinda ugly right now

# ZSH_HIGHLIGHT_STYLES?
# Declare the variable as array (?)
typeset -A ZSH_HIGHLIGHT_STYLES
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
ZSH_HIGHLIGHT_STYLES[unknown-token]='none'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=white,underline'
# None of these havy any effect 🤔
# ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=white,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=white,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=white,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=white,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=white,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=white,bold'

# use exa instead of ls. set colors
export EXA_COLORS="di=37;1:ex=37:fi=37:ln=37:*.png=37"

# go
export GOPATH=$HOME/code/go
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$(go env GOPATH)/bin


#########
# PROMPT
#########

setopt prompt_subst # expand prompt

# git
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
PROMPT='%T %B%~%b ${vcs_info_msg_0_}# '

# git status prompt
# source $(brew --prefix)/opt/gitstatus/gitstatus.prompt.zsh
# PROMPT='%T %B%~%b ${vcs_info_msg_0_} $GITSTATUS_PROMPT  # '



# fzf
export FZF_DEFAULT_OPTS='--height=40% --border --info=inline'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# fzf search (uses zinit, so put it after)
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search




# Keep at end of .zshrc, for profiling
# zprof