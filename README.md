<!-- AGENTS SUMMARY
High-level overview of Experto Codebase MCP for human users and AI coding agents.
Sessions:
- TLDR: Fast project summary for new readers.
- OVERVIEW: Public positioning and MCP ecosystem fit.
- CORE-CAPABILITIES: Main implemented and planned capability areas.
- CURRENT-STATUS: Honest implementation status.
- INSTALLATION: Local development setup.
- NAMING-MIGRATION: Rename note from the pre-launch project name.
-->

# Experto Codebase MCP

## Table of Contents

* [TL;DR](#tldr)
* [Overview](#overview)
* [Core Capabilities](#core-capabilities)
* [Current Status](#current-status)
* [Installation](#installation)
* [Documentation](#documentation)
* [Naming / Migration](#naming--migration)
* [Contributing](#contributing)
* [About Expertos Tech](#about-expertos-tech)

---

<!-- START TLDR -->
## TL;DR

* `mcp-experto-codebase` is a local-first MCP server for giving AI coding agents safe,
  token-efficient, and semantically guided access to local codebases.
* It helps agents understand project structure, retrieve relevant files, preserve session context,
  and avoid wasteful full-repository reads.
* Use `docs/README.md` and `AGENTS.md` as the main entry points for humans and AI agents.
<!-- END TLDR -->

---

<!-- START OVERVIEW -->
## Overview

Experto Codebase MCP is a local-first codebase context MCP server for semantic search,
safe file access, and session memory across AI coding agents.

It helps Codex, Gemini, Copilot, Claude, and other MCP clients understand a repository without
rereading everything on every task. The server focuses on token economy, selective reading,
semantic code search, and local context that stays on the developer machine.

The product is not only a server for filesystem access. Filesystem access is a central capability, but
the broader goal is a codebase context layer aligned with Model Context Protocol primitives:
Resources for model context and project data, Prompts for reusable workflows, and Tools for
executable codebase operations.
<!-- END OVERVIEW -->

---

<!-- START CORE-CAPABILITIES -->
## Core Capabilities

### 1. Codebase Discovery

* Stack and project structure detection.
* Project overview generation.
* Relevant entry point discovery.
* Protected file and ignored path awareness.

### 2. Token-Optimized Reading

* Bounded file excerpts.
* Line-range reads.
* Document excerpts for supported formats.
* Guidance to avoid dumping full files into the model context.

### 3. Semantic Code Search

* Local workspace indexing.
* Search by keyword, semantic intent, or hybrid ranking.
* Similar content retrieval.
* Search-oriented codebase navigation.

### 4. Safe File Operations

* Guardrails for paths under the configured workspace root.
* Protected path awareness for sensitive and noisy files.
* Planned dry-run and diff-based write operations.

### 5. Session Memory and Agent Handoff

* Planned compact session summaries.
* Planned architectural decision capture.
* Planned pending task tracking.
* Planned recent-file change context.
* Planned handoff workflows between Codex, Gemini, Copilot, Claude, and other MCP clients.
<!-- END CORE-CAPABILITIES -->

---

<!-- START CURRENT-STATUS -->
## Current Status

The project is under active development. The current runtime focuses on safe, token-efficient
codebase access. Some capabilities are implemented, while deeper memory and agent handoff
workflows are planned.

Implemented:

* Runtime tool introspection through `get_help`.
* Project overview and guided reading through `project_overview`.
* File excerpts through `read_file_excerpt`.
* Document excerpts through `read_document_excerpt`.
* Workspace indexing through `index_workspace`.
* Search-oriented navigation through `search_files`.
* Similar content retrieval through `find_similar_content`.
* Index health and error reporting through `index_status` and `index_errors`.
* Universal response contract with `status`, `message`, `data`, `error`, `meta`, and `metrics`.

In progress:

* Deeper semantic retrieval workflows.

Planned:

* Safe diff-based write operations.
* Session memory and agent handoff workflows.
* Multi-client Docker and HTTP setup where it fits the local-first security model.
<!-- END CURRENT-STATUS -->

---

<!-- START INSTALLATION -->
## Installation

> The server is under active development. The steps below reflect the current local development workflow.

```bash
# 1. Clone the repository
git clone https://github.com/expertos-tech/mcp-experto-codebase.git
cd mcp-experto-codebase

# 2. Install dependencies, requires Python 3.11+
uv sync --all-extras

# 3. Run the validation suite
uv run ruff check src tests
uv run mypy src
uv run pytest --cov=src --cov-branch

# 4. Register with your MCP client
# Add the server entry to your client's mcp_servers config pointing to the stdio entrypoint.
```

For detailed setup, see [docs/installation.md](./docs/installation.md).
<!-- END INSTALLATION -->

---

<!-- START DOCUMENTATION -->
## Documentation

Whether you are a human contributor or an AI agent, documentation is the source of truth:

* **[Docs Home](./docs/README.md):** Public documentation entry point.
* **[Technical Documentation Index](./references/README.md):** Architecture, standards, and design guides.
* **[AGENTS.md](./AGENTS.md):** Mandatory rules, persona, and command shortcuts for AI agents working in this
  repository.
<!-- END DOCUMENTATION -->

---

<!-- START NAMING-MIGRATION -->
## Naming / Migration

This project was originally developed as mcp-experto-filesystem and renamed before public launch to better
reflect its broader scope: codebase context, semantic search, safe file access, and session memory.
<!-- END NAMING-MIGRATION -->

---

## Contributing

We are in the early stages of building this solution and welcome focused contributions.

1. Check the [Development Standards](./references/development-standards.md).
2. Understand the AI tool philosophy in the [MCP Design Guidelines](./references/mcp-design-guidelines.md).
3. Open an issue to discuss your idea or submit a pull request.

---

## About Expertos Tech

Expertos Tech is a community focused on software engineering, cloud architecture, and AI education. We build
tools that help developers work with stronger context and lower operational friction.

* **Website:** [expertostech.dev](https://expertostech.dev)
* **License:** MIT. See `LICENSE` for details.
