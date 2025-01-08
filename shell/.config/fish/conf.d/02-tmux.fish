# https://github.com/budimanjojo/tmux.fish/blob/53846e9ae8530cc0d33b9337d3c333de6c00e170/conf.d/tmux.fish#L75C1-L75C48
if status is-interactive && ! fish_is_root_user
  if type -q tmux && test -z $TMUX
    tmux new -As0
  end
end
