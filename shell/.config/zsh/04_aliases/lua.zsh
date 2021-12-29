if command -v luajit &> /dev/null && ! command -v lua &> /dev/null; then
  if command -v rlwrap &> /dev/null; then
    alias lua='rlwrap luajit'
  else
    alias lua=luajit
  fi
fi

if command -v fennel &> /dev/null && command -v rlwrap &> /dev/null; then
  alias fennel='rlwrap fennel'
fi
