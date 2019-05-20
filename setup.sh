#!/usr/bin/env bash
set -euo pipefail

# TODO: add ~/.local/bin to PATH
# TODO: add pre-path and post-path directories for PATH list additions
# TODO: add pre-ld-library-path and post-ld-library-path directories for
#       LD_LIBRARY_PATH list additions
# TODO: Move data dirs (GEM_HOME, GOHOME, node_modules, CARGO_HOME) to
#       XDG_DATA_HOME
# TODO: store configure, make, and make-install commands+times to bypass rebuild
#       of expensive build tasks

# TODO:
#   powerline (pip, git)
#   clang
#     llvm?
#   fzf (git)
#   wire
#   solarized
#     themes (git)
#     dircolors (git)
#   ssh agent canonicalize (git)
#   worktree (git)
#   gdb dashboard (git)
#   vagrant
#     libvirt
#     virtualbox
#     docker-compose

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
