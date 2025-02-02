#!/bin/bash

ROOT_DIR="$(pwd)"
SRC_DIR_NAME="bronto_forwarder"

cd "${ROOT_DIR}/${SRC_DIR_NAME}" || exit
zip -r "${ROOT_DIR}/brontoForwarder" *
cd - || exit

echo "Created artefact: brontoForwarder.zip"
