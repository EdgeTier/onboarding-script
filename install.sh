#!/bin/bash

# =============================================================================
# Mac Onboarding Script
# Installs standard work applications via Homebrew
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# -----------------------------------------------------------------------------
# Header
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "   Mac Onboarding - Application Installer"
echo "=============================================="
echo ""

# -----------------------------------------------------------------------------
# Check for macOS
# -----------------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is intended for macOS only."
    exit 1
fi

# -----------------------------------------------------------------------------
# Install Homebrew if not present
# -----------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    print_status "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi
    print_success "Homebrew installed successfully"
else
    print_success "Homebrew is already installed"
fi

# Update Homebrew
print_status "Updating Homebrew..."
brew update

# -----------------------------------------------------------------------------
# Define applications to install
# -----------------------------------------------------------------------------
# Homebrew Casks (GUI applications)
CASKS=(
    "notion"
    "slack"
    "chatgpt"
    "aldente"
    "linear-linear"
    "tailscale"
    "google-drive"
    "xmind"
    "whatsapp"
    "google-chrome"
    "rectangle"
    "iterm2"
    "visual-studio-code"
)

# Apps that need special handling
SPECIAL_APPS=(
    "hexnode-mdm"   # May require manual install or MDM deployment
    "copyclip"      # Mac App Store only
)

# -----------------------------------------------------------------------------
# Install Homebrew Casks
# -----------------------------------------------------------------------------
print_status "Installing applications via Homebrew..."
echo ""

for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &> /dev/null; then
        print_success "$cask is already installed"
    else
        print_status "Installing $cask..."
        if brew install --cask "$cask"; then
            print_success "$cask installed successfully"
        else
            print_warning "Failed to install $cask - may need manual installation"
        fi
    fi
done

# -----------------------------------------------------------------------------
# Install mas (Mac App Store CLI) for App Store apps
# -----------------------------------------------------------------------------
echo ""
print_status "Setting up Mac App Store CLI..."

if ! command -v mas &> /dev/null; then
    brew install mas
fi

# -----------------------------------------------------------------------------
# Handle Mac App Store apps
# -----------------------------------------------------------------------------
echo ""
print_status "Checking Mac App Store apps..."

# CopyClip - App Store ID: 595191960
# Note: User must be signed into the App Store
if mas list | grep -q "595191960"; then
    print_success "CopyClip is already installed"
else
    print_status "Installing CopyClip from Mac App Store..."
    if mas install 595191960 2>/dev/null; then
        print_success "CopyClip installed successfully"
    else
        print_warning "CopyClip requires manual install from the App Store"
        print_warning "  → Open App Store and search for 'CopyClip'"
    fi
fi

# -----------------------------------------------------------------------------
# Handle special cases
# -----------------------------------------------------------------------------
echo ""
print_status "Checking apps requiring manual installation..."

# Hexnode MDM - typically deployed via MDM or downloaded from company portal
print_warning "Hexnode MDM should be installed via your company's MDM portal"
print_warning "  → Contact IT or visit: https://www.hexnode.com/mobile-device-management/"

# -----------------------------------------------------------------------------
# Post-installation notes
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "   Installation Complete!"
echo "=============================================="
echo ""
echo "----------------------------------------------"
echo "   🆕 New to Mac? How to launch apps:"
echo "----------------------------------------------"
echo ""
echo "  Press ${YELLOW}Command (⌘) + Space${NC} to open Spotlight"
echo "  Then type the name of any app (e.g., 'Slack', 'Notion')"
echo "  Press Enter to launch it!"
echo ""
echo "----------------------------------------------"
print_status "Next steps:"
echo "  1. Sign into each application - most use your Google work credentials"
echo "  2. Configure Tailscale and connect to the company network"
echo "  3. Install Hexnode MDM from your company portal"
echo "  4. If CopyClip failed, install it from the Mac App Store"
echo ""
print_status "Some apps may require you to grant permissions in:"
echo "  System Settings → Privacy & Security"
echo ""
print_success "Happy onboarding! 🎉"
echo ""
