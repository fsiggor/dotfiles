#!/usr/bin/env bash
#
# macOS Dev Environment Setup
# Tools: Alacritty, Chromium, Bitwarden, Docker, mise, Neovim, tmux, OpenCode, SSH, GPG
#
# Usage:
#   chmod +x setup.sh && ./setup.sh
#
# Requirements:
#   - macOS (Apple Silicon or Intel)
#   - Internet connection
#   - Admin privileges (for some installs)

set -euo pipefail

# ──────────────────────────────────────────────
# Colors & helpers
# ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()    { echo -e "${RED}[FAIL]${NC}  $*"; exit 1; }

check_installed() {
  if command -v "$1" &>/dev/null; then
    success "$1 already installed ($(command -v "$1"))"
    return 0
  fi
  return 1
}

# ──────────────────────────────────────────────
# Pre-flight checks
# ──────────────────────────────────────────────
echo -e "\n${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║     macOS Dev Environment Setup          ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${NC}\n"

[[ "$(uname)" == "Darwin" ]] || fail "This script is for macOS only."

# ──────────────────────────────────────────────
# 1. Homebrew
# ──────────────────────────────────────────────
info "Checking Homebrew..."
if ! check_installed brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
  fi
  success "Homebrew installed"
fi

brew update

# ──────────────────────────────────────────────
# 2. Alacritty
# ──────────────────────────────────────────────
info "Checking Alacritty..."
if ! brew list --cask alacritty &>/dev/null; then
  info "Installing Alacritty..."
  brew install --cask alacritty

  # Create default config directory
  mkdir -p "$HOME/.config/alacritty"
  if [[ ! -f "$HOME/.config/alacritty/alacritty.toml" ]]; then
    cat > "$HOME/.config/alacritty/alacritty.toml" <<'TOML'
# Alacritty config — customize as needed
# Docs: https://alacritty.org/config-alacritty.html

[font]
size = 14.0

[font.normal]
family = "JetBrains Mono"
style = "Regular"

[window]
padding = { x = 8, y = 8 }
decorations = "Buttonless"
opacity = 0.96
TOML
    success "Created default Alacritty config at ~/.config/alacritty/alacritty.toml"
  fi
  success "Alacritty installed"
else
  success "Alacritty already installed"
fi

# ──────────────────────────────────────────────
# 3. Chromium
# ──────────────────────────────────────────────
info "Checking Chromium..."
if ! brew list --cask chromium &>/dev/null; then
  info "Installing Chromium..."
  brew install --cask chromium

  # First launch: macOS may block it since it's unsigned
  warn "On first launch, macOS may block Chromium."
  warn "Go to System Settings > Privacy & Security > click 'Open Anyway'."
  success "Chromium installed"
else
  success "Chromium already installed"
fi

# ──────────────────────────────────────────────
# 4. Bitwarden (password manager)
# ──────────────────────────────────────────────
info "Checking Bitwarden..."
if ! brew list --cask bitwarden &>/dev/null; then
  info "Installing Bitwarden..."
  brew install --cask bitwarden
  success "Bitwarden installed"
else
  success "Bitwarden already installed"
fi

# ──────────────────────────────────────────────
# 5. Docker Desktop
# ──────────────────────────────────────────────
info "Checking Docker..."
if ! brew list --cask docker &>/dev/null; then
  info "Installing Docker Desktop..."
  brew install --cask docker
  warn "Docker Desktop installed — open it once to complete setup and accept the license."
  success "Docker Desktop installed"
else
  success "Docker Desktop already installed"
fi

# ──────────────────────────────────────────────
# 6. mise (runtime/tool version manager)
# ──────────────────────────────────────────────
info "Checking mise..."
if ! check_installed mise; then
  info "Installing mise..."
  brew install mise

  # Activate mise in bash
  if ! grep -q 'mise activate' "$HOME/.bash_profile" 2>/dev/null; then
    echo 'eval "$(mise activate bash)"' >> "$HOME/.bash_profile"
    info "Added mise activation to ~/.bash_profile"
  fi
  eval "$(mise activate bash)"
  success "mise installed"
fi

# ──────────────────────────────────────────────
# 7. Neovim
# ──────────────────────────────────────────────
info "Checking Neovim..."
if ! check_installed nvim; then
  info "Installing Neovim..."
  brew install neovim
  mkdir -p "$HOME/.config/nvim"
  success "Neovim installed"
else
  success "Neovim already installed"
fi

# ──────────────────────────────────────────────
# 8. tmux
# ──────────────────────────────────────────────
info "Checking tmux..."
if ! check_installed tmux; then
  info "Installing tmux..."
  brew install tmux

  # Sensible defaults
  if [[ ! -f "$HOME/.tmux.conf" ]]; then
    cat > "$HOME/.tmux.conf" <<'CONF'
# Remap prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse
set -g mouse on

# Start windows/panes at 1
set -g base-index 1
setw -g pane-base-index 1

# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",alacritty:RGB"

# Faster escape
set -sg escape-time 10

# Increase history
set -g history-limit 50000

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"
CONF
    success "Created default tmux config at ~/.tmux.conf"
  fi
  success "tmux installed"
fi

# ──────────────────────────────────────────────
# 9. OpenCode (AI coding agent)
# ──────────────────────────────────────────────
info "Checking OpenCode..."
if ! check_installed opencode; then
  info "Installing OpenCode via Homebrew tap..."
  brew install anomalyco/tap/opencode
  success "OpenCode installed"
else
  success "OpenCode already installed"
fi

# ──────────────────────────────────────────────
# 10. SSH — generate key if none exists
# ──────────────────────────────────────────────
info "Checking SSH setup..."
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY" ]]; then
  success "SSH key already exists at $SSH_KEY"
else
  info "Generating Ed25519 SSH key..."
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  read -rp "Email for SSH key (blank to skip): " ssh_email
  if [[ -n "$ssh_email" ]]; then
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_KEY"

    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"

    # Configure macOS Keychain integration
    if [[ ! -f "$HOME/.ssh/config" ]]; then
      cat > "$HOME/.ssh/config" <<'SSH_CONF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
SSH_CONF
    fi

    ssh-add --apple-use-keychain "$SSH_KEY"
    success "SSH key generated. Public key:"
    echo -e "${YELLOW}"
    cat "${SSH_KEY}.pub"
    echo -e "${NC}"
  else
    warn "Skipped SSH key generation."
  fi
fi

# ──────────────────────────────────────────────
# 11. GPG — install and generate key
# ──────────────────────────────────────────────
info "Checking GPG..."
if ! check_installed gpg; then
  info "Installing GnuPG..."
  brew install gnupg
  success "GnuPG installed"
else
  success "GnuPG already installed"
fi

# Install pinentry-mac for passphrase prompts
if ! brew list pinentry-mac &>/dev/null; then
  info "Installing pinentry-mac..."
  brew install pinentry-mac
fi

# Configure gpg-agent to use pinentry-mac
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
PINENTRY_PATH="$(which pinentry-mac 2>/dev/null || echo "/opt/homebrew/bin/pinentry-mac")"
if ! grep -q "pinentry-program" "$HOME/.gnupg/gpg-agent.conf" 2>/dev/null; then
  echo "pinentry-program $PINENTRY_PATH" >> "$HOME/.gnupg/gpg-agent.conf"
  gpgconf --kill gpg-agent 2>/dev/null || true
  info "Configured gpg-agent with pinentry-mac"
fi

# Check for existing GPG keys
if gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -q "sec"; then
  success "GPG key already exists"
  gpg --list-secret-keys --keyid-format=long 2>/dev/null
else
  read -rp "Generate a new GPG key? (y/N): " gen_gpg
  if [[ "$gen_gpg" =~ ^[Yy]$ ]]; then
    info "Launching GPG key generation (select RSA/RSA 4096 for Git signing)..."
    gpg --full-generate-key

    # Show the key ID for Git config
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep "sec" | head -1 | awk '{print $2}' | cut -d'/' -f2)
    if [[ -n "$GPG_KEY_ID" ]]; then
      success "GPG key generated: $GPG_KEY_ID"
      info "To configure Git commit signing, run:"
      echo -e "${BOLD}  git config --global user.signingkey $GPG_KEY_ID${NC}"
      echo -e "${BOLD}  git config --global commit.gpgsign true${NC}"
      echo ""
      info "To export your public key for GitHub:"
      echo -e "${BOLD}  gpg --armor --export $GPG_KEY_ID${NC}"
    fi
  else
    warn "Skipped GPG key generation."
  fi
fi

# ──────────────────────────────────────────────
# Bonus: Useful fonts
# ──────────────────────────────────────────────
info "Checking Nerd Font (JetBrains Mono)..."
if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
  info "Installing JetBrains Mono Nerd Font..."
  brew install --cask font-jetbrains-mono-nerd-font
  success "JetBrains Mono Nerd Font installed"
else
  success "JetBrains Mono Nerd Font already installed"
fi

# ──────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║           Setup Complete!                 ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Installed tools:${NC}"
echo "  • Alacritty    — GPU-accelerated terminal"
echo "  • Chromium     — Open-source browser"
echo "  • Bitwarden    — Password manager"
echo "  • Docker       — Container runtime"
echo "  • mise         — Runtime version manager"
echo "  • Neovim       — Text editor"
echo "  • tmux         — Terminal multiplexer"
echo "  • OpenCode     — AI coding agent"
echo "  • SSH          — Key-based auth"
echo "  • GPG          — Commit signing"
echo "  • JetBrains Mono Nerd Font"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart your terminal (or run: source ~/.bash_profile)"
echo "  2. Open Docker Desktop to complete its setup"
echo "  3. Add your SSH public key to GitHub: https://github.com/settings/keys"
echo "  4. Add your GPG public key to GitHub: https://github.com/settings/gpg"
echo "  5. Configure OpenCode: opencode auth login"
echo ""
