# Setup

## Shared dotfiles

```bash
$ git clone git@github.com:mrichards42/dotfiles ~/dotfiles
$ cd ~/dotfiles

# For all files
$ ./stow.sh --all

# Or for individual packages
$ ./stow.sh nvim tmux shell
```

`./stow.sh` wraps a copy of [GNU Stow][stow], which requires only `perl`. Stow
is **not** installed when running `./stow.sh --all`, so if you want that
installed as well, run `./stow.sh stow`, or better yet, install using homebrew
or another package manager.

## Mac

Install homebrew, then

```bash
brew bundle install --file ./Brewfile
```

 [stow]: https://metacpan.org/pod/distribution/Stow/bin/stow
