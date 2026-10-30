# Agent instructions

Shared across all my machines. Edit this in the `fleet` repo, not in place.

## How I work

- 

## Conventions

- Vendored skills stay unedited so `sync.sh` can refresh them. These rules adjust them.
- `file-pr`: when the repository sets out what a PR description must contain, include all of it. Keep this skill's short, problem-first style.
- `sol-loop`: a finding counts only when a run proves it (a failing test, a repro, or command output). Decline the rest.
- `blast-radius`: skip the optional `arena` step. `how` and `why` are not installed, so get the PR and commit history with `git` and `gh`.
- `full-send`: in Workhub, use `full-stop` instead for changes to `packages/` or to migrations.
