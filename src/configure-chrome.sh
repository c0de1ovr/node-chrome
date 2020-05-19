#!/usr/bin/env bash

CHROME_RUNNER_BIN="/opt/bin/chrome-runner"
CHROME_BIN="/usr/bin/google-chrome"
CHROME_BIN_BASE="${CHROME_BIN}-base"

CHROME_BIN_PATH=$(readlink -f "${CHROME_BIN}")
CHROME_BIN_BASE_PATH="${CHROME_BIN_PATH}-base"

# change chrome bin path to new bin base path to be able wrapping chrome binaries
rm "${CHROME_BIN}"
mv "${CHROME_BIN_PATH}" "${CHROME_BIN_BASE_PATH}"

# prepare chrome runner
chmod +x "${CHROME_RUNNER_BIN}"
mv "${CHROME_RUNNER_BIN}" "${CHROME_BIN_PATH}"

# create new symlinks
ln -s "${CHROME_BIN_PATH}" "${CHROME_BIN}"
ln -s "${CHROME_BIN_BASE_PATH}" "${CHROME_BIN_BASE}"
