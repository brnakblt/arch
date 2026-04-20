#!/bin/bash

print_header() {
    clear
    echo "=========================================="
    echo "   $1"
    echo "=========================================="
    echo ""
}

wait_for_keypress() {
    echo ""
    read -p ":: Press Enter to continue..."
}
