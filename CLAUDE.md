# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

macOS dotfiles repo. A single `install.sh` script installs all tools via Homebrew, symlinks config files from `config/` to their system paths, and generates `~/.gitconfig.local` from `.env` for personal data (name, email, GPG key).

## Key Commands

```bash
./install.sh          # Full setup — idempotent, safe to re-run
```

There is no build, lint, or test step.

## How Configs Are Deployed

`install.sh` symlinks each config to its system location. When editing configs, edit the repo copy — the symlink makes it live immediately.

| Repo path                        | Symlink target                        |
|----------------------------------|---------------------------------------|
| `config/alacritty/alacritty.toml`| `~/.config/alacritty/alacritty.toml`  |
| `config/tmux/tmux.conf`         | `~/.tmux.conf`                        |
| `config/nvim/init.lua`          | `~/.config/nvim/init.lua`             |
| `config/mise/config.toml`       | `~/.config/mise/config.toml`          |
| `config/git/gitconfig`          | `~/.gitconfig`                        |
| `config/zsh/zshrc`              | `~/.zshrc`                            |

## Personal Data

Personal info lives in `.env` (git-ignored). The install script uses it to generate `~/.gitconfig.local`, which `config/git/gitconfig` includes via `[include] path = ~/.gitconfig.local`. Never hardcode names, emails, or keys in tracked files.

## RTK (Rust Token Killer)

This environment uses `rtk` as a token-optimized CLI proxy. Shell commands like `git status` are automatically rewritten to `rtk git status` by a Claude Code hook. Use `rtk gain` to check token savings. See `~/.claude/RTK.md` for full details.
