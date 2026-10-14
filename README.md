# fleet

My shared agent setup: one set of skills and one `AGENTS.md`, installed the same way on every machine I use.

## Layout

```
AGENTS.md     shared agent instructions
skills/       one directory per skill, each with a SKILL.md
install.sh    links everything into place on the current machine
```

## Install

```sh
git clone https://github.com/Syed-Ahmed02/fleet.git ~/fleet
~/fleet/install.sh
```

`install.sh` symlinks the files below to the repo, so a `git pull` updates the machine:

| Repo path        | Linked to                                   |
| ---------------- | ------------------------------------------- |
| `AGENTS.md`      | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` |
| `skills/<name>/` | `~/.claude/skills/<name>`, `~/.agents/skills/<name>` |

Any file already at a target that isn't a link into this repo gets moved to `<path>.bak.<timestamp>` first. Nothing is deleted.

## Updating

```sh
cd ~/fleet && git pull
./install.sh   # only needed when a skill is added or removed
```

## License

MIT
