#!/bin/bash
# SpecLeap Installer
# Wrapper that runs the full setup.sh

set -e

# Check if setup.sh exists
if [ ! -f "setup.sh" ]; then
    echo "❌ Error: setup.sh not found"
    exit 1
fi

# Run setup.sh (which handles everything: language, tokens, skills, etc.)
bash setup.sh
