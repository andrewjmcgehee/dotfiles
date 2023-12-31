# Path
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/Workspaces/go/bin:/usr/local/texlive/2022/bin/universal-darwin:/opt/homebrew/opt/fzf/bin

# Variables
export EDITOR="nvim"
export VISUAL="nvim"

# Keep HOME clean
export GOPATH="$HOME/Workspaces/go"
export HISTFILE="$HOME/.config/zsh/.zsh_history"
export LESS=-R
export LESSHISTFILE="/dev/null"
export ZDOTDIR="$HOME/.config/zsh"

# Colors
autoload -U colors && colors

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Prevent virtual environment prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# CAUSES SLOWER STARTUP
# nvm 
# export NVM_DIR="$HOME/.config/nvm"
# loads nvm and completions
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Functions
act() {
  cd $HOME/Workspaces/$1 && conda activate $1 && PYTHON3_HOST="$(which python3)"
  [[ -d $HOME/Workspaces/$1/src ]] && cd $HOME/Workspaces/$1/src
}

check_exit() {
  local last_exit=$?
  if [[ $last_exit -ne 0 ]]; then
    local exit_prompt="%{$fg[red]%}→ $last_exit%F{reset}"
    echo $exit_prompt
  fi
}

conda_info() {
  local conda_env=""
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    conda_env="@ "
  fi
  echo $conda_env
}

git_branch() {
  branch="$(git branch --show-current 2>/dev/null)"
  [[ -z "$branch" ]] || echo " $branch"
}

git_modified() {
  if [[ -n "$(git_branch)" ]]; then
    git status 2>/dev/null | grep 1>/dev/null 'working tree clean' || printf '*'
  fi
}

get_ps1() {
  local prompt="%F{8}$(conda_info)◂ "
  prompt="$prompt%{$fg[magenta]%}t%{$fg[blue]%}h%{$fg[green]%}i"
  prompt="$prompt%{$fg[yellow]%}n%{$fg[red]%}k"
  prompt="$prompt%{$fg[blue]%}$(git_branch)$(git_modified) "
  prompt="$prompt%{$fg[magenta]%}$(python3 $HOME/.local/bin/ps1.py path)"
  prompt="$prompt%F{8} ▸%F{reset} "
  echo "$prompt"
}

tm() {
  tmux new -A -s ${1:-work} 
}

ve() {
  [[ -z $1 ]] && return 127
  [[ -z $2 ]] && return 127
  conda create -n $1 python=$2
  mkdir -vp $1/src
}

ws() {
  cd $HOME/Workspaces
  [[ -z $1 ]] && return 0
  if [[ -d $HOME/Workspaces/$1 ]]; then
    act $1 2>/dev/null
    [[ -d $HOME/Workspaces/$1/src ]] && cd $HOME/Workspaces/$1/src
    return 0
  else
    [[ -z $2 ]] && return 127
    echo "Creating workspace: $1 (Python $2)"
    ve $1 $2
    act $1
    return 0
  fi
}

# Prompt
PS1="\$(get_ps1)"
RPROMPT="\$(check_exit)"

# Aliases
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# zsh syntax highlighting
# Syntax Highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    2>/dev/null

# Custom Zsh Completions
fpath=($HOME/.config/zsh/custom_completions /opt/homebrew/share/zsh/site-functions $fpath)
autoload -U compinit && compinit

# ls colors
export LSCOLORS=Exfxcxdxbxegedabagacad
export CLICOLOR=1
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/amcg/Code/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/amcg/Code/miniconda/etc/profile.d/conda.sh" ]; then
        . "/Users/amcg/Code/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/amcg/Code/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# kubectl auto completions
source <(kubectl completion zsh)

# fzf
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow | sort"
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow | sort"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--color=fg:#abb2bf,bg:#282c34,preview-bg:#282c34,hl:#d19a66:underline,fg+:#61afef,bg+:#31353f,hl+:#d19a66:underline,info:#98c379,border:#61afef,prompt:#c678dd,pointer:#e86671,marker:#c678dd,spinner:#98c379"
