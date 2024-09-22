DOWNLOAD_DIR="$HOME/Downloads"
DOWNLOAD_FILE="$DOWNLOAD_DIR/exa.zip"

curl -Lo "$DOWNLOAD_FILE" "https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip"
unzip -d "$DOWNLOAD_DIR/exa" "$DOWNLOAD_FILE"

cp -r "$DOWNLOAD_DIR/exa" "$HOME/.local/share"
ln -s "$HOME/.local/share/exa/bin/exa" "$HOME/.local/bin/exa"
