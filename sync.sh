#!/usr/bin/env bash
# Re-copy every upstream skill and agent listed in sources.tsv, with its license.
# Records the upstream commit for each repo in sources.lock. Review the diff before committing.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fetch() {
  local repo="$1" dir="$TMP/${1//\//_}"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    gh api "repos/$repo/tarball/HEAD" | tar xz -C "$dir" --strip-components=1
    printf '%s\t%s\n' "$repo" "$(gh api "repos/$repo/commits/HEAD" -q .sha)" >> "$TMP/lock"
  fi
  echo "$dir"
}

# Nearest LICENSE at or above the upstream path, so monorepo subfolders keep theirs.
license_for() {
  local root="$1" dir="$1/$2"
  [ -d "$dir" ] || dir="$(dirname "$dir")"
  while :; do
    for f in LICENSE LICENSE.md LICENSE.txt; do
      [ -f "$dir/$f" ] && { echo "$dir/$f"; return; }
    done
    [ "$dir" = "$root" ] && return 1
    dir="$(dirname "$dir")"
  done
}

while IFS=$'\t' read -r kind name repo path; do
  case "$kind" in ''|\#*) continue ;; esac
  src="$(fetch "$repo")"
  lic="$(license_for "$src" "$path")" || { echo "no license found for $repo/$path" >&2; exit 1; }
  case "$kind" in
    skill)
      rm -rf "$REPO/skills/$name"
      cp -R "$src/$path" "$REPO/skills/$name"
      [ -e "$REPO/skills/$name/LICENSE" ] || cp "$lic" "$REPO/skills/$name/LICENSE"
      [ -f "$src/NOTICE.md" ] && cp "$src/NOTICE.md" "$REPO/skills/$name/NOTICE.md"
      ;;
    agent)
      mkdir -p "$REPO/agents"
      cp "$src/$path" "$REPO/agents/$name.md"
      cp "$lic" "$REPO/agents/LICENSE.${repo//\//_}"
      ;;
  esac
  echo "synced $kind $name from $repo"
done < "$REPO/sources.tsv"

sort -u "$TMP/lock" > "$REPO/sources.lock"
