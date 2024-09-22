DOWNLOAD_DIR="$HOME/Donwloads"
DOWNLOAD_FILE="$DOWNLOAD_DIR/lazygit.tar.gz"
INSTALL_DIR="$HOME/.local/bin"

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo "$DOWNLOAD_FILE" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf "$DOWNLOAD_FILE" "$DOWNLOAD_DIR/lazygit"
sudo install "$DOWNLOAD_DIR/lazygit" "$INSTALL_DIR"
