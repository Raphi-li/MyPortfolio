---
name: aufgabe
description: Start any change on raphi.li other than adding a project – a design change, new section or feature, bug fix, text fix, accessibility fix, CV/experience update, dependency or CI change – as its own Orca worktree with a Task-Lead, PR and review. Use when Raphi asks to change, fix, redesign or update something on the site, or says "/aufgabe".
argument-hint: "<what to change>"
---

# Start a task on raphi.li (Portfolio-Lead)

## 1. Shape the task

- Kind and slug: `feat-<slug>` (feature, design, new section), `fix-<slug>` (bug, text, a11y), `chore-<slug>` (deps, CI, agents).
- Clarify with AskUserQuestion only what changes the result: scope, which pages, design reference (Figma link, screenshot, site), DE/EN texts if Raphi has them, what must stay as it is.
- Pick the agents for the spec: look/feel → `design` (+ `frontend`); logic/pages → `frontend`; texts/CV → `content-autor`; images → `media`. `qa` and `a11y` always.

## 2. Start it

```sh
orca orchestration worker-start --worktree new-top-level --name <feat|fix|chore>-<slug> \
  --base-branch main --display-name "<short title>" --comment "<what, why>" \
  --agent claude --keep-open --task-title "<short title>" --spec-file - --json <<'SPEC'
You are Task-Lead for "<title>". Follow the section "Task-Lead" in .claude/CLAUDE.md.
Goal: <outcome Raphi wants>
Agents: <design / frontend / content-autor / media> then qa + a11y, review, release (pr)
References: <Figma links, pages, screenshots>
Must not change: <…>
SPEC
```

No `--model` flag. End your turn; handle `ask`, `worker_done` and "merge" as in `/projekt-aufnehmen` step 3.

## Several tasks at once

Independent tasks may run in parallel, each in its own worktree. Tasks touching the same files (e.g. two design changes to `theme.css`) run one after the other – start the second after the first is merged.
