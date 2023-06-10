# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS="--color=fg:#abb2bf,bg:#282c34,preview-bg:#282c34,hl:#d19a66:underline,fg+:#61afef,bg+:#31353f,hl+:#d19a66:underline,info:#98c379,border:#61afef,prompt:#c678dd,pointer:#e86671,marker:#c678dd,spinner:#98c379"
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow | sort"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow | sort"
