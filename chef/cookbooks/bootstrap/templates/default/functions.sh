#!/bin/sh

update () {
    echo "running bootstrap..."
    "${BOOTSTRAP_DIR}/run.sh"

    echo "sourcing profile..."
    source "${HOME}/.profile"
}

amr () {
    local AMR_URL="https://release.allmangasreader.com/all-mangas-reader-latest.crx"
    local ICLOUD_PATH="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
    local AMR_PATH="${ICLOUD_PATH}/Documents/amr"
    local AMR_FILE="amr.zip"

    mkdir -p "${AMR_PATH}"
    cd "${AMR_PATH}"
    rm -f "${AMR_FILE}"
    echo "downloading ${AMR_URL} to ${AMR_PATH}/${AMR_FILE}..."
    curl "${AMR_URL}" -o "${AMR_FILE}"
    echo "unzipping ${AMR_FILE}..."
    unzip -o "${AMR_FILE}"
}
