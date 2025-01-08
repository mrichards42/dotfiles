# Based on https://github.com/oh-my-fish/plugin-aws/blob/master/completions/aws.fish
function __aws_complete
  COMP_SHELL=fish COMP_LINE=(commandline) aws_completer
end

if type -q aws_completer
  complete --command aws --no-files --arguments '(__aws_complete)'
end
