#!/usr/bin/env bash
set -euo pipefail

# TODO: add ~/.local/bin to PATH
# TODO: change dependency directory structure:
#       //PROJECT/RELEASE/{source,build,install}
# TODO: Consistencize task names. Follow GCC's example
# TODO: Move data dirs (GOHOME, nomde_modules, CARGO_HOME) to XDG_DATA_HOME
# TODO: store configure, make, and make-install commands+times to bypass rebuild
#       of expensive build tasks
# TODO: symlink ~/.gem to ~/.local/share/gem

# TODO:
#   tmux
#     powerline (git)
#     tpm (git)
#   clang
#     clang-format
#   llvm?
#   bazel
#     buildifier (go)
#     buildozer (pip)
#   fzf (git)
#   dev tools
#     ssh agent canonicalize
#     worktree
#     fd (rust)
#     rg (rust)
#     gdb dashboard
#     solarized
#       themes (git)
#       dircolors (git)
#     web tools
#       sass (ruby)
#       rails (ruby)
#     vagrant (ruby)
#       libvirt
#       virtualbox
#       docker-compose
#     markdown
#       grip (apt)
#       remark-cli (npm)
#     gdbgui (pip)
#     "linux-image-$kernel_version"
#     "linux-headers-$kernel_version"
#   alacritty

function main() {
  if [ "$(id --user)" -eq 0 ]; then
    echo This script should not be run as root. Exiting. >&2
    exit 1
  fi

  if [ -z "$(which apt-add-repository)" ]; then
    sudo apt-get update
    sudo apt-get install --assume-yes software-properties-common
  fi

  if ! apt-cache policy ansible &>/dev/null; then
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get update
  fi

  if [ -z "$(which ansible)" ]; then
    sudo apt-get install --assume-yes ansible
  fi

  ansible-playbook playbook.yaml --ask-become-pass "$@"
}

function install_user_tools_apt() {
  sudo apt-get install --assume-yes \
    etckeeper \
    git-core
}

main "$@"
