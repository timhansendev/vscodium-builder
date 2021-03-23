#!/bin/bash

# figure out latest tag by calling MS update API
UPDATE_INFO=$(curl https://update.code.visualstudio.com/api/update/darwin/stable/lol)
export LATEST_MS_COMMIT=$(echo $UPDATE_INFO | jq -r '.version')
export LATEST_MS_TAG=$(echo $UPDATE_INFO | jq -r '.name')
echo "Got the latest MS tag: ${LATEST_MS_TAG}"

git clone ${repo} --branch ${tag} --depth 1 vscodium

cd vscodium/


git clone https://github.com/Microsoft/vscode.git --branch $LATEST_MS_TAG --depth 1
npm config set scripts-prepend-node-path true

echo "LATEST_MS_COMMIT: ${LATEST_MS_COMMIT}"

. prepare_vscode.sh

cd vscode || exit

yarn monaco-compile-check
yarn valid-layers-check

yarn gulp compile-build
yarn gulp compile-extensions-build
yarn gulp minify-vscode
yarn gulp "vscode-linux-${VSCODE_ARCH}-min"
yarn gulp "vscode-linux-${VSCODE_ARCH}-build-rpm"

cp -f $(find /vscodium/vscode/ -name "*.rpm" | head -n 1) /home/

