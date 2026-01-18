# Mac Onboarding Script

Automated setup script for new employee Mac laptops. Installs all standard work applications in one command.

## Quick Start

Open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/edgetier/onboarding-script/main/install.sh)"
```

> **Note:** Replace `YOUR_ORG` with your GitHub organization name.

## What Gets Installed

| Application | Installation Method |
|-------------|---------------------|
| Notion | Homebrew Cask |
| Slack | Homebrew Cask |
| ChatGPT | Homebrew Cask |
| AlDente | Homebrew Cask |
| Linear | Homebrew Cask |
| Tailscale | Homebrew Cask |
| Google Drive | Homebrew Cask |
| Xmind | Homebrew Cask |
| WhatsApp | Homebrew Cask |
| Google Chrome | Homebrew Cask |
| Rectangle | Homebrew Cask |
| iTerm2 | Homebrew Cask |
| VS Code | Homebrew Cask |
| CopyClip | Mac App Store |
| Hexnode MDM | Manual (see below) |

## Prerequisites

- macOS 11 (Big Sur) or later
- Admin access on the Mac
- Signed into the Mac App Store (for CopyClip)

## Manual Steps Required

### Hexnode MDM
Hexnode MDM should be installed through your company's MDM enrollment process. Contact IT for instructions.

### CopyClip
If the automatic install fails (requires App Store sign-in), install manually:
1. Open the App Store
2. Search for "CopyClip"
3. Click Install

## Post-Installation

### New to Mac?

To launch any installed app, press **⌘ Command + Space** to open Spotlight, then type the app name (e.g., "Slack" or "Notion") and press Enter.

### Sign In

Most apps use **Google Sign-In** with your work credentials. When you see "Sign in with Google" or "Continue with Google", use your company email.

### Other Setup

1. **Grant Permissions** - Some apps need accessibility or screen recording permissions. Go to System Settings → Privacy & Security
2. **Tailscale** - Connect to the company VPN network
3. **Rectangle** - Grant accessibility permissions when prompted

## For IT Admins

### Customizing the App List

Edit the `CASKS` array in `install.sh` to add or remove applications:

```bash
CASKS=(
    "notion"
    "slack"
    # Add more casks here
)
```

Find available casks at [formulae.brew.sh/cask](https://formulae.brew.sh/cask/).

### Security Considerations

For security-conscious organizations, instead of piping to bash, instruct users to:

```bash
# Download the script first
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/mac-onboarding/main/install.sh -o install.sh

# Review it
cat install.sh

# Run it
chmod +x install.sh
./install.sh
```

### Private Repository

If your repo is private, users will need to authenticate. Consider:
- Using a GitHub personal access token
- Hosting the script on your internal network
- Using GitHub Enterprise

## Troubleshooting

**"Homebrew installation failed"**
- Ensure you have admin rights
- Check your internet connection
- Try running `xcode-select --install` first

**"App already exists"**
- The script is idempotent and skips already-installed apps

**"Permission denied"**
- Run: `chmod +x install.sh` then `./install.sh`

## License

Internal use only.
