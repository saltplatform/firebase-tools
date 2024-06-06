#!/bin/bash
set -e

printusage() {
  echo "run.sh <version>"
  echo ""
  echo "Arguments:"
  echo "  version: 'patch', 'minor', or 'major'."
  echo "  vscode_version: 'patch', 'minor', or 'major'. Defaults to same as version if omitted"
}

VERSION=$1
if [[ $VERSION == "" ]]; then
  printusage
  exit 1
elif [[ ! ($VERSION == "patch" || $VERSION == "minor" || $VERSION == "major") ]]; then
  printusage
  exit 1
fi

VSCODE_VERSION=$2
if [[ $VSCODE_VERSION == "" ]]; then
  VSCODE_VERSION=$VERSION
elif [[ ! ($VSCODE_VERSION == "patch" || $VERSION == "minor" || $VERSION == "major") ]]; then
  printusage
  exit 1
fi

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$THIS_DIR"

gcloud --project fir-tools-builds \
  builds \
  submit \
  --machine-type=e2-highcpu-8 \
  --substitutions=_VERSION=$VERSION,_VSCODE_VERSION=$VSCODE_VERSION \
  .