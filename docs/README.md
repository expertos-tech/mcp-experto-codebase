<!-- AGENTS SUMMARY
Public documentation home for Experto Codebase MCP.
Sessions:
- TLDR: Fast docs entry point.
- FEATURES: Main user-facing capabilities.
- QUICK-START: Links to setup and usage guides.
-->

# Experto Codebase MCP Docs

## Table of Contents

* [TL;DR](#tldr)
* [Features](#features)
* [Quick Start](#quick-start)

---

<!-- START TLDR -->
## TL;DR

* Experto Codebase MCP is a local-first MCP server for codebase context, semantic search,
  safe file access, and session memory across AI coding agents.
* The current runtime focuses on safe, token-efficient codebase access and local retrieval.
* Session memory and deeper agent handoff workflows are planned.
<!-- END TLDR -->

---

<!-- START FEATURES -->
## Features

* **Codebase Discovery:** Map project structure, relevant files, and ignored or protected paths.
* **Token-Optimized Reading:** Read bounded excerpts instead of dumping full files into context.
* **Semantic Code Search:** Index local workspaces and retrieve code by keyword, semantic intent, or hybrid ranking.
* **Safe File Access:** Keep operations scoped to the configured workspace root.
* **Local Telemetry:** Optional monitoring with Prometheus, Grafana, Loki, Tempo, and OpenTelemetry components.
<!-- END FEATURES -->

---

<!-- START QUICK-START -->
## Quick Start

1. [Installation](installation.md)
2. [Usage Guide](usage.md)
3. [Changelog](changelog.md)

---

This documentation is focused on the end-user experience. For technical architecture and development standards,
use the internal `references/` directory.
<!-- END QUICK-START -->
