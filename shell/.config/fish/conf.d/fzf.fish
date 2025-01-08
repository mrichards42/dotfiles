set -l fzf_cmd $(command -v fzf)
set -l fzf_bindings $(path resolve "$fzf_cmd/../../shell/key-bindings.fish")

if test -n "$fzf_cmd" && test -e "$fzf_bindings"
  source $fzf_bindings
  fzf_key_bindings
end
