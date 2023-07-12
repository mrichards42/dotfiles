# Powerline10k overrides. I'm leaving the auto-generated ~/.p10k.zsh alone in
# case I want to reconfigure (using `p10k configure`).

# Show error code output on the right side (the default config only shows this
# when the process exited due to a signal).
typeset -g POWERLEVEL9K_STATUS_ERROR=true

# No need for hot reloading
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

# Add battery, but only show when it's low
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(battery) # after the right side newline
typeset -g POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD=20

# Always show aws profile
unset POWERLEVEL9K_AWS_SHOW_ON_COMMAND
