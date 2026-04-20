#!/usr/bin/env bash
# ================================================================
#  Antigravity Superpowers Installer
#  https://github.com/Chuyn2k3/superpowers
#
#  One-command install (macOS / Linux):
#    curl -fsSL https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
#
#  Or after cloning:
#    bash install.sh
# ================================================================

set -e

REPO_URL="https://github.com/Chuyn2k3/superpowers"
REPO_ZIP="https://github.com/Chuyn2k3/superpowers/archive/refs/heads/main.zip"
SKILLS_DIR="$HOME/.gemini/antigravity/skills"
WORKFLOWS_DIR="$HOME/.gemini/antigravity/global_workflows"

# ── Colors ──────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
RESET='\033[0m'

# ── Helpers ──────────────────────────────────────────────────────
step()    { echo -e "${YELLOW}  ▶ $1${RESET}"; }
success() { echo -e "${GREEN}  ✔ $1${RESET}"; }
info()    { echo -e "${GRAY}  ℹ $1${RESET}"; }
fail()    { echo -e "${RED}  ✖ $1${RESET}"; exit 1; }

ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        info "Created directory: $1"
    fi
}

# ── Banner ───────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}  ║    🚀 Antigravity Superpowers Installer       ║${RESET}"
echo -e "${CYAN}  ║       https://github.com/Chuyn2k3/superpowers ║${RESET}"
echo -e "${CYAN}  ╚══════════════════════════════════════════════╝${RESET}"
echo ""

# ── Detect run mode ──────────────────────────────────────────────
# When piped via curl|bash, BASH_SOURCE[0] is empty or equals "bash"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"
IS_REMOTE=false

if [ -z "$SCRIPT_DIR" ] || [ ! -f "$SCRIPT_DIR/install.sh" ]; then
    IS_REMOTE=true
fi

# ── Remote mode: download from GitHub ────────────────────────────
if [ "$IS_REMOTE" = true ]; then
    step "Remote install detected — downloading from GitHub..."

    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT

    # Prefer git, fallback to curl/wget + zip
    if command -v git &>/dev/null; then
        step "Cloning repository with git..."
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null \
            && success "Repository cloned." \
            || { info "git clone failed, falling back to ZIP..."; USE_ZIP=true; }
    else
        USE_ZIP=true
    fi

    if [ "${USE_ZIP:-false}" = true ]; then
        step "Downloading repository as ZIP..."
        ZIP_PATH="$TEMP_DIR/superpowers.zip"

        if command -v curl &>/dev/null; then
            curl -fsSL "$REPO_ZIP" -o "$ZIP_PATH" || fail "curl download failed."
        elif command -v wget &>/dev/null; then
            wget -q "$REPO_ZIP" -O "$ZIP_PATH" || fail "wget download failed."
        else
            fail "Neither git, curl, nor wget found. Please install one of them."
        fi

        step "Extracting ZIP..."
        unzip -q "$ZIP_PATH" -d "$TEMP_DIR"

        # GitHub ZIP extracts to "superpowers-main/"
        EXTRACTED=$(find "$TEMP_DIR" -maxdepth 1 -mindepth 1 -type d | head -n 1)
        TEMP_DIR="$EXTRACTED"
        success "Download complete."
    fi

    SOURCE_SKILLS_DIR="$TEMP_DIR/skills"
    SOURCE_WORKFLOWS_DIR="$TEMP_DIR/global_workflows"
else
    # ── Local mode: running from cloned directory ─────────────────
    info "Local install mode (running from: $SCRIPT_DIR)"
    SOURCE_SKILLS_DIR="$SCRIPT_DIR/skills"
    SOURCE_WORKFLOWS_DIR="$SCRIPT_DIR/global_workflows"
fi

# ── Install skills ───────────────────────────────────────────────
echo ""
step "Installing skills to: $SKILLS_DIR"
ensure_dir "$SKILLS_DIR"

if [ -d "$SOURCE_SKILLS_DIR" ]; then
    cp -r "$SOURCE_SKILLS_DIR/." "$SKILLS_DIR/"
    success "Skills installed."
else
    fail "Skills directory not found at: $SOURCE_SKILLS_DIR"
fi

# ── Install global_workflows (if present) ────────────────────────
if [ -d "$SOURCE_WORKFLOWS_DIR" ]; then
    step "Installing global workflows to: $WORKFLOWS_DIR"
    ensure_dir "$WORKFLOWS_DIR"
    cp -r "$SOURCE_WORKFLOWS_DIR/." "$WORKFLOWS_DIR/"
    success "Global workflows installed."
else
    info "No global_workflows directory found — skipping."
fi

# ── Done ─────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}  ╔══════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}  ║  ✅  Installation complete!                   ║${RESET}"
echo -e "${GREEN}  ║                                               ║${RESET}"
echo -e "${GREEN}  ║  Skills → ~/.gemini/antigravity/skills        ║${RESET}"
echo -e "${GREEN}  ║                                               ║${RESET}"
echo -e "${GREEN}  ║  Antigravity will load these skills auto.     ║${RESET}"
echo -e "${GREEN}  ╚══════════════════════════════════════════════╝${RESET}"
echo ""
