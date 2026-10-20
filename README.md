# fleet

My shared agent setup: one set of skills, subagents, and `AGENTS.md`, installed the same way on every machine I use. I keep the list short on purpose: only skills I actually use.

## Skills

| Skill | From | What it's for |
| --- | --- | --- |
| `impeccable` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Frontend design, critique, and polish. Ships with four subagents in `agents/`. |
| `find-animation-opportunities` | [emilkowalski/skills](https://github.com/emilkowalski/skills) | Finds UI that should animate and proposes exact motion values. Read-only. |
| `animate` | emilkowalski/skills | Builds an animation from scratch: whether to animate, then tool, properties, curve, duration, interruption, and exit. Writes the code. |
| `review-animations` | emilkowalski/skills | Reviews motion code against a strict craft bar. `animate` writes code to pass it. |
| `pick-ui-library` | emilkowalski/skills | Recommends a library for toasts, command menus, charts, drag and drop, and similar. Run it yourself with `/pick-ui-library`; agents can't trigger it. |
| `create-verification-skill` | [pstack](https://github.com/cursor/plugins/tree/main/pstack) | Generates a project-local skill that drives the app the way a user does. |
| `maintain-verification-skill` | [pstack](https://github.com/cursor/plugins/tree/main/pstack) | Keeps that verification skill accurate over time. |
| `grill-with-docs` | [mattpocock/skills](https://github.com/mattpocock/skills) | Interview to sharpen a plan, writing ADRs and a glossary as it goes. Uses `grilling` and `domain-modeling`. |
| `grilling` | mattpocock/skills | Stress-tests a plan or idea with a round-based interview. |
| `domain-modeling` | mattpocock/skills | Maintains `GLOSSARY.md` and ADRs. |
| `to-spec` | mattpocock/skills | Turns the conversation into a spec on the issue tracker. Run `setup-matt-pocock-skills` once per repo first. |
| `to-tickets` | mattpocock/skills | Breaks a spec or plan into tracer-bullet tickets with blocking edges on the issue tracker. Run `setup-matt-pocock-skills` once per repo first. |
| `setup-matt-pocock-skills` | mattpocock/skills | Per-repo setup (issue tracker, triage labels) for `to-spec`. |
| `implement` | mattpocock/skills | Implements a spec or tickets, then reviews the work. |
| `tdd` | mattpocock/skills | Red-green test-driven development. |
| `codebase-design` | mattpocock/skills | Deep-module vocabulary used by `tdd` and design work. |
| `improve-codebase-architecture` | mattpocock/skills | Scans a codebase for deepening opportunities, writes an HTML report, then grills through the one you pick. Uses `codebase-design`, `grilling`, and `domain-modeling`. |

The skills are copied from upstream instead of being added as submodules, so a fresh clone works offline with no extra steps. `sources.tsv` lists where each one comes from and `sources.lock` pins the commit each copy was taken from.

## Layout

```
AGENTS.md     shared agent instructions
skills/       one directory per skill, each with a SKILL.md
agents/       Claude Code subagents the skills depend on
sources.tsv   upstream repo and path for every vendored skill and agent
sources.lock  upstream commit each copy was taken from
install.sh    links everything into place on the current machine
sync.sh       refreshes the copies from upstream (needs gh)
```

## Install

```sh
git clone https://github.com/Syed-Ahmed02/fleet.git ~/fleet
~/fleet/install.sh
```

`install.sh` symlinks everything back into the repo, so a `git pull` updates the machine:

| Repo path | Linked to |
| --- | --- |
| `AGENTS.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` |
| `skills/<name>/` | `~/.claude/skills/<name>`, `~/.agents/skills/<name>` |
| `agents/<name>.md` | `~/.claude/agents/<name>.md` |

If a target already exists and isn't a link into this repo, the script moves it to `~/.fleet-backups/<timestamp>/` first. Nothing is deleted, and you can safely run it again.

## Updating

On a machine:

```sh
cd ~/fleet && git pull
./install.sh   # only needed when a skill or agent is added or removed
```

To pull new versions from upstream, run `./sync.sh`, review `git diff`, and commit. To add a skill, add a line to `sources.tsv` and run `./sync.sh`.

## License

My own files (`AGENTS.md`, the scripts, this README) are MIT. Each vendored skill keeps its upstream license in its own directory: MIT for Matt Pocock's, Emil Kowalski's, and pstack; Apache 2.0 for Impeccable, with its `NOTICE.md`. The Impeccable agents' license is in `agents/LICENSE.pbakaus_impeccable`.
