# dotfiles

macOS Dev Environment Setup — Alacritty, Chromium, Bitwarden, Docker, mise, Neovim, tmux, OpenCode, Antigravity, Oh My Zsh, Go, Rust, Node.js and Python.

## Installation

```bash
git clone https://github.com/fsiggor/dotfiles.git
cd dotfiles
cp .env.example .env   # fill in your personal data
chmod +x install.sh
./install.sh
```

Or remotely (requires manual `.env` setup afterwards):

```bash
curl -fsSL https://raw.githubusercontent.com/fsiggor/dotfiles/main/install.sh | bash
```

## Structure

```
config/
├── alacritty/alacritty.toml   # GPU-accelerated terminal
├── git/gitconfig              # aliases, editor, pull rebase
├── mise/config.toml           # Go, Node, Python, Rust versions
├── nvim/init.lua              # minimal Neovim config
├── tmux/tmux.conf             # prefix Ctrl-a, mouse, true color
└── zsh/zshrc                  # Oh My Zsh, aliases, brew, mise
```

The install script symlinks system paths (`~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig`, etc.) to this repo. Existing files are backed up as `.bak`.

## Personal config

Personal data (name, email, GPG key) lives in `.env` and is used to generate `~/.gitconfig.local`, which is included by the repo's `gitconfig`. This keeps the repo free of personal data.

## Tools installed

| Category      | Tools                                            |
|---------------|--------------------------------------------------|
| Terminal      | Alacritty, tmux, Oh My Zsh, JetBrains Mono Nerd Font |
| Editor        | Neovim                                           |
| Dev Tools     | Git, GitHub CLI, Docker, mise, OpenCode          |
| Languages     | Go, Rust, Node.js, Python (via mise)             |
| Apps          | Chromium, Bitwarden, Antigravity                 |
