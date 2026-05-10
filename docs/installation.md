<!-- AGENTS SUMMARY
Installation guide for Experto Codebase MCP.
Sessions:
- TLDR: Fast setup summary.
- PREREQUISITES: Required local tools.
- AUTOMATIC-INSTALLATION: Packaged installer workflow.
- MANUAL-INSTALLATION: Editable local development workflow.
- CONFIGURATION: Environment and MCP client configuration notes.
-->

# Installation Guide

## Table of Contents

* [TL;DR](#tldr)
* [Prerequisites](#prerequisites)
* [Automatic Installation](#automatic-installation)
* [Manual Installation](#manual-installation)
* [Configuration](#configuration)

---

<!-- START TLDR -->
## TL;DR

* Install Experto Codebase MCP with the packaged installer when using a release artifact.
* Use the manual workflow for local development and contribution.
* The MCP server runs locally through stdio and should be registered in your MCP client config.
<!-- END TLDR -->

---

<!-- START PREREQUISITES -->
## Prerequisites

* **Python:** 3.11 or higher.
* **uv:** Required for dependency management and packaged installs.
* **System:** Linux preferred, macOS supported for local development.
* **Docker:** Optional, required only for local telemetry features.
<!-- END PREREQUISITES -->

---

<!-- START AUTOMATIC-INSTALLATION -->
## Automatic Installation

The project includes an installation script for packaged releases:

```bash
bash install/mcp-experto-codebase-install.sh
```
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
