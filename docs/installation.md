<!-- AGENTS SUMMARY
Installation guide for Experto Codebase MCP.
Sessions:
- TLDR: Fast setup summary.
- PREREQUISITES: Required local tools.
- DISTRIBUTION-BUILD: How to generate packaged artifacts in installer/dist.
- AUTOMATIC-INSTALLATION: Packaged installer workflow.
- MANUAL-INSTALLATION: Editable local development workflow.
- CONFIGURATION: Environment and MCP client configuration notes.
-->

# Installation Guide

## Table of Contents

* [TL;DR](#tldr)
* [Prerequisites](#prerequisites)
* [Distribution Build](#distribution-build)
* [Automatic Installation](#automatic-installation)
* [Manual Installation](#manual-installation)
* [Configuration](#configuration)

---

<!-- START TLDR -->
## TL;DR

* Build release artifacts with `installer/build-dist.sh`.
* Use `installer/install-mcp.sh` on Linux/macOS or `installer/install-mcp.bat` on Windows.
* The MCP server runs locally through stdio and should be registered in your MCP client config.
<!-- END TLDR -->

---

<!-- START PREREQUISITES -->
## Prerequisites

* **Python:** 3.11 or higher.
* **uv:** Recommended for dependency management after install.
* **System:** Linux, macOS, or Windows.
* **Docker:** Optional, required only for local telemetry features.
<!-- END PREREQUISITES -->

---

<!-- START DISTRIBUTION-BUILD -->
## Distribution Build

Generate the versioned tarball and installers in `installer/dist`:

```bash
bash installer/build-dist.sh
```

Expected artifacts:

* `installer/dist/mcp-experto-codebase.vX.Y.Z.tar.gz`
* `installer/dist/mcp-experto-codebase.vX.Y.Z.tar.gz.sha256`
* `installer/dist/build-dist.sh` (+ checksum)
* `installer/dist/install-mcp.sh` (+ checksum)
* `installer/dist/install-mcp.bat` (+ checksum)
<!-- END DISTRIBUTION-BUILD -->

---

<!-- START AUTOMATIC-INSTALLATION -->
## Automatic Installation

### Linux/macOS

```bash
bash installer/install-mcp.sh
```

Default target directory:

* `~/.local/mcp-experto-codebase`

### Windows

Run from Command Prompt:

```bat
installer\install-mcp.bat
```

Default target directory:

* `%LOCALAPPDATA%\mcp-experto-codebase` (fallback: `%USERPROFILE%\.local\mcp-experto-codebase`)

The installers validate Python 3.11+. If Python is missing, they try automatic installation where possible and otherwise print manual steps.
<!-- END AUTOMATIC-INSTALLATION -->

---

<!-- START MANUAL-INSTALLATION -->
## Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/expertos-tech/mcp-experto-codebase.git
cd mcp-experto-codebase
```

2. Install dependencies:

```bash
uv sync --all-extras
```

3. Run the server locally:

```bash
uv run python -m server
```
<!-- END MANUAL-INSTALLATION -->

---

<!-- START CONFIGURATION -->
## Configuration

The server can be configured through environment variables or a `.env` file. See `src/server/config.py`
for available options and register the stdio command in your MCP client configuration.
<!-- END CONFIGURATION -->
