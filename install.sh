#!/usr/bin/env bash
# Link fleet's AGENTS.md, skills, and agents into the agent config dirs on this machine.
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

link "$REPO/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$REPO/AGENTS.md" "$HOME/.codex/AGENTS.md"

for skill in "$REPO"/skills/*/; do
  name="$(basename "$skill")"
  link "$REPO/skills/$name" "$HOME/.claude/skills/$name"
  link "$REPO/skills/$name" "$HOME/.agents/skills/$name"
done

for agent in "$REPO"/agents/*.md; do
  [ -e "$agent" ] || continue
  link "$agent" "$HOME/.claude/agents/$(basename "$agent")"
done
