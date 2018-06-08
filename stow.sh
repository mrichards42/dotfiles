#!/usr/bin/env bash
STOW='./stow/.local/bin/stow'

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
  echo "Testing: stow -nv ${PKGS[@]}"
  if $STOW -nv "${PKGS[@]}"; then
    echo "Running: stow ${PKGS[@]}"
    $STOW "${PKGS[@]}"
  else
    echo
    echo "!! Errors detected !!"
    echo "Please remove existing files, or stow individual packages."
  fi
else
  exec $STOW "$@"
fi
