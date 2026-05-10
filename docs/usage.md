<!-- AGENTS SUMMARY
Usage guide for Experto Codebase MCP and its current tool surface.
Sessions:
- TLDR: Fast usage summary.
- RUNNING-SERVER: Local startup command.
- MCP-WORKFLOW: Recommended discovery and retrieval flow.
- AVAILABLE-TOOLS: Current public tool list.
- TELEMETRY: Optional local telemetry workflow.
-->

# Usage Guide

## Table of Contents

* [TL;DR](#tldr)
* [Running the Server](#running-the-server)
* [MCP Workflow](#mcp-workflow)
* [Available Tools](#available-tools)
* [Local Telemetry](#local-telemetry)

---

<!-- START TLDR -->
## TL;DR

* Start the server with `uv run python -m server`.
* Use MCP tool listing and `get_help` before calling specific tools.
* Prefer project overview, excerpts, and semantic search over full-repository reads.
<!-- END TLDR -->

---

<!-- START RUNNING-SERVER -->
## Running the Server

To start the server locally:

```bash
uv run python -m server
```
<!-- END RUNNING-SERVER -->

---

<!-- START MCP-WORKFLOW -->
## MCP Workflow

The server is designed to support a compact research, strategy, and execution lifecycle:

1. **Discover:** Use MCP tool listing and `get_help` to inspect available Tools.
2. **Map:** Use `project_overview` and `index_status` to understand the workspace.
3. **Retrieve:** Use `read_file_excerpt`, `read_document_excerpt`, `search_files`, and `find_similar_content`.
4. **Act:** Apply code changes in the host agent after retrieving enough context.
5. **Validate:** Run the project's normal tests and checks outside the MCP tool layer.
<!-- END MCP-WORKFLOW -->

---

<!-- START AVAILABLE-TOOLS -->
## Available Tools

Current public Tools:

* `get_help`: Retrieve runtime help and tool-specific documentation.
* `project_overview`: Map workspace structure and relevant files.
* `read_file_excerpt`: Read bounded excerpts from text-like files.
* `read_document_excerpt`: Read bounded excerpts from supported document formats.
* `index_workspace`: Build or refresh the local retrieval index.
* `search_files`: Query indexed content with keyword, semantic, or hybrid ranking.
* `find_similar_content`: Retrieve chunks similar to a file or excerpt.
* `index_status`: Inspect index and watcher health.
* `index_errors`: Inspect recent extraction and indexing failures.
<!-- END AVAILABLE-TOOLS -->

---

<!-- START TELEMETRY -->
## Local Telemetry

If Docker is installed, start the optional local telemetry stack:

```bash
cd local-telemetry
docker-compose up -d
```

Access Grafana at `http://localhost:3000` to inspect local observability dashboards.
<!-- END TELEMETRY -->
