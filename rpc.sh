cat << 'EOF' > rpc.sh
#!/bin/bash

CONFIG_FILE="$HOME/0g-storage-node/run/config.toml"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

CURRENT_RPC=$(grep -oP '(?<=^blockchain_rpc_endpoint = ")[^"]+' "$CONFIG_FILE")
echo "Current RPC: $CURRENT_RPC"
echo ""

read -p "Enter the new RPC URL: " NEW_RPC

if [[ -z "$NEW_RPC" ]]; then
    echo "No RPC URL provided. Exiting..."
    exit 1
fi

if ! [[ "$NEW_RPC" =~ ^https?:// ]]; then
    echo "Invalid RPC URL format. Must start with http:// or https://"
    exit 1
fi

if [[ "$NEW_RPC" == "$CURRENT_RPC" ]]; then
    echo "New RPC is the same as the current one. No changes made."
    exit 0
fi

sed -i "s|^blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = \"$NEW_RPC\"|" "$CONFIG_FILE"

echo "Restarting zgs service..."
sudo systemctl restart zgs

echo "RPC updated to: $NEW_RPC"
EOF

chmod +x rpc.sh
./rpc.sh
