#!/bin/bash
echo "=============================================="
echo "Installing Antigravity Superpower Skills..."
echo "=============================================="

SKILLS_DIR="$HOME/.gemini/antigravity/skills"

if [ ! -d "$SKILLS_DIR" ]; then
    echo "Creating Antigravity skills directory at $SKILLS_DIR..."
    mkdir -p "$SKILLS_DIR"
fi

echo "Copying skills..."
cp -r "skills/"* "$SKILLS_DIR/"

if [ $? -eq 0 ]; then
    echo ""
    echo "[SUCCESS] Skills have been installed to $SKILLS_DIR"
    echo "Note: Antigravity will automatically load these skills."
else
    echo ""
    echo "[ERROR] Failed to copy skills."
fi
