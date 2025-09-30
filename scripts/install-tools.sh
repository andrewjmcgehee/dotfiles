#!/usr/bin/env bash

check() {
  command -v "$1" >/dev/null
}

check-msg() {
  if ! check "$1"; then
    echo "$2"
    exit 1
  fi
}

# ensure homebrew installed
check-msg brew "🚨 homebrew is required to run this script. please install it."

status() {
  if [[ $? -eq 0 ]]; then
    echo -e "\033[1;32m✓\033[0m"
  else
    echo -e "\033[1;31m✗\033[0m"
  fi
}

brew-install() {
  printf "  📦 %s " "$1"
  if [ -z "$2" ]; then
    brew install "$1" &>/dev/null
  else
    brew install "$2" &>/dev/null
  fi
  status
}

go-install() {
  printf "  📦 %s " "$1"
  if [ -z "$2" ]; then
    go install "$1" &>/dev/null
  else
    go install "$2" &>/dev/null
  fi
  status
}

npm-install() {
  printf "  📦 %s " "$1"
  if [ -z "$2" ]; then
    npm i -g "$1" &>/dev/null
  else
    npm i -g "$2" &>/dev/null
  fi
  status
}

echo "⚡️ installing brew tools..."
brew-install coreutils
brew-install fd
brew-install font-jetbrains-mono-nerd-font
brew-install fzf
brew-install gcloud-cli
brew-install gh
brew-install git-delta
brew-install go
brew-install kubernetes-cli
brew-install lazygit
brew-install lua
brew-install luajit
brew-install luarocks
brew-install neovim
brew-install node
brew-install packer hashicorp/tap/packer
brew-install python@3.13
brew-install ripgrep
brew-install ruby
brew-install skhd koekeishiya/formulae/skhd
brew-install terraform hashicorp/tap/terraform
brew-install tmux
brew-install tree-sitter

# go install requires brew to install go
echo "⚡️ installing go tools..."
go-install air github.com/air-verse/air@latest
go-install goose github.com/pressly/goose/v3/cmd/goose@latest
go-install gosec github.com/securego/gosec/v2/cmd/gosec@latest
go-install sqlc github.com/sqlc-dev/sqlc/cmd/sqlc@latest
go-install templ github.com/a-h/templ/cmd/templ@latest

# npm install requires brew to install node

# start services
skhd --start-service

OTHER_TOOLS=("alfred" "magnet" "zen browser")

echo "⚡️ other tools you normally like and use..."

for tool in "${OTHER_TOOLS[@]}"; do
  echo "  🔧 $tool"
done
