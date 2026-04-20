#!/usr/bin/env bash
# ================================================================
#  Antigravity Superpowers — Installer & Updater
#  https://github.com/Chuyn2k3/superpowers
#
#  INSTALL / UPDATE (macOS / Linux):
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
VERSION_FILE="$HOME/.gemini/antigravity/.superpowers-version"

# ── Colors ───────────────────────────────────────────────────────
CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m';  GRAY='\033[0;90m';  RESET='\033[0m'

# ── Helpers ──────────────────────────────────────────────────────
step()    { echo -e "${YELLOW}  ▶ $1${RESET}"; }
success() { echo -e "${GREEN}  ✔ $1${RESET}"; }
info()    { echo -e "${GRAY}  ℹ $1${RESET}"; }
fail()    { echo -e "${RED}  ✖ $1${RESET}"; exit 1; }

ensure_dir() {
    [ -d "$1" ] || { mkdir -p "$1"; info "Created: $1"; }
}

# ── Detect install vs update ─────────────────────────────────────
if [ -d "$SKILLS_DIR" ]; then
    ACTION="UPDATE"
    ACTION_LABEL="🔄 Updating"
else
    ACTION="INSTALL"
    ACTION_LABEL="🚀 Installing"
fi

# ── Banner ───────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}  ║   ${ACTION_LABEL} Antigravity Superpowers        ║${RESET}"
echo -e "${CYAN}  ║   https://github.com/Chuyn2k3/superpowers    ║${RESET}"
echo -e "${CYAN}  ╚══════════════════════════════════════════════╝${RESET}"
echo ""

# Show previous version if updating
if [ "$ACTION" = "UPDATE" ] && [ -f "$VERSION_FILE" ]; then
    PREV=$(cat "$VERSION_FILE")
    info "Current version: $PREV"
    echo ""
fi

# ── Detect run mode ──────────────────────────────────────────────
# When piped via curl|bash, BASH_SOURCE[0] is empty or "bash"
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ "${BASH_SOURCE[0]}" != "bash" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

IS_REMOTE=false
if [ -z "$SCRIPT_DIR" ] || [ ! -f "$SCRIPT_DIR/install.sh" ]; then
    IS_REMOTE=true
fi

# ── Remote mode: download from GitHub ────────────────────────────
if [ "$IS_REMOTE" = true ]; then
    step "Remote mode — downloading latest from GitHub..."

    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT

    USE_ZIP=false

    if command -v git &>/dev/null; then
        step "Cloning with git (depth=1)..."
        if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
            success "Cloned latest commit."
        else
            info "git clone failed, falling back to ZIP..."
            USE_ZIP=true
        fi
    else
        USE_ZIP=true
    fi

    if [ "$USE_ZIP" = true ]; then
        step "Downloading ZIP from GitHub..."
        ZIP_PATH="$TEMP_DIR/superpowers.zip"

        if command -v curl &>/dev/null; then
            curl -fsSL "$REPO_ZIP" -o "$ZIP_PATH" || fail "curl download failed."
        elif command -v wget &>/dev/null; then
            wget -q "$REPO_ZIP" -O "$ZIP_PATH" || fail "wget download failed."
        else
            fail "Neither git, curl, nor wget found. Please install one of them."
        fi

        step "Extracting..."
        unzip -q "$ZIP_PATH" -d "$TEMP_DIR"
        EXTRACTED="$(find "$TEMP_DIR" -maxdepth 1 -mindepth 1 -type d | head -n 1)"
        TEMP_DIR="$EXTRACTED"
        success "Downloaded and extracted."
    fi

    SOURCE_SKILLS="$TEMP_DIR/skills"
    SOURCE_WORKFLOWS="$TEMP_DIR/global_workflows"
    SOURCE_GIT_DIR="$TEMP_DIR"
else
    # ── Local mode ────────────────────────────────────────────────
    info "Local mode — running from: $SCRIPT_DIR"
    SOURCE_SKILLS="$SCRIPT_DIR/skills"
    SOURCE_WORKFLOWS="$SCRIPT_DIR/global_workflows"
    SOURCE_GIT_DIR="$SCRIPT_DIR"
fi

# ── Install / Update skills ──────────────────────────────────────
echo ""
SKILLS_LABEL=$([ "$ACTION" = "UPDATE" ] && echo "Updating skills" || echo "Installing skills")
step "$SKILLS_LABEL → $SKILLS_DIR"
ensure_dir "$SKILLS_DIR"

if [ -d "$SOURCE_SKILLS" ]; then
    cp -r "$SOURCE_SKILLS/." "$SKILLS_DIR/"
    success "Skills ${ACTION,,}d."
else
    fail "Skills directory not found at: $SOURCE_SKILLS"
fi

# ── Install / Update global_workflows ───────────────────────────
if [ -d "$SOURCE_WORKFLOWS" ]; then
    WF_LABEL=$([ "$ACTION" = "UPDATE" ] && echo "Updating workflows" || echo "Installing workflows")
    step "$WF_LABEL → $WORKFLOWS_DIR"
    ensure_dir "$WORKFLOWS_DIR"
    cp -r "$SOURCE_WORKFLOWS/." "$WORKFLOWS_DIR/"
    success "Global workflows ${ACTION,,}d."
else
    info "No global_workflows found — skipping."
fi

# ── Save version stamp ───────────────────────────────────────────
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
COMMIT=""
if command -v git &>/dev/null && [ -d "$SOURCE_GIT_DIR/.git" ]; then
    COMMIT=" ($(git -C "$SOURCE_GIT_DIR" rev-parse --short HEAD 2>/dev/null || true))"
fi
ensure_dir "$(dirname "$VERSION_FILE")"
echo "${ACTION} at ${TIMESTAMP}${COMMIT}" > "$VERSION_FILE"
info "Version stamp saved."

# ── Done ─────────────────────────────────────────────────────────
DONE_LABEL=$([ "$ACTION" = "UPDATE" ] && echo "✅ Update complete!" || echo "✅ Installation complete!")
echo ""
echo -e "${GREEN}  ╔══════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}  ║  ${DONE_LABEL}                         ║${RESET}"
echo -e "${GREEN}  ║                                              ║${RESET}"
echo -e "${GREEN}  ║  Skills → ~/.gemini/antigravity/skills       ║${RESET}"
echo -e "${GREEN}  ║                                              ║${RESET}"
echo -e "${GREEN}  ║  To update later, run the same command again ║${RESET}"
echo -e "${GREEN}  ╚══════════════════════════════════════════════╝${RESET}"
echo ""
