#!/usr/bin/env bash

set -e

trap "exit" INT

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BOOTSTRAP_PATH="${SCRIPT_DIR}"
RECIPE="${1:-default}"

if ! grep 'pam_tid.so' /etc/pam.d/sudo >/dev/null; then
    echo "setting up TouchID for sudo..."
    echo "auth sufficient pam_tid.so" | cat - /etc/pam.d/sudo > /tmp/sudo_pam && sudo mv /tmp/sudo_pam /etc/pam.d/sudo
fi

echo "Updating bootstrap repo..."
git -C "${BOOTSTRAP_PATH}" config pull.rebase false
git -C "${BOOTSTRAP_PATH}" pull origin "$(git -C "${BOOTSTRAP_PATH}" rev-parse --abbrev-ref HEAD)"

if ! command -v chef-solo > /dev/null 2>&1; then
    echo "Installing chef..."
    curl -sL https://omnitruck.chef.io/install.sh | sudo bash
fi

echo "Running chef..."
mkdir -p "${BOOTSTRAP_PATH}/chef/conf" /tmp/chef-solo
touch "${BOOTSTRAP_PATH}/chef/conf/solo.rb"
echo "{\"bootstrap\":{\"paths\":{\"source\":\"${BOOTSTRAP_PATH}\"}}}" > '/tmp/chef-solo/attr.json'
chef-solo --config "${BOOTSTRAP_PATH}/chef/conf/solo.rb" \
          --config-option file_cache_path="/tmp/chef-solo" \
          --config-option encrypted_data_bag_secret="/tmp/chef-solo/data_bag_key" \
          --config-option cookbook_path="${BOOTSTRAP_PATH}/chef/cookbooks" \
          --config-option role_path="${BOOTSTRAP_PATH}/chef/roles" \
          --json-attributes "/tmp/chef-solo/attr.json" \
          --override-runlist "role[macos],recipe[bootstrap::${RECIPE}]" \
          --once
