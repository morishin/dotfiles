# dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup on a new machine

```sh
brew install chezmoi
git clone https://github.com/morishin/dotfiles.git ~/develop/dotfiles
chezmoi init --source ~/develop/dotfiles --apply
```

`chezmoi init` asks whether the machine is a work machine. On work machines,
the private [dotfiles-work](https://github.com/morishin/dotfiles-work)
submodule (`dotfiles-work/`) is initialized and its settings are loaded from
`.zshrc` and the git config. Personal machines leave the submodule empty and
simply skip them.

## Daily usage

```sh
chezmoi diff   # preview changes
chezmoi apply  # apply the source state to $HOME
```

Edit files in this repo (or via `chezmoi edit`), then `chezmoi apply`.
If you edited a deployed file directly (e.g. `~/.config/zsh/aliases.zsh`),
bring the change back with `chezmoi re-add`.
