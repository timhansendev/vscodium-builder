#!/bin/bash

set -ex

npm config set scripts-prepend-node-path true

echo "MS_COMMIT: ${MS_COMMIT}"

. prepare_vscode.sh

cd vscode || exit

yarn monaco-compile-check
yarn valid-layers-check

yarn gulp compile-build
yarn gulp compile-extension-media
yarn gulp compile-extensions-build
yarn gulp minify-vscode

yarn gulp "vscode-linux-${VSCODE_ARCH}-min-ci"

yarn gulp "vscode-linux-${VSCODE_ARCH}-build-rpm"

cd ..

