#!/usr/bin/env bash
# Link fleet's skills and agents into the agent config dirs on this machine.
# Global instructions live in ~/.agents/AGENTS.md (private, not in this public repo);
# ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md link to it.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Backups live outside the skill/agent dirs so agents don't load them as duplicates.
BACKUP="$HOME/.fleet-backups/$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local saved="$BACKUP${dest#"$HOME"}"
    mkdir -p "$(dirname "$saved")"
    mv "$dest" "$saved"
    echo "backed up $dest -> $saved"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest"
}

if [ -f "$HOME/.agents/AGENTS.md" ]; then
  link "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  link "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
else
  echo "no ~/.agents/AGENTS.md on this machine: global instructions not linked" >&2
fi

for skill in "$REPO"/skills/*/; do
  name="$(basename "$skill")"
  link "$REPO/skills/$name" "$HOME/.claude/skills/$name"
  link "$REPO/skills/$name" "$HOME/.agents/skills/$name"
done

for agent in "$REPO"/agents/*.md; do
  [ -e "$agent" ] || continue
  link "$agent" "$HOME/.claude/agents/$(basename "$agent")"
done

# CLIs that ~/.agents/AGENTS.md tells agents to use. Installed once; update them with npm.
if ! command -v agent-desktop >/dev/null 2>&1; then
  if command -v npm >/dev/null 2>&1; then
    npm install -g agent-desktop
  else
    echo "npm not found: install agent-desktop with 'npm install -g agent-desktop' or 'brew install agent-desktop'" >&2
  fi
fi
