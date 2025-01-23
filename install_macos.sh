#!/bin/bash

# Add Homebrew to PATH if not already set
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found in PATH. Checking installation..."
    if [ -d "/opt/homebrew" ]; then
        echo "Adding Homebrew to PATH..."
        export PATH="/opt/homebrew/bin:$PATH"
    else
        echo "Homebrew is not installed. Installing now..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH for the current session
        export PATH="/opt/homebrew/bin:$PATH"
    fi
else
    echo "Homebrew is already in PATH."
fi

# Install fish shell if not already installed
if ! command -v fish &> /dev/null; then
    echo "fish shell not found, installing with Homebrew..."
    brew install fish
    echo "Adding fish to /etc/shells..."
    if ! grep -q "/opt/homebrew/bin/fish" /etc/shells; then
        echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
    fi
    echo "Changing default shell to fish..."
    chsh -s "/opt/homebrew/bin/fish"
else
    echo "fish shell is already installed. Skipping..."
fi

# Install other tools
brew install fzf
brew install eza
brew install bat

# Create a symbolic link for bat if needed
if [ ! -L ~/.local/bin/bat ]; then
    mkdir -p ~/.local/bin
    ln -s "$(brew --prefix bat)/bin/bat" ~/.local/bin/bat
fi

echo "Setup completed successfully!"
