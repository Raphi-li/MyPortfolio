---
name: portfolio-content
description: Content model and house style of raphi.li – project folder layout (meta, content, links, awards, images, index), the Project types, how to add a project to the list, German/English writing style, image rules and the public-site privacy rules. Load before writing or checking any portfolio content or project images.
user-invocable: false
---

# Portfolio content (raphi.li)

## Where content lives

| Path | What |
| --- | --- |
| `src/content/projects/types.ts` | The shape of a project: `ProjectMeta`, `ProjectContent`, `ProjectLinks`, `ProjectImages`, `Figure`, `Award`, `Localized<T> = { de; en }`, `TitledText = { title; desc }` |
| `src/content/projects/<id>/` | One folder per project: `meta.ts`, `content.ts`, `links.ts`, `awards.ts`, `images/` (+ `images/index.ts`), `index.ts` |
| `src/content/projects/index.ts` | `projects: Project[]` in display order – **first = featured**; import the new project and add it |
| `src/content/experience.ts`, `timeline.ts` | CV entries and the Experience timeline (awards appear there automatically) |
| `src/app/translations.ts` | UI strings DE + EN (not project content) |

The folder name equals `meta.id`, which is also the URL `/#/projects/<id>`. Use a short lowercase slug (`fishing`, `lakers`).

## Files of a project

- **`meta.ts`** – `id`, `title` (brand spelling), `tagline` {de,en}, `description` {de,en} (one sentence for the card), `category` {de,en}, `tags` (lowercase, reuse existing ones like `ui`, `ux`, `ecommerce`), `year` ("2025"), `color` (accent hex, from the project's brand), `stats` (2–3 short {de,en} badges, e.g. "High-Fidelity Prototyp").
- **`content.ts`** – `title`, `subtitle`, `charter` (what and for whom, the brief), optional `goal`, `process` / `result` / `testing` (string or a list of `{ title, desc }` – e.g. Discover/Define/Develop/Deliver), `highlight`, `reflection`. Sections left out are not rendered – leave them out rather than padding.
- **`links.ts`** – optional `prototype` (Figma proto link with `hide-ui=1`), `website`, `repo`.
- **`awards.ts`** – `Award[]` (`status: "won" | "nominated"`, title/result/date/description {de,en}, optional image, link); `[]` with the comment `// No awards yet.` if none.
- **`images/index.ts`** – imports the image files and exports `images: ProjectImages`: `card` (overview card), optional `logo`, `hero` (one = full width, several = grid), optional `processFigures` (Figure[]), optional `highlightFigure`, `gallery` (home carousel). `Figure = { src, alt, caption?: {de,en}, blend? }`.
- **`index.ts`** – `export const <id>: Project = { meta, content, links, images, awards };`

Reference projects: `spryte` (long case study with process/testing/result lists), `fishing` (short one, process figures with `blend`).

## House style

- **German first**, Swiss spelling: «ss» never «ß», quotation marks «…», inclusive forms where natural. Then **English** with the same meaning and structure (English uses ‘…’ or "…"), natural not literal.
- Voice: charter/goal/process in "wir" for team projects, "ich" for solo work; **highlight and reflection always first person, Raphi's own voice** – from his statements only.
- Concrete over generic: methods, numbers, decisions, what changed after testing. No marketing filler, no superlatives without evidence.
- Lengths like the existing projects: charter 3–5 sentences, each process step 1–3 sentences, highlight/reflection one paragraph.
- Brand and client names in their official spelling.

## Images

- WebP, quality ~82, max 2000 px wide (`cwebp -q 82 -resize 2000 0 in.png -o out.webp`, or the `quellen` script `to-webp.sh`). Logos may stay PNG/SVG.
- File names lowercase, hyphens, no spaces or umlauts (older projects have exceptions – don't rename them).
- Alt text (English, describes the content); captions DE + EN. `blend: true` only for cut-outs on white.

## Public-site rules

The site and the repo are public. No personal data of others (teammates by first name only, and only with their agreement), no e-mail addresses, no grades or lecturer feedback, no confidential client material without Raphi's explicit OK, credits for third-party images, every fact traceable to a source in the brief.

## Checklist (new project)

1. Folder `src/content/projects/<id>/` with the six parts; `meta.id` = folder name.
2. Import + entry in `src/content/projects/index.ts` at the agreed position.
3. Every `Localized` field has `de` and `en`.
4. Images exist, imported in `images/index.ts`, sizes OK.
5. `npm run typecheck` and `npm run build` pass; page `/#/projects/<id>` renders in DE/EN, light/dark, desktop/mobile.
