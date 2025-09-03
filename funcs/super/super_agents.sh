#!/bin/bash

# Kitty Multi-Agent Claude Setup
# Equivalent to the Neovim Super command

# Check if remote control is enabled
if ! kitty @ ls >/dev/null 2>&1; then
    echo "Kitty remote control is not enabled. Attempting to enable it..."

    # Try to enable remote control via escape sequence
    printf '\033]1337;SetUserVar=allow_remote_control=yes\033\\'

    # Wait a moment and test again
    sleep 1

    if ! kitty @ ls >/dev/null 2>&1; then
        echo "Error: Could not enable remote control automatically."
        echo "Please enable remote control in kitty.conf by setting:"
        echo "  allow_remote_control yes"
        echo "Then restart Kitty and try again."
        exit 1
    fi

    echo "Remote control enabled successfully!"
fi

# Read the super_mode.md prompt file
PROMPT_FILE="$HOME/.config/fish/funcs/super/prompts/super_mode.md"
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "Error: Could not find $PROMPT_FILE"
    exit 1
fi

PROMPT_CONTENT=$(cat "$PROMPT_FILE")

# Role labels
ROLES=("TECH LEAD" "QA" "ML ENG" "INTERN")


# Launch agents in new tabs
for role in "${ROLES[@]}"; do
    # Launch Claude with base prompt only and capture window ID
    WINDOW_ID=$(kitty @ launch --type=tab --tab-title "Claude: $role" --cwd="$(pwd)" claude --append-system-prompt "${PROMPT_CONTENT}")

    # Wait for Claude to be ready by watching for cursor activity
    echo "Waiting for Claude: $role to start..."
    while true; do
        # Check if the window has a cursor (indicating Claude is ready for input)
        CURSOR_INFO=$(kitty @ get-text --match="id:$WINDOW_ID" --extent=screen 2>/dev/null)
        if [[ $? -eq 0 && -n "$CURSOR_INFO" ]]; then
            break
        fi
        sleep 0.1
    done

    # Send the role prompt and Enter key to the specific window
    kitty @ send-text --match="id:$WINDOW_ID" "YOUR ROLE: ${role}"
    kitty @ send-text --match="id:$WINDOW_ID" $'\r'
done

echo "Multi-Agent Claude setup complete!"
echo "Roles launched: ${ROLES[*]}"
