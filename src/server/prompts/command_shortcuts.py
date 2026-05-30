"""MCP prompts for agent command shortcuts."""

from fastmcp import FastMCP


def register_command_shortcut_prompts(mcp: FastMCP) -> None:
    """Register prompts that encapsulate command shortcut instructions."""

    @mcp.prompt(
        name="star_help",
        description="Use when the user calls *help [command|group].",
    )
    def star_help(command_or_group: str | None = None) -> str:
        target = command_or_group or "all"
        return (
            "Command: *help\n"
            f"Target: {target}\n\n"
            "Instructions:\n"
            "- Show command information organized by groups.\n"
            "- If a specific command or group is provided, scope the output to it.\n"
            "- Keep output compact and actionable."
        )

    @mcp.prompt(
        name="star_prompt",
        description="Use when the user calls *prompt.",
    )
    def star_prompt() -> str:
        return (
            "Command: *prompt\n\n"
            "Instructions:\n"
            "- Read ./tmp/prompt.md immediately.\n"
            "- Re-anchor active instructions from that file before continuing."
        )

    @mcp.prompt(
        name="star_reload",
        description="Use when the user calls *reload.",
    )
    def star_reload() -> str:
        return (
            "Command: *reload\n\n"
            "Instructions:\n"
            "- Re-read core rules from AGENTS.md, CLAUDE.md, and GEMINI.md.\n"
            "- Re-anchor mandatory constraints before proceeding."
        )

    @mcp.prompt(
        name="star_commit",
        description="Use when the user calls *commit.",
    )
    def star_commit() -> str:
        return (
            "Command: *commit\n\n"
            "Instructions:\n"
            "- Create a semantic commit for the current session work.\n"
            "- Follow repository commit rules for type, scope, and rationale bullets."
        )

    @mcp.prompt(
        name="star_commit_all",
        description="Use when the user calls *commit-all.",
    )
    def star_commit_all() -> str:
        return (
            "Command: *commit-all\n\n"
            "Instructions:\n"
            "- Stage all pending changes.\n"
            "- Create a semantic commit that includes an 'Additional Changes' summary."
        )

    @mcp.prompt(
        name="star_push",
        description="Use when the user calls *push.",
    )
    def star_push() -> str:
        return (
            "Command: *push\n\n"
            "Instructions:\n"
            "- Execute *commit flow first.\n"
            "- Push local commits to the remote repository."
        )

    @mcp.prompt(
        name="star_git_branch",
        description="Use when the user calls *git-branch.",
    )
    def star_git_branch() -> str:
        return (
            "Command: *git-branch\n\n"
            "Instructions:\n"
            "- Ask the functional purpose of the branch.\n"
            "- Generate a semantic branch name following Git rules.\n"
            "- Create the branch locally.\n"
            "- Push the new branch to remote immediately."
        )

    @mcp.prompt(
        name="star_merge_main",
        description="Use when the user calls *merge-main.",
    )
    def star_merge_main() -> str:
        return (
            "Command: *merge-main\n\n"
            "Instructions:\n"
            "- Run *commit-all and *push on the current branch.\n"
            "- Switch to main.\n"
            "- Merge the feature branch into main.\n"
            "- Ask user confirmation before deleting branch locally and remotely."
        )

    @mcp.prompt(
        name="star_clean",
        description="Use when the user calls *clean [--all].",
    )
    def star_clean(all_mode: bool = False) -> str:
        suffix = (
            "Also recreate ./tmp/prompt.md with only Context and Instructions headers."
            if all_mode
            else "Keep ./tmp/prompt.md and remove the remaining files under ./tmp/."
        )
        return (
            "Command: *clean\n"
            f"Mode: {'--all' if all_mode else 'default'}\n\n"
            "Instructions:\n"
            "- Remove files inside ./tmp/ according to mode.\n"
            f"- {suffix}"
        )

    @mcp.prompt(
        name="star_clean_prompt",
        description="Use when the user calls *clean-prompt.",
    )
    def star_clean_prompt() -> str:
        return (
            "Command: *clean-prompt\n\n"
            "Instructions:\n"
            "- Reset ./tmp/prompt.md.\n"
            "- Preserve only Context and Instructions headers."
        )

    @mcp.prompt(
        name="star_save_session",
        description="Use when the user calls *save-session.",
    )
    def star_save_session() -> str:
        return (
            "Command: *save-session\n\n"
            "Instructions:\n"
            "- Build an exhaustive, step-by-step session report.\n"
            "- Check whether ./tmp/last-session.md exists.\n"
            "- If it exists, summarize current content and ask whether to overwrite or append.\n"
            "- Include plans, rationale, and detailed file modifications."
        )

    @mcp.prompt(
        name="star_load_session",
        description="Use when the user calls *load-session.",
    )
    def star_load_session() -> str:
        return (
            "Command: *load-session\n\n"
            "Instructions:\n"
            "- Check for ./tmp/last-session.md.\n"
            "- If present, recover and re-anchor context, progress, and historical data."
        )
