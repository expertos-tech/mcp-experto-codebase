#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="${SCRIPT_DIR}/dist"
PACKAGE_PATTERN="mcp-experto-codebase.v*.tar.gz"

info() { echo "[info]  $*"; }
ok() { echo "[ok]    $*"; }
warn() { echo "[warn]  $*"; }
err() { echo "[error] $*" >&2; exit 1; }

command -v tar >/dev/null 2>&1 || err "tar not found"
command -v sha256sum >/dev/null 2>&1 || err "sha256sum not found"

OS_NAME="$(uname -s)"
case "${OS_NAME}" in
  Linux*) TARGET_DIR="/.local/mcp-experto-codebase" ;;
  Darwin*) TARGET_DIR="/.local/mcp-experto-codebase" ;;
  *) err "Unsupported OS: ${OS_NAME}" ;;
esac

find_python() {
  if command -v python3 >/dev/null 2>&1; then
    echo "python3"
    return 0
  fi
  if command -v python >/dev/null 2>&1; then
    echo "python"
    return 0
  fi
  return 1
}

validate_python_version() {
  local py_cmd="$1"
  "${py_cmd}" - <<'PYEOF'
import sys
raise SystemExit(0 if sys.version_info >= (3, 11) else 1)
PYEOF
}

attempt_install_python() {
  info "Trying to install Python 3.11+ automatically..."
  if [[ "${OS_NAME}" == "Linux"* ]]; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y python3 python3-venv || return 1
      return 0
    fi
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y python3 || return 1
      return 0
    fi
    if command -v pacman >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm python || return 1
      return 0
    fi
  fi

  if [[ "${OS_NAME}" == "Darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew install python@3.11 || return 1
      return 0
    fi
  fi

  return 1
}

verify_sha256() {
  local checksum_file="$1"
  local base_dir
  base_dir="$(dirname "${checksum_file}")"
  (
    cd "${base_dir}"
    sha256sum -c "$(basename "${checksum_file}")"
  )
}

PY_CMD="$(find_python || true)"
if [[ -z "${PY_CMD}" ]] || ! validate_python_version "${PY_CMD}"; then
  warn "Python 3.11+ not found."
  if ! attempt_install_python; then
    err "Could not install Python automatically. Install Python 3.11+ and rerun this installer."
  fi
  PY_CMD="$(find_python || true)"
  [[ -n "${PY_CMD}" ]] && validate_python_version "${PY_CMD}" || err "Python install failed."
fi
ok "Python runtime validated (${PY_CMD})."

[[ -d "${DIST_DIR}" ]] || err "Distribution directory not found at ${DIST_DIR}."
PACKAGE_CANDIDATES=("${DIST_DIR}"/${PACKAGE_PATTERN})
[[ -e "${PACKAGE_CANDIDATES[0]}" ]] || err "No package found in ${DIST_DIR}. Run installer/build-dist.sh first."
[[ "${#PACKAGE_CANDIDATES[@]}" -eq 1 ]] || err "Expected one package in ${DIST_DIR}, found ${#PACKAGE_CANDIDATES[@]}."

ARCHIVE_PATH="${PACKAGE_CANDIDATES[0]}"
ARCHIVE_SHA_PATH="${ARCHIVE_PATH}.sha256"
[[ -f "${ARCHIVE_SHA_PATH}" ]] || err "Archive checksum not found at ${ARCHIVE_SHA_PATH}."

info "Validating archive checksum..."
verify_sha256 "${ARCHIVE_SHA_PATH}" >/dev/null
ok "Archive checksum verified."

STAGING_DIR="$(mktemp -d)"
cleanup() { rm -rf "${STAGING_DIR}"; }
trap cleanup EXIT

info "Extracting package..."
tar -C "${STAGING_DIR}" -xzf "${ARCHIVE_PATH}"
PACKAGE_ROOT="${STAGING_DIR}/mcp-experto-codebase"
[[ -d "${PACKAGE_ROOT}" ]] || err "Invalid package contents."

mkdir -p "${TARGET_DIR}"
rm -rf "${TARGET_DIR}/src" "${TARGET_DIR}/install" "${TARGET_DIR}/installer"
cp -r "${PACKAGE_ROOT}/src" "${TARGET_DIR}/src"
cp -r "${PACKAGE_ROOT}/install" "${TARGET_DIR}/install"
cp -r "${PACKAGE_ROOT}/installer" "${TARGET_DIR}/installer"
cp "${PACKAGE_ROOT}/pyproject.toml" "${TARGET_DIR}/pyproject.toml"
cp "${PACKAGE_ROOT}/README.md" "${TARGET_DIR}/README.md"

if command -v uv >/dev/null 2>&1; then
  info "Installing dependencies with uv (retrieval extra)..."
  uv --directory "${TARGET_DIR}" sync --extra retrieval --no-dev
  ok "Dependencies installed."
else
  warn "uv not found. Skipping dependency installation."
  warn "Install uv and run: uv --directory '${TARGET_DIR}' sync --extra retrieval --no-dev"
fi

ok "Installation complete at ${TARGET_DIR}."
echo "Run server with:"
echo "  uv --directory '${TARGET_DIR}' run python -m server"
