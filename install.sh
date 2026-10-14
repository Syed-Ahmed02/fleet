#!/usr/bin/env bash
# Link fleet's AGENTS.md and skills into the agent config dirs on this machine.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak.$STAMP"
    echo "backed up $dest -> $dest.bak.$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest"
}

link "$REPO/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$REPO/AGENTS.md" "$HOME/.codex/AGENTS.md"

for skill in "$REPO"/skills/*/; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  link "$REPO/skills/$name" "$HOME/.claude/skills/$name"
  link "$REPO/skills/$name" "$HOME/.agents/skills/$name"
done
