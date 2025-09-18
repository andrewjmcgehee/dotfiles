#!/usr/bin/env bash

check () {
  command -v "$1" >/dev/null
}

check-msg () {
  if ! check $1; then
    echo $2
    exit 1
  fi
}

# ensure homebrew installed
check-msg brew "🚨 homebrew is required to run this script. please install it."

# ensure go installed
check-msg go "🚨 go >= 1.25 is required to run this script. please install it."

# check if go >= 1.25
goversion="$(go version | awk '{print $3}' | sed 's/go//')"
if [[ "$goversion" != 1.25.* ]]; then
  echo "🚨 go >= 1.25 is required to run this script. please install it."
  exit 1
fi

# ensure npm installed
if ! check npm; then
  if ! check nvm; then
    echo "🚨 node >= 24 is required to run this script. please install it."
    exit 1
  fi
  nvm use 24 &>/dev/null
  if ! check npm; then
    echo "🚨 node >= 24 is required to run this script. please install it."
    exit 1
  fi
fi

# check if node >= 24
nodeversion="$(node --version | sed 's/v//')"
if [[ "$nodeversion" != 24.* ]]; then
  echo "🚨 node >= 24 is required to run this script. please install it."
  exit 1
fi

status () {
  if [[ $? -eq 0 ]]; then
    echo -e "\033[1;32m✓\033[0m"
  else
    echo -e "\033[1;31m✗\033[0m"
  fi
}

brew-install () {
  printf "    📦 $1 "
  if check $1; then 
    printf "already installed "
  else
    if [ -z "$2" ]; then
      brew install $1 &>/dev/null
    else
      brew install $2 &>/dev/null
    fi
  fi
  status
}

go-install () {
  printf "    📦 $1 "
  if check $1; then 
    printf "already installed "
  else
    if [ -z "$2" ]; then
      go install $1 &>/dev/null
    else
      go install $2 &>/dev/null
    fi
  fi
  status
}

npm-install () {
  printf "    📦 $1 "
  if check $1; then 
    printf "already installed "
  else
    if [ -z "$2" ]; then
      npm i -g $1 &>/dev/null
    else
      npm i -g $2 &>/dev/null
    fi
  fi
  status
}

echo "⚡️ installing tools..."
brew-install packer hashicorp/tap/packer
brew-install terraform hashicorp/tap/terraform
brew-install tree-sitter tree-sitter-cli

echo "⚡️ installing lsp servers..."
brew-install basedpyright
brew-install docker-compose-langserver
brew-install docker-langserver dockerfile-language-server
go-install gopls golang.org/x/tools/gopls@latest 
brew-install lua-language-server
brew-install marksman
npm-install prisma-language-server @prisma/language-server 
brew-install tailwindcss-language-server 
brew-install terraform-ls hashicorp/tap/terraform-ls
brew-install yaml-language-server

echo "⚡️ installing linters and formatters..."
brew-install dockerfmt
go-install gofumpt mvdan.cc/gofumpt@latest 
go-install goimports golang.org/x/tools/cmd/goimports@latest 
go-install golines github.com/segmentio/golines@latest
go-install gosec github.com/securego/gosec/v2/cmd/gosec@latest 
brew-install hadolint
brew-install markdownlint-cli2
brew-install markdown-toc
go-install revive github.com/mgechev/revive@latest 
brew-install ruff
brew-install shfmt
brew-install sqlfluff
go-install staticcheck honnef.co/go/tools/cmd/staticcheck@latest 
brew-install stylua
brew-install tflint
