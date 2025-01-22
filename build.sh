#!/bin/bash

VERSION="$1"

ROOT_DIR="$(pwd)"
SRC_DIR_NAME="bronto_forwarder"

BUILD_DIR="${ROOT_DIR}/build/${VERSION}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

cd "${ROOT_DIR}/${SRC_DIR_NAME}" || exit
zip -r "${BUILD_DIR}/brontoForwarder" *
cd -

echo "Created artefact: ${BUILD_DIR}/brontoForwarder.zip"
