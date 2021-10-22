#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-13 17:44:04
 # @LastEditTime : 2021-10-21 14:19:12
 # @LastEditors  : KK
 # @Description  : Write some configure to .zshrc
 # @FilePath     : \debian_install_script\oh_my_zsh_zshrc.sh
### 

set -e
set -o pipefail
SCRIPT_PATH=$(dirname $0)
if [[ ${SCRIPT_PATH} == "." ]]
then 
    SCRIPT_PATH=$(pwd)
fi

source ${SCRIPT_PATH}/common.sh

cd ~

backup_exist ~/.zshrc

# write .zshrc config file
cat > ~/.zshrc <<- EOF
cd ~
export GOPROXY=${GO_PROXY}
export RUSTUP_DIST_SERVER=${RUSTUP_DIST_MIRROR}
export RUSTUP_UPDATE_ROOT=${RUSTUP_UPDATE_MIRROR}

export ZSH=\${HOME}/.oh-my-zsh
export ZSH_CUSTOM=\${ZSH}/custom

# tldr config
export TLDR_COLOR_NAME="blod yellow"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="cyan"
export TLDR_COLOR_COMMAND="red"
export TLDR_COLOR_PARAMETER="green"
export TLDR_LANGUAGE="en"
export TLDR_CACHE_ENABLED=1
export TLDR_CACHE_MAX_AGE=720
# export TLDR_ALLOW_INSECURE=1
# export TLDR_PAGES_SOURCE_LOCATION="${GITHUB_MIRROR_RAW}/tldr-pages/tldr/master/pages"
# export TLDR_DOWNLOAD_CACHE_LOCATION="${GITHUB_MIRROR_RAW}/tldr-pages/tldr-pages.github.io/master/assets/tldr.zip"



# Conflict with powelevel10k.
# figlet KK -f \${ZSH_CUSTOM}/plugins/figlet/fonts/Isometric3.flf

# Set the zsh theme.
ZSH_THEME="powerlevel10k/powerlevel10k"
source \${ZSH_CUSTOM}/themes/powerlevel10k/powerlevel10k.zsh-theme

# Close the beep.
unsetopt beep

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
    sudo
    copydir
    copyfile
    # dirhistory
    history
    # zsh-autojump
    zsh-autosuggestions
    zsh-syntax-highlighting
    vi-mode
    safe-paste
    cp
    # rand-quote
    colored-man-pages
    extract
    )

# Init the autojump plugin.
# [[ -s \${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source \${HOME}/.autojump/etc/profile.d/autojump.sh
# autoload -U compinit && compinit -u

source \${ZSH}/oh-my-zsh.sh

# Alias exa
if [ -x "$(command -v exa)" ]; then
    alias ls="exa --all"
    alias la="exa --long --header --all --icons --group --git"
fi

# set autocompletion method
zstyle ':completion:*' menu select

# # This speeds up pasting w/ autosuggest
# # https://github.com/zsh-users/zsh-autosuggestions/issues/238
# # Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=\${\${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need \`.url-quote-magic\`?
}

pastefinish() {
  zle -N self-insert \${OLD_SELF_INSERT}
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
source \${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
### Fix slowness of pastes


EOF

zsh -c "source ~/.zshrc"

wait