---
name: projekt-aufnehmen
description: Add a new project (or rework an existing one) on raphi.li from its sources – OneDrive files, Figma/FigJam, Miro, GitHub, websites. Collects the sources and decisions from Raphi, then starts one Orca worktree with a Task-Lead that runs projekt-kurator, media, content-autor, qa, a11y, review and release. Use when Raphi says "add project …", "neues Projekt …", "put <project> on the portfolio" or "/projekt-aufnehmen".
argument-hint: "<project name> [source links or paths]"
---

# Add a project to raphi.li (Portfolio-Lead)

## 1. Collect what the Task-Lead needs

Look first, ask second: check `src/content/projects/` (does the project exist already?), and if Raphi gave a module name, list matching folders with `.claude/skills/quellen/scripts/onedrive-root.sh` + `find`.

Then ask in one AskUserQuestion round (recommended option first), only what is still unknown:
- **Sources** – OneDrive folders/files, Figma (design/proto/FigJam) links, Miro boards, repos, websites, Google Drive.
- **Project id and position** – slug (e.g. `compass`), where in the list (first = featured).
- **Team and role** – solo or team; Raphi's role; may teammates be named (first names only)?
- **Confidentiality** – client project? NDA? Anything that must not be shown?
- **Highlight/reflection** – does Raphi want to dictate them now, or answer the curator's questions later?

## 2. Start the task

```sh
orca orchestration worker-start --worktree new-top-level --name project-<id> \
  --base-branch main --display-name "Project: <title>" --comment "New portfolio project <title>" \
  --agent claude --keep-open --task-title "Project: <title>" --spec-file - --json <<'SPEC'
You are Task-Lead for "Project: <title>". Follow the section "Task-Lead" in .claude/CLAUDE.md
(workflow "New project").
Project id: <id> · position in list: <n>
Sources:
- <type>: <path or link>
Decisions by Raphi: team/role: <…>; names: <…>; confidential: <…>; highlight/reflection: <…>
Out of scope: changes to other projects, design changes beyond what this project needs.
SPEC
```

No `--model` flag (the project settings pick Fable or Opus). End your turn after starting.

## 3. While it runs

- `ask` from the Task-Lead → ask Raphi → `orca orchestration reply --id <msg> --body "<answer>"`.
- `worker_done` → report to Raphi: what the case study now says (2–3 lines), PR link, checks, preview (`cd <worktree> && npm run dev`, or open the dev URL in Orca's browser), open points.
- "merge" from Raphi → `release` in mode merge (worktree path, PR number).
