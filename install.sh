#!/usr/bin/env bash
#
# macOS Dev Environment Setup
# Tools: Git, GitHub CLI, Alacritty, Chromium, Bitwarden, Docker, mise, Neovim, tmux,
#        OpenCode, Antigravity, Oh My Zsh, Go, Rust, Node.js, Python
#
# Usage:
#   chmod +x install.sh && ./install.sh
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

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

check_installed() {
  if command -v "$1" &>/dev/null; then
    success "$1 already installed ($(command -v "$1"))"
    return 0
  fi
  return 1
}

# Creates a symlink: link_path -> target (from repo)
# Backs up existing files before overwriting
link_config() {
  local target="$1"
  local link_path="$2"

  mkdir -p "$(dirname "$link_path")"

  if [[ -L "$link_path" ]]; then
    rm "$link_path"
  elif [[ -f "$link_path" || -d "$link_path" ]]; then
    mv "$link_path" "${link_path}.bak"
    warn "Backed up existing $(basename "$link_path") to ${link_path}.bak"
  fi

  ln -s "$target" "$link_path"
  success "Linked $(basename "$link_path") -> $target"
}

# ──────────────────────────────────────────────
# Pre-flight checks
# ──────────────────────────────────────────────
echo -e "\n${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║     macOS Dev Environment Setup          ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${NC}\n"

[[ "$(uname)" == "Darwin" ]] || fail "This script is for macOS only."
info "Dotfiles repo: $DOTFILES_DIR"

# ──────────────────────────────────────────────
# Load environment variables
# ──────────────────────────────────────────────
if [[ -f "$DOTFILES_DIR/.env" ]]; then
  source "$DOTFILES_DIR/.env"
  success "Loaded .env"
else
  warn ".env not found — copying from .env.example"
  cp "$DOTFILES_DIR/.env.example" "$DOTFILES_DIR/.env"
  info "Edit $DOTFILES_DIR/.env with your personal data, then re-run the script."
  fail "Setup aborted — configure .env first."
fi

# ──────────────────────────────────────────────
# 1. Homebrew
# ──────────────────────────────────────────────
info "Checking Homebrew..."
if ! check_installed brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
  fi
  success "Homebrew installed"
fi

brew update

# ──────────────────────────────────────────────
# 2. Git
# ──────────────────────────────────────────────
info "Checking Git..."
if ! check_installed git; then
  info "Installing Git..."
  brew install git
  success "Git installed"
fi

# ──────────────────────────────────────────────
# 3. GitHub CLI (gh)
# ──────────────────────────────────────────────
info "Checking GitHub CLI..."
if ! check_installed gh; then
  info "Installing GitHub CLI..."
  brew install gh
  success "GitHub CLI installed"
else
  success "GitHub CLI already installed"
fi

# ──────────────────────────────────────────────
# 4. Alacritty
# ──────────────────────────────────────────────
info "Checking Alacritty..."
if ! brew list --cask alacritty &>/dev/null; then
  info "Installing Alacritty..."
  brew install --cask alacritty
  success "Alacritty installed"
else
  success "Alacritty already installed"
fi

# ──────────────────────────────────────────────
# 5. Chromium
# ──────────────────────────────────────────────
info "Checking Chromium..."
if ! brew list --cask chromium &>/dev/null; then
  info "Installing Chromium..."
  brew install --cask chromium
  warn "On first launch, macOS may block Chromium."
  warn "Go to System Settings > Privacy & Security > click 'Open Anyway'."
  success "Chromium installed"
else
  success "Chromium already installed"
fi

# ──────────────────────────────────────────────
# 6. Bitwarden (password manager)
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
# 7. Docker Desktop
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
# 8. mise (runtime/tool version manager)
# ──────────────────────────────────────────────
info "Checking mise..."
if ! check_installed mise; then
  info "Installing mise..."
  brew install mise
  eval "$(mise activate bash)"
  success "mise installed"
fi

# ──────────────────────────────────────────────
# 9. Neovim
# ──────────────────────────────────────────────
info "Checking Neovim..."
if ! check_installed nvim; then
  info "Installing Neovim..."
  brew install neovim
  success "Neovim installed"
else
  success "Neovim already installed"
fi

# ──────────────────────────────────────────────
# 10. tmux
# ──────────────────────────────────────────────
info "Checking tmux..."
if ! check_installed tmux; then
  info "Installing tmux..."
  brew install tmux
  success "tmux installed"
fi

# ──────────────────────────────────────────────
# 11. OpenCode (AI coding agent)
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
# 12. Antigravity (Google Cloud IDE)
# ──────────────────────────────────────────────
info "Checking Antigravity..."
if ! brew list --cask antigravity &>/dev/null; then
  info "Installing Antigravity..."
  brew install --cask antigravity
  success "Antigravity installed"
else
  success "Antigravity already installed"
fi

# ──────────────────────────────────────────────
# 13. Oh My Zsh
# ──────────────────────────────────────────────
info "Checking Oh My Zsh..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  success "Oh My Zsh already installed"
else
  info "Installing Oh My Zsh (unattended)..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed"
fi

# Spaceship theme — https://spaceship-prompt.sh/
info "Checking Spaceship theme..."
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
if [[ -d "$SPACESHIP_DIR" ]]; then
  success "Spaceship theme already installed"
else
  info "Installing Spaceship theme..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
  ln -sf "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
  success "Spaceship theme installed"
fi

# zsh-autosuggestions plugin — https://github.com/zsh-users/zsh-autosuggestions
info "Checking zsh-autosuggestions..."
ZSH_AUTOSUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [[ -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
  success "zsh-autosuggestions already installed"
else
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGEST_DIR"
  success "zsh-autosuggestions installed"
fi

# zsh-syntax-highlighting plugin — https://github.com/zsh-users/zsh-syntax-highlighting
info "Checking zsh-syntax-highlighting..."
ZSH_SYNTAX_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [[ -d "$ZSH_SYNTAX_DIR" ]]; then
  success "zsh-syntax-highlighting already installed"
else
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
  success "zsh-syntax-highlighting installed"
fi

# ──────────────────────────────────────────────
# 14. Fonts
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
# 15. Symlink configs from dotfiles repo
# ──────────────────────────────────────────────
info "Linking configuration files from dotfiles repo..."

link_config "$DOTFILES_DIR/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_config "$DOTFILES_DIR/config/tmux/tmux.conf"           "$HOME/.tmux.conf"
link_config "$DOTFILES_DIR/config/nvim/init.lua"            "$HOME/.config/nvim/init.lua"
link_config "$DOTFILES_DIR/config/mise/config.toml"         "$HOME/.config/mise/config.toml"
link_config "$DOTFILES_DIR/config/git/gitconfig"            "$HOME/.gitconfig"
link_config "$DOTFILES_DIR/config/zsh/zshrc"                "$HOME/.zshrc"

# Generate ~/.gitconfig.local from env vars (personal data stays out of the repo)
info "Generating ~/.gitconfig.local from .env..."
cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = ${GIT_USER_NAME}
	email = ${GIT_USER_EMAIL}
EOF

if [[ -n "${GIT_SIGNING_KEY:-}" ]]; then
  cat >> "$HOME/.gitconfig.local" <<EOF
	signingkey = ${GIT_SIGNING_KEY}

[commit]
	gpgsign = true
EOF
fi
success "Created ~/.gitconfig.local"

# ──────────────────────────────────────────────
# 16. Languages via mise (Go, Rust, Node.js, Python)
# ──────────────────────────────────────────────
info "Installing global languages via mise..."
eval "$(mise activate bash)"

for lang in go rust node python; do
  if mise where "$lang" &>/dev/null; then
    success "$lang already installed via mise"
  else
    info "Installing $lang via mise..."
    mise use --global "$lang@latest"
    success "$lang installed via mise"
  fi
done

# ──────────────────────────────────────────────
# Auto-reload configs
# ──────────────────────────────────────────────
info "Reloading configurations..."

if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null && success "tmux config reloaded" || true
fi

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
  success "mise activated for current session"
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
echo "  • Git          — Version control"
echo "  • GitHub CLI   — GitHub from the terminal (gh)"
echo "  • Alacritty    — GPU-accelerated terminal"
echo "  • Chromium     — Open-source browser"
echo "  • Bitwarden    — Password manager"
echo "  • Docker       — Container runtime"
echo "  • mise         — Runtime version manager"
echo "  • Neovim       — Text editor"
echo "  • tmux         — Terminal multiplexer"
echo "  • OpenCode     — AI coding agent"
echo "  • Antigravity  — Google Cloud IDE"
echo "  • Oh My Zsh    — Zsh framework (+ Spaceship theme, autosuggestions, syntax highlighting)"
echo "  • JetBrains Mono Nerd Font"
echo ""
echo -e "${GREEN}Languages (via mise):${NC}"
echo "  • Go, Rust, Node.js, Python"
echo ""
echo -e "${GREEN}Symlinked configs:${NC}"
echo "  • ~/.config/alacritty/alacritty.toml"
echo "  • ~/.config/nvim/init.lua"
echo "  • ~/.config/mise/config.toml"
echo "  • ~/.tmux.conf"
echo "  • ~/.gitconfig"
echo "  • ~/.zshrc"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Open Docker Desktop to complete its setup"
echo "  2. Configure OpenCode: opencode auth login"
echo "  3. Authenticate GitHub CLI: gh auth login"
echo ""
echo -e "${GREEN}Auto-reloaded:${NC} tmux, Homebrew env, mise"
echo ""

# Replace current process with a fresh zsh session (loads ~/.zshrc automatically)
info "Launching a new zsh session with all configs loaded..."
exec zsh -l
