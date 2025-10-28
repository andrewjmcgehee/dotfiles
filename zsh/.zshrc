# keep home dir clean
export EDITOR=nvim
export GOPATH="$HOME/Go"
export HISTSIZE=10000
export LESS=-R
export LESSHISTFILE=/dev/null
export NVM_DIR="$HOME/.nvm"
# xdg config vars
export XDG_CONFIG_HOME="$HOME/.config"
export HISTFILE="$XDG_CONFIG_HOME/zsh/.zsh_history"
# fzf vars
export FZF_DEFAULT_OPTS="--color=bg+:#2d3f76,bg:#1e2030,border:#589ed7,fg:4,hl+:3,hl:3,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#65bcff,spinner:#ff007c,header:#ff966c,gutter:#222436"
export FZF_ALT_C_COMMAND="fd --type d . $HOME --hidden --follow | sort"
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow | sort"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# z4h
# auto-update: "ask" or "no". run `z4h update` to update manually.
zstyle ":z4h:" auto-update "ask"
# how often to auto-update. no effect if auto-update is "no".
zstyle ":z4h:" auto-update-days "28"
# keyboard type: "mac" or "pc".
zstyle ":z4h:bindkey" keyboard "mac"
# start tmux
zstyle ":z4h:" start-tmux command tmux -u new -A -s work
# keep prompt at bottom
zstyle ":z4h:" prompt-at-bottom "yes"
# no additional semantic shell info
zstyle ":z4h:" term-shell-integration "no"
# "partial-accept" accepts 1 char from command autosuggestions, "accept" accepts the whole suggestion
zstyle ":z4h:autosuggestions" forward-char "accept"
# recursive directory completion with fzf
zstyle ":z4h:*" fzf-flags $FZF_DEFAULT_OPTS
zstyle ":z4h:fzf-complete" recurse-dirs "yes"
# ssh teleport
zstyle ":z4h:ssh:*" enable "no"
# zstyle ":z4h:ssh:*" send-extra-files "~/.config/aliasrc" "~/.config/tmux/tmux.conf" "~/.config/fd/ignore" "~/.config/nvim"
zstyle ":completion:*:ssh:argument-1:" tag-order hosts users
zstyle ":completion:*:scp:argument-rest:" tag-order hosts files users
zstyle ":completion:*:(ssh|scp|rdp):*:hosts" hosts
# use most up to date version of zsh-history-substring-search
zstyle ":z4h:zsh-autosuggestions" channel "dev"
zstyle ":z4h:zsh-completions" channel "dev"
zstyle ":z4h:zsh-history-substring-search" channel "dev"
zstyle ":z4h:zsh-syntax-highlighting" channel "stable"
# init
z4h init || return
# export explicit path
export MACOS_BARE_PATH=/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
export BUN_INSTALL="$HOME/.bun"
# in reverse order of priority
PATH="$MACOS_BARE_PATH"                               # mac defaults
PATH="$HOME/.config/scripts:$PATH"                    # personal scripts
PATH="$HOME/.local/bin:$PATH"                         # local bin
PATH="$HOME/.cache/zsh4humans/v5/fzf/bin:$PATH"       # zsh4humans fzf
PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"      # postgres 17
PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH" # gcloud
PATH="/opt/homebrew/opt/ruby/bin:$PATH"               # ruby
PATH="$BUN_INSTALL:$PATH"                             # bun
PATH="$HOME/.cargo/bin:$PATH"                         # cargo (rust)
PATH="$GOPATH/bin:$PATH"                              # go
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"     # homebrew
PATH="$HOME/.local/share/nvim/mason/bin:$PATH"        # neovim mason
export PATH

# nvm (must come after PATH definition because this modifies PATH)
[[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"

# extend fpath with custom completions
fpath=(/opt/homebrew/share/zsh/site-functions $ZDOTDIR/completions $fpath)
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
# export environment vars
export GPG_TTY=$TTY

##### CUSTOM #####

# fuzzy history
fzf-history() {
  original=$FZF_DEFAULT_OPTS
  export FZF_DEFAULT_OPTS="--tmux 70% $FZF_DEFAULT_OPTS"
  fzf-history-widget
  export FZF_DEFAULT_OPTS=$original
}
zle -N fzf-history

# janky way to get git branch even in worktrees
git_branch() {
  echo $(git status) | awk '/On branch/ {print $3}'
}

# workspaces
ws() {
  cd $HOME/Workspaces
  [[ -z $1 ]] && return 0
  if [[ -d $HOME/Workspaces/$1 ]]; then
    cd $HOME/Workspaces/$1
  fi
  return 0
}

# colors
autoload -U colors && colors

# prevent virtual environment prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# aliases
[[ -f "$HOME/.config/aliasrc" ]] && source "$HOME/.config/aliasrc"

# ls colors
export LSCOLORS=Exfxcxdxbxegedabagacad
export CLICOLOR=1
export LS_COLORS="rs=0:di=00;34:ln=00;36:mh=00:pi=40;33:so=00;35:do=00;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=00;32:*.tar=00;31:*.tgz=00;31:*.arc=00;31:*.arj=00;31:*.taz=00;31:*.lha=00;31:*.lz4=00;31:*.lzh=00;31:*.lzma=00;31:*.tlz=00;31:*.txz=00;31:*.tzo=00;31:*.t7z=00;31:*.zip=00;31:*.z=00;31:*.dz=00;31:*.gz=00;31:*.lrz=00;31:*.lz=00;31:*.lzo=00;31:*.xz=00;31:*.zst=00;31:*.tzst=00;31:*.bz2=00;31:*.bz=00;31:*.tbz=00;31:*.tbz2=00;31:*.tz=00;31:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.war=00;31:*.ear=00;31:*.sar=00;31:*.rar=00;31:*.alz=00;31:*.ace=00;31:*.zoo=00;31:*.cpio=00;31:*.7z=00;31:*.rz=00;31:*.cab=00;31:*.wim=00;31:*.swm=00;31:*.dwm=00;31:*.esd=00;31:*.avif=00;35:*.jpg=00;35:*.jpeg=00;35:*.mjpg=00;35:*.mjpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.tiff=00;35:*.png=00;35:*.svg=00;35:*.svgz=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.webm=00;35:*.webp=00;35:*.ogm=00;35:*.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.flv=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.cgm=00;35:*.emf=00;35:*.ogv=00;35:*.ogx=00;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:"

# kubectl auto completions
source <(kubectl completion zsh)

# zsh history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=transparent,fg=magenta,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=transparent,fg=red,bold"
export HISTORY_SUBSTRING_SEARCH_PREFIXED="true"
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"

# fzf
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
# change fzf key-bindings
bindkey "^T" transpose-chars
bindkey "^H" fzf-history
bindkey -r "^F"
bindkey -r "^R"

# orbstack completions
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# gcloud completions
source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc

# terraform completions
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# shell options
setopt glob_dots    # no special treatment for file names with a leading dot
setopt no_auto_menu # require an extra TAB press to open the completion menu

# aws completions
complete -C "/opt/homebrew/bin/aws_completer" aws
complete -C "/opt/homebrew/bin/aws_completer" awslocal
