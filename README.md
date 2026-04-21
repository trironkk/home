# home

Personal dotfiles, deployed with [GNU stow](https://www.gnu.org/software/stow/).

## Layout

```
stows/
  autorandr/  # i3 reload on display switch
  bash/       # minimal bash (fallback shell)
  git/        # git config
  jq/         # jq helpers
  nvim/       # neovim (vim.pack + LSP)
  tmux/       # tmux + catppuccin
  tools/      # json2yaml / yaml2json
  zsh/        # primary shell
```

## Install

```shell
git clone --recursive https://github.com/trironkk/home ~/local/github.com/trironkk/home
make -C ~/local/github.com/trironkk/home
```

## Targets

- `make init` — apt packages
- `make stow` — symlink configs into `$HOME`
- `make unstow` — remove symlinks
- `make install-neovim` — build nightly neovim from source
