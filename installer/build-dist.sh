#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"
DIST_DIR="${SCRIPT_DIR}/dist"
PACKAGE_NAME="mcp-experto-codebase"
BUILD_SCRIPT="build-dist.sh"
UNIX_INSTALLER="install-mcp.sh"
WIN_INSTALLER="install-mcp.bat"

info() { echo "[info]  $*"; }
ok() { echo "[ok]    $*"; }
err() { echo "[error] $*" >&2; exit 1; }

command -v python3 >/dev/null 2>&1 || err "python3 not found"
command -v tar >/dev/null 2>&1 || err "tar not found"
command -v sha256sum >/dev/null 2>&1 || err "sha256sum not found"

PYPROJECT_PATH="${REPO_ROOT}/pyproject.toml"
[[ -f "${PYPROJECT_PATH}" ]] || err "pyproject.toml not found at ${PYPROJECT_PATH}"
[[ -f "${SCRIPT_DIR}/${BUILD_SCRIPT}" ]] || err "${BUILD_SCRIPT} not found in installer/"
[[ -f "${SCRIPT_DIR}/${UNIX_INSTALLER}" ]] || err "${UNIX_INSTALLER} not found in installer/"
[[ -f "${SCRIPT_DIR}/${WIN_INSTALLER}" ]] || err "${WIN_INSTALLER} not found in installer/"

RAW_VERSION="$(python3 - "${PYPROJECT_PATH}" <<'PYEOF'
from pathlib import Path
import re
import sys

content = Path(sys.argv[1]).read_text(encoding="utf-8")
match = re.search(r'^version\s*=\s*"([^"]+)"', content, flags=re.MULTILINE)
if not match:
    raise SystemExit("Unable to locate project version in pyproject.toml")
print(match.group(1))
PYEOF
)"

if [[ ! "${RAW_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    err "Unsupported version format: ${RAW_VERSION}"
fi

ARCHIVE_NAME="${PACKAGE_NAME}.v${RAW_VERSION}.tar.gz"
ARCHIVE_PATH="${DIST_DIR}/${ARCHIVE_NAME}"
ARCHIVE_SHA_PATH="${ARCHIVE_PATH}.sha256"

STAGING_DIR="$(mktemp -d)"
cleanup() { rm -rf "${STAGING_DIR}"; }
trap cleanup EXIT

PACKAGE_ROOT="${STAGING_DIR}/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_ROOT}/installer"

info "Preparing package content for version ${RAW_VERSION}"
cp -r "${REPO_ROOT}/src" "${PACKAGE_ROOT}/src"
cp "${REPO_ROOT}/pyproject.toml" "${PACKAGE_ROOT}/pyproject.toml"
cp "${REPO_ROOT}/README.md" "${PACKAGE_ROOT}/README.md"
cp -r "${REPO_ROOT}/install" "${PACKAGE_ROOT}/install"
cp "${SCRIPT_DIR}/${UNIX_INSTALLER}" "${PACKAGE_ROOT}/installer/${UNIX_INSTALLER}"
cp "${SCRIPT_DIR}/${WIN_INSTALLER}" "${PACKAGE_ROOT}/installer/${WIN_INSTALLER}"

mkdir -p "${DIST_DIR}"
rm -f "${ARCHIVE_PATH}" "${ARCHIVE_SHA_PATH}" \
  "${DIST_DIR}/${BUILD_SCRIPT}" "${DIST_DIR}/${BUILD_SCRIPT}.sha256" \
  "${DIST_DIR}/${UNIX_INSTALLER}" "${DIST_DIR}/${UNIX_INSTALLER}.sha256" \
  "${DIST_DIR}/${WIN_INSTALLER}" "${DIST_DIR}/${WIN_INSTALLER}.sha256"

info "Creating ${ARCHIVE_NAME}"
tar -C "${STAGING_DIR}" -czf "${ARCHIVE_PATH}" "${PACKAGE_NAME}"
cp "${SCRIPT_DIR}/${BUILD_SCRIPT}" "${DIST_DIR}/${BUILD_SCRIPT}"
cp "${SCRIPT_DIR}/${UNIX_INSTALLER}" "${DIST_DIR}/${UNIX_INSTALLER}"
cp "${SCRIPT_DIR}/${WIN_INSTALLER}" "${DIST_DIR}/${WIN_INSTALLER}"

(
  cd "${DIST_DIR}"
  sha256sum "${ARCHIVE_NAME}" > "$(basename "${ARCHIVE_SHA_PATH}")"
  sha256sum "${BUILD_SCRIPT}" > "${BUILD_SCRIPT}.sha256"
  sha256sum "${UNIX_INSTALLER}" > "${UNIX_INSTALLER}.sha256"
  sha256sum "${WIN_INSTALLER}" > "${WIN_INSTALLER}.sha256"
)

ok "Distribution ready in ${DIST_DIR}"
echo "- ${ARCHIVE_PATH}"
echo "- ${ARCHIVE_SHA_PATH}"
echo "- ${DIST_DIR}/${BUILD_SCRIPT}"
echo "- ${DIST_DIR}/${UNIX_INSTALLER}"
echo "- ${DIST_DIR}/${WIN_INSTALLER}"
