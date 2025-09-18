#!/usr/bin/env bash

# ensure homebrew installed
if ![[ command -v brew ]] &>/dev/null; then
  echo "🚨 homebrew is required to run this script. please install it."
  exit 1
fi

# ensure go installed
if ![[ command -v go ]] &>/dev/null; then
  echo "🚨 go >= 1.25 is required to run this script. please install it."
  exit 1
fi

# check if go >= 1.25
goversion="$(go version | awk '{print $3}' | sed 's/go//')"
if [[ "$goversion" != 1.25.* ]]; then
  echo "🚨 go >= 1.25 is required to run this script. please install it."
  exit 1
fi

# ensure npm installed
if ![[ command -v npm ]] &>/dev/null; then
  echo "🚨 node >= 24 is required to run this script. please install it."
  exit 1
fi

# check if node >= 24
nodeversion="$(node --version | sed 's/v//')"
if [[ "$nodeversion" != 24.* ]]; then
  echo "🚨 node >= 24 is required to run this script. please install it."
  exit 1
fi

# docker
echo "📦 installing docker tools"
brew install dockerfile-language-server &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed docker-langserver"
else
  echo "  🚨 failed to install docker-langserver"
fi
brew install hadolint &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed hadolint"
else
  echo "  🚨 failed to install hadolint"
fi

# docker compose
echo "📦 installing docker-compose tools"
brew install docker-compose-langserver &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed docker-compose-langserver"
else
  echo "  🚨 failed to install docker-compose-langserver"
fi

# go
echo "📦 installing golang tools"
go install golang.org/x/tools/gopls@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed gopls"
else
  echo "  🚨 failed to install gopls"
fi
go install golang.org/x/tools/cmd/goimports@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed goimports"
else
  echo "  🚨 failed to install goimports"
fi
go install github.com/segmentio/golines@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed golines"
else
  echo "  🚨 failed to golines"
fi
go install mvdan.cc/gofumpt@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed gofumpt"
else
  echo "  🚨 failed to install gofumpt"
fi
go install github.com/securego/gosec/v2/cmd/gosec@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed gosec"
else
  echo "  🚨 failed to install gosec"
fi
go install honnef.co/go/tools/cmd/staticcheck@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed staticcheck"
else
  echo "  🚨 failed to install staticcheck"
fi
go install github.com/mgechev/revive@latest &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed revive"
else
  echo "  🚨 failed to install revive"
fi

# lua
echo "📦 installing lua tools"
brew install lua-language-server &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed lua-language-server"
else
  echo "  🚨 failed to install lua-language-server"
fi
brew install stylua &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed stylua"
else
  echo "  🚨 failed to install stylua"
fi

# markdown
echo "📦 installing markdown tools"
brew install marksman &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed marksman"
else
  echo "  🚨 failed to install marksman"
fi
brew install markdownlint-cli2 &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed markdownlint-cli2"
else
  echo "  🚨 failed to install markdownlint-cli2"
fi
brew install markdown-toc &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed markdown-toc"
else
  echo "  🚨 failed to install markdown-toc"
fi

# prisma
echo "📦 installing prisma tools"
npm i -g @prisma/language-server &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed prisma-language-server"
else
  echo "  🚨 failed to install prisma-language-server"
fi

# python
echo "📦 installing python tools"
brew install basedpyright &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed basedpyright"
else
  echo "  🚨 failed to install basedpyright"
fi
brew install ruff &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed ruff"
else
  echo "  🚨 failed to install ruff"
fi

# sh
echo "📦 installing sh tools"
brew install shfmt &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed shfmt"
else
  echo "  🚨 failed to install shfmt"
fi

# sql
echo "📦 installing sql tools"
brew install sqlfluff &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed sqlfluff"
else
  echo "  🚨 failed to install sqlfluff"
fi

# tailwind
echo "📦 installing tailwind tools"
brew install tailwindcss-language-server &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed tailwindcss-language-server"
else
  echo "  🚨 failed to install tailwindcss-language-server"
fi

# terraform
echo "📦 installing terraform tools"
brew install hashicorp/tap/terraform-ls &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed terraform-ls"
else
  echo "  🚨 failed to install terraform-ls"
fi
brew install tflint &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed tflint"
else
  echo "  🚨 failed to install tflint"
fi

# tree-sitter
echo "📦 installing nvim tools"
brew install tree-sitter-cli &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed tree-sitter"
else
  echo "  🚨 failed to install tree-sitter"
fi

# yaml
echo "📦 installing yaml tools"
brew install yaml-language-server &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "  ✅ installed yaml-language-server"
else
  echo "  🚨 failed to install yaml-language-server"
fi
