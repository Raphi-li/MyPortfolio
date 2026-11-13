---
name: quellen
description: How to read every kind of project source for the portfolio – OneDrive/local files (PDF, PPTX, DOCX, XLSX, images incl. HEIC/TIFF, video, ZIP), Obsidian study notes, Figma Design and FigJam, Miro boards, GitHub/GitLab repos, websites and Google Drive – with the tools and scripts to extract text, images, PDF pages, slides and video stills. Load before collecting project material or exporting assets.
user-invocable: false
---

# Reading project sources

Work **read-only** on every source. Put everything you extract into the task's `.work/<id>/` (gitignored). Scripts live next to this file in `scripts/` – call them with their path from the repo root: `.claude/skills/quellen/scripts/<name>`.

## Local files and OneDrive

- **OneDrive root on this device:** `.claude/skills/quellen/scripts/onedrive-root.sh` (honours `PORTFOLIO_ONEDRIVE`; exit 3 = not found → ask Raphi for the path). Paths differ per device – never hard-code `/Users/...`.
- Typical places under the root: course material `Fachhochschule_OST/Digital_Design/Semester_<N>/<Module>/`, Raphi's Obsidian study notes `Apps/ObsidianOneDrive/Digital Design/Semester <N>/<Module>/` (weekly summaries – good for context and wording, but they are notes, not proof of results). Local code projects often sit in `~/WebstormProjects/<name>`.
- Files may be online-only placeholders: reading them downloads them; large videos can take minutes – say so.
- Inventory: `find "<dir>" -type f -not -name .DS_Store | head -200` and sizes with `du -sh`.

| Type | Read text | Get images |
| --- | --- | --- |
| PDF | Read tool (with `pages` for > 10 pages) or `pdftotext -layout "<f>" .work/<id>/extract/<name>.txt` | `scripts/pdf-pages.sh "<f>" <outdir> [first] [last] [dpi]` |
| PPTX / KEY export | `scripts/office-text.sh "<f>"` (slide by slide) | embedded media: `unzip -o -j "<f>" 'ppt/media/*' -d <outdir>`; whole slides: if `soffice` exists `soffice --headless --convert-to pdf --outdir <outdir> "<f>"` then `pdf-pages.sh`, otherwise ask Raphi for a PDF export |
| DOCX | `textutil -convert txt -stdout "<f>"` or `scripts/office-text.sh` | `unzip -o -j "<f>" 'word/media/*' -d <outdir>` |
| XLSX / CSV | `scripts/office-text.sh "<f>"` (shared strings + sheet cells, rough) or the `xlsx` skill if available | – |
| PNG / JPG / WebP | Read tool shows the image | as is |
| HEIC / TIFF | Read after `sips -s format png "<f>" --out <outdir>/<name>.png` | same |
| Video (mp4, mov) | – | `scripts/video-stills.sh "<f>" <outdir> [count]` (ffmpeg; without ffmpeg only one Quick Look thumbnail) |
| ZIP | `unzip -l "<f>"` | `unzip -o "<f>" -d .work/<id>/unzipped/<name>` then treat the files by type |
| Figma `.fig` file on disk | not readable – ask for the Figma link | – |

## Figma Design and FigJam (Figma MCP plugin)

- Links: `figma.com/design/<fileKey>/…?node-id=1-2` (node id `1:2`), `figma.com/proto/<fileKey>/…` (prototype – same fileKey; keep the link as `links.prototype`, with `hide-ui=1`), `figma.com/board/<fileKey>/…` (FigJam).
- Call `create_session` with the fileKey first, then: `get_metadata` (structure of a page/frame), `get_screenshot` (image of a frame – asset candidates), `get_figjam` (FigJam boards), `get_design_context` only after loading `figma:figma-design-to-code`. Load `figma:figma-use` before anything else in a file.
- Read-only. No Figma AI generation (it uses the team's credits).
- Not signed in / plugin missing → BLOCKED: "Figma plugin not connected on this device".

## Miro (MCP server `miro` from `.mcp.json`)

- Board links `miro.com/app/board/<boardId>=/…`. Use the Miro MCP tools to list and read board items (sticky notes, frames, text, images); connectors/arrows may not come through – describe structure from frames instead.
- First use on a device needs `/mcp` → sign in to Miro. Missing tools → BLOCKED with that hint.

## Code repositories

- GitHub: `gh repo view <owner>/<repo>`, README `gh api repos/<owner>/<repo>/readme --jq .content | base64 -d`, languages, topics, homepage, releases; screenshots from the live site rather than cloning. If a clone is needed: `git clone --depth 1 <url> .work/<id>/repo` and never copy `.env*`, keys or tokens.
- Raphi has two GitHub accounts (Raphi-li, Raphael-Seiler); if a repo is not found, try `gh auth switch` only after asking.
- OST GitLab (`gitlab.ost.ch`): use the local clone if one exists (e.g. `~/WebstormProjects/<repo>`); otherwise ask.

## Websites

- Text: WebFetch. Rendering and screenshots: Playwright MCP (`browser_navigate`, `browser_take_screenshot`; desktop 1440×900, mobile 390×844). Respect robots and copyright – screenshots of Raphi's own work only.

## Google Drive

- If the claude.ai Google Drive connector is available on this device, search and read files with it; otherwise ask Raphi to export the file to OneDrive.

## Source references

Write a reference for every fact: `<file> p.<n>` / `<file> slide <n>` / `Figma <fileKey> node <id>` / `Miro <boardId> frame "<name>"` / `<repo> README` / `<url>`.
