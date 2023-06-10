#!/usr/bin/env sh

mkdir -vp .config/nvim
mkdir -vp .config/tmux
mkdir -vp .config/undotree
mkdir -vp .config/yapf
mkdir -vp .config/zsh
mkdir -vp .local/bin

yes | cp -vr $HOME/.config/nvim ./.config
yes | cp -vr $HOME/.config/tmux ./.config
yes | cp -vr $HOME/.config/yapf ./.config
yes | cp -vr $HOME/.config/zsh/custom_completions ./.config/zsh
yes | cp -vr $HOME/.local/bin/ ./.local

yes | cp -v $HOME/.config/zsh/.zshrc ./.config/zsh
yes | cp -v $HOME/.condarc ./.condarc
yes | cp -v $HOME/.fdignore ./.fdignore
yes | cp -v $HOME/.fzf.zsh ./.fzf.zsh
yes | cp -v $HOME/.gitconfig ./.gitconfig
yes | cp -v $HOME/.zprofile ./.zprofile
