# zsh4humans sets WORDCHARS to empty which means a word is only [a-z0-9]
# Sometimes it's nice to consider only whitespace as the word delimiter. It
# provides some functions for that!

# Adding Ctrl+Alt versions of F,B,D,W for space-separated words
# Ctrl+F     = forward 1 char    (default)
# Alt+F      = forward 1 word    (default)
# Ctrl+Alt+F = forward 1 "zword"
z4h bindkey z4h-forward-zword        Ctrl+Option+F
z4h bindkey z4h-backward-zword       Ctrl+Option+B
z4h bindkey z4h-kill-zword           Ctrl+Option+D
z4h bindkey z4h-backward-kill-zword  Ctrl+Option+W


# -- zsh4humans defaults ------------------------------------------------------

z4h bindkey undo Ctrl+/   Shift+Tab # undo the last command line change
z4h bindkey redo Option+/           # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
# z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Replace z4h-cd-down. Instead of always popping up the fzf window, this checks
# to see if the last dir is a child of PWD and goes there if it is. This makes
# bouncing between parent and child directories faster.

function my-cd-down() {
  local candidate=${dirstack[1]#$PWD/}
  if [[ ! "$candidate" == */* ]]; then
    # based on z4h-cd-up
    builtin cd -q "$candidate" && -z4h-redraw-prompt
  else
    z4h-cd-down
  fi
}

zle -N my-cd-down
z4h bindkey my-cd-down    Shift+Down
