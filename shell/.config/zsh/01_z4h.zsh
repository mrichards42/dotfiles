## -- zsh4humans settings -----------------------------------------------------

# Documentation is rather sparse -- this is largely based on the original
# .zshrc that z4h provides, but there is a little more info at
# https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Don't use homebrew for command not found since it's very slow.
if [[ -v commands[brew] ]]; then
  command_not_found_handler() { echo "command not found: $*"; }
fi

# Periodic auto-update on Zsh startup: 'ask' or 'no'. Run `z4h update` to
# update manually.
zstyle ':z4h:' auto-update 'no'

# Start tmux if not already in tmux.
zstyle ':z4h:' start-tmux command tmux -u new -A -D

# Leave prompt at the top
zstyle ':z4h:' prompt-at-bottom  'no'

# Keyboard type: 'mac' or 'pc'.
if [[ "$OSTYPE" == darwin* ]]; then
  zstyle ':z4h:bindkey' keyboard 'mac'
else
  zstyle ':z4h:bindkey' keyboard 'pc'
fi

# What forward-one (i.e. right arrow) does in autosuggestion, either 'accept'
# (the whole line) or 'partial-accept' (just the one character).
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv' enable 'no'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over SSH ('*'
# for all hosts, or list them separately)
zstyle ':z4h:ssh:*'          enable 'no'

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return
