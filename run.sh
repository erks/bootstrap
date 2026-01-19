#!/usr/bin/env bash

set -e

trap "exit" INT

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BOOTSTRAP_PATH="${SCRIPT_DIR}"
RECIPE="${1:-default}"

if [ ! -f /etc/pam.d/sudo_local ]; then
    echo "setting up TouchID for sudo..."
    echo "auth sufficient pam_tid.so" | sudo tee /etc/pam.d/sudo_local
fi

echo "Updating bootstrap repo..."
git -C "${BOOTSTRAP_PATH}" config pull.rebase false
git -C "${BOOTSTRAP_PATH}" pull origin "$(git -C "${BOOTSTRAP_PATH}" rev-parse --abbrev-ref HEAD)"

BREW="/opt/homebrew/bin/brew"
if [ ! -f "${BREW}" ]; then
    echo "Installing homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    "${BREW}" doctor
fi

CHEF_SOLO="/opt/chef-workstation/bin/chef-solo"
if [ ! -f "${CHEF_SOLO}" ]; then
    echo "Installing chef..."
    "${BREW}" install --cask chef-workstation
fi

echo "Running chef..."
mkdir -p "${BOOTSTRAP_PATH}/chef/conf" /tmp/chef-solo
touch "${BOOTSTRAP_PATH}/chef/conf/solo.rb"
echo "{\"bootstrap\":{\"paths\":{\"source\":\"${BOOTSTRAP_PATH}\"}}}" > '/tmp/chef-solo/attr.json'
"${CHEF_SOLO}" --config "${BOOTSTRAP_PATH}/chef/conf/solo.rb" \
          --config-option file_cache_path="/tmp/chef-solo" \
          --config-option encrypted_data_bag_secret="/tmp/chef-solo/data_bag_key" \
          --config-option cookbook_path="${BOOTSTRAP_PATH}/chef/cookbooks" \
          --config-option role_path="${BOOTSTRAP_PATH}/chef/roles" \
          --json-attributes "/tmp/chef-solo/attr.json" \
          --override-runlist "role[macos],recipe[bootstrap::${RECIPE}]" \
          --once
