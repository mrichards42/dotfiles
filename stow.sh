#!/usr/bin/env bash
set -eo pipefail

STOW='./stow/bin/stow'

if [[ "$1" = "--all" ]]; then
  # Find all directories that are not hidden, and exclude 'stow'
  PKGS=( $( find . \
    -type d \
    -maxdepth 1 \
    ! -name '.*' \
    ! -name 'stow' \
    ! -name 'mac-*' \
    ! -name 'linux-*' \
    -exec basename {} ';'
  ) )
  if [[ -n "$2" ]]; then
    exec $STOW -vv "${PKGS[@]}" "${@:2}"
  else
    # Test and execute, if successful
    echo '###########'
    echo '# Testing #'
    echo '###########'
    echo "# stow -nv ${PKGS[@]}"
    if $STOW -nv "${PKGS[@]}"; then
      echo 'No conflicts detected'
      echo
      echo '###########'
      echo '# Running #'
      echo '###########'
      echo "# stow -vv ${PKGS[@]}"
      echo "# stow -vv ${PKGS[@]} ${@:2}"
      exec $STOW -vv "${PKGS[@]}" "${@:2}"
    else
      echo
      echo "!! Errors detected !!"
      echo "Please remove existing files, or stow individual packages."
    fi
  fi
else
  exec $STOW -vv "$@"
fi
