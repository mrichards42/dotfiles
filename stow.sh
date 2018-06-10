#!/usr/bin/env bash
STOW='./stow/.local/code/stow/bin/stow'

if [[ "$1" = "--all" ]]; then
  # Find all directories that are not hidden, and exclude 'stow'
  PKGS=( $( find . \
    -type d \
    -maxdepth 1 \
    ! -name '.*' \
    ! -name 'stow' \
    -exec basename {} ';'
  ) )
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
    $STOW -vv "${PKGS[@]}"
  else
    echo
    echo "!! Errors detected !!"
    echo "Please remove existing files, or stow individual packages."
  fi
else
  exec $STOW -vv "$@"
fi
