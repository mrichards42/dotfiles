## -- Everthing else ----------------------------------------------------------

# Include files with leading dots in autocomplete
setopt glob_dots

# zmv for glob-based renaming
autoload -Uz zmv

# Quote urls when pasting (if necessary)
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# Escape characters when typing unquoted urls
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
