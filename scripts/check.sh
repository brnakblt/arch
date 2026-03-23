#!/bin/bash

# Syntax Check Script

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

echo ":: Checking syntax of main installer..."
bash -n "$SCRIPT_DIR/install.sh"
if [ $? -eq 0 ]; then
    echo "   [OK] install.sh"
else
    echo "   [FAIL] install.sh"
fi

echo ":: Checking syntax of all selector scripts..."
for script in "$SCRIPT_DIR/scripts/"*.sh; do
    bash -n "$script"
    if [ $? -eq 0 ]; then
        echo "   [OK] $(basename "$script")"
    else
        echo "   [FAIL] $(basename "$script")"
    fi
done

echo ":: Syntax check complete."
