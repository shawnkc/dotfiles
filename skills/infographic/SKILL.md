---
name: infographic
description: 'Generate a visually rich infographic as an HTML file from a prompt, a plan file, or the current git branch. When based on a branch, delegates to ../jira-writer to extract what changed. Outputs a self-contained HTML file with inline CSS/SVG/JS — no external dependencies. Pass --png to also export a PNG screenshot alongside the HTML. Pass --dark for a dark-mode theme with a deep navy background, bright accent colors, and glowing card borders. Pass --slidemode to generate a slide-deck layout where every section is a fixed 16×9 (1280×720 px) slide using the Toyota-style dark-navy/red-accent design system. Can also accept an existing infographic HTML and retheme it via --dark or --light without re-parsing content. Pass --help to print a usage summary and exit.'
license: MIT
allowed-tools: Bash
---

# Infographic Generator

## Overview

Produces a self-contained, visually rich HTML infographic from one of three input sources:
- **Prompt** — a freeform description of the topic
- **Plan file** — a Markdown file (e.g. a GSD `PLAN.md` or `RESEARCH.md`)
- **Branch** — the current git branch (delegates analysis to `../jira-writer`)

Output is a single `.html` file with all styles and layout inline — no external CDN, fonts, or images required. Pass `--png` to also generate a `.png` screenshot of the HTML using `puppeteer` (Node) or `webkit2png` / `chromium` (macOS fallback).

---

## Workflow

### Step 1 — Determine Input Source

Check what the user provided and follow the matching path:

| Input | Action |
|---|---|
| Freeform text / topic | Use the text directly as content |
| File path (`.md`, `.txt`) | Read the file and extract key points |
| File path (`.html`) | Check for infographic metadata — see **HTML Retheme Mode** below |
| `--branch` or no argument in a git repo | Run branch analysis (Step 2) |

**Flags** (can be combined with any input):

| Flag | Effect |
|---|---|
| `--dark` | Apply dark theme |
| `--light` | Apply light theme (default; useful for switching an existing dark infographic) |
| `--png` | Also export a PNG screenshot after generating the HTML |
| `--slidemode` | Generate a slide-deck layout: each section is a fixed 16×9 (1280×720px) slide, using the slide design system described below |
| `--help` | Print usage summary and exit — do not generate any output files |

#### Help Mode

If `--help` is the only argument (or is present alongside any other arguments), print the following help text to stdout and **stop immediately** — do not parse content, generate HTML, or produce any output files.

```
╔══════════════════════════════════════════════════════════════════════════╗
║  📊 Infographic Skill — Usage Guide                                      ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  Generates a self-contained HTML infographic (and optionally a PNG)      ║
║  from a freeform prompt, a Markdown plan file, or the current git        ║
║  branch. All output is a single .html file with inline CSS/SVG/JS —      ║
║  no external dependencies.                                               ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  INPUT SOURCES                                                           ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  <topic text>          Freeform description — used directly as content   ║
║  <file.md / .txt>      Markdown or text file — key points are extracted  ║
║  <file.html>           Existing infographic — retheme only (no reparse)  ║
║  --branch [name]       Analyze current (or named) git branch for         ║
║                        changes vs. develop and visualize the diff        ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  FLAGS                                                                   ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  --dark                Dark theme: deep navy background, vivid accent    ║
║                        colors, glowing card borders (GitHub-dark style)  ║
║  --light               Light theme (default). Useful for switching an    ║
║                        existing dark infographic back to light.          ║
║  --png                 Also export a PNG screenshot after generating     ║
║                        the HTML. Uses puppeteer, webkit2png, or Chrome   ║
║                        headless (tried in that order). Per-page PNGs     ║
║                        are produced when data-infographic-page markers   ║
║                        are present.                                      ║
║  --slidemode           Generate a slide-deck layout. Every section       ║
║                        becomes a fixed 16×9 (1280×720 px) slide using   ║
║                        the Toyota dark-navy/red-accent design system.   ║
║                        Includes: title slide, content slides, closing   ║
║                        slide.                                            ║
║  --branch [name]       Source content from git branch diff instead of   ║
║                        a prompt or file. Defaults to current branch vs. ║
║                        develop. Pass a branch name to override.          ║
║  --help                Show this help message and exit.                  ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  EXAMPLES                                                                ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  /infographic The new remote start flow with 3 steps                     ║
║  /infographic The new remote start flow --dark                           ║
║  /infographic .planning/phases/12/PLAN.md                                ║
║  /infographic .planning/phases/12/PLAN.md --dark --png                  ║
║  /infographic --branch                                                   ║
║  /infographic --branch release/3.4.0 --dark --png                       ║
║  /infographic The Q2 roadmap overview --slidemode                        ║
║  /infographic --branch --slidemode --dark --png                          ║
║  /infographic climate-feature.html --dark     (retheme only)             ║
║  /infographic climate-feature-dark.html --light                          ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

#### HTML Retheme Mode

When the input is an `.html` file, inspect it for the infographic metadata tag:

```html
<meta name="x-infographic-generator" content="infographic-skill">
```

If this tag is present:
- **Do not re-parse or regenerate content** — the HTML structure is already correct
- Read the current theme from: `<meta name="x-infographic-theme" content="light|dark">`
- Read the accent color from: `<meta name="x-infographic-accent" content="#58A6FF">`
- Apply the requested theme by replacing only the inline `<style>` block
- Preserve all content, sections, and structural HTML unchanged
- Write the output to a new file (append `-dark` or `-light` to the base name, e.g. `climate-feature-dark.html`)
- Update the `x-infographic-theme` meta tag in the output file to reflect the new theme

If the metadata tag is **not** present, the file is an unrecognized HTML — treat it as a content source, extract the visible text, and regenerate a new infographic from it.

If no theme flag is given, use the default **light** theme.

### Step 2 — Extract Content (Branch Mode Only)

Follow the **Analyze Branch Changes** workflow from `../jira-writer/SKILL.md` step 1 to extract:
- What changed and why
- Affected areas / modules
- Risk level
- Key bullet points

Use `develop` as the base branch unless the user specifies otherwise.

```bash
git log develop..HEAD --oneline
git diff develop...HEAD --stat
git diff develop...HEAD
```

### Step 3 — Structure the Content

Organize extracted content into infographic sections. Aim for 4–7 sections. Common patterns:

**For a feature/change:**
- Headline (one bold sentence)
- What Changed (3–5 bullets)
- Why It Matters (1–2 sentences + icon)
- Key Numbers / Metrics (counts, files, test coverage if available)
- Risk & Impact (color-coded: [SVG red] High / [SVG amber] Medium / [SVG green] Low)
- How to Test / What to Verify

**For a plan or concept:**
- Title + Subtitle
- Problem Statement
- Solution Overview
- Phase Breakdown or Steps
- Benefits / Outcomes
- Next Steps

### Step 3b — Slide Mode Layout (if `--slidemode`)

When `--slidemode` is passed, the infographic is rendered as a **slide deck** where every section is a fixed **16×9 canvas (1280×720 px)**. Follow these rules instead of (or in addition to) the standard layout rules in Step 4.

#### Slide Structure

The page is a vertical stack of slides. Each slide is self-contained and pixel-perfect at 16:9. The deck should have:

- **Slide 0 — Title slide** (dark navy, full bleed)
- **Slide 1–N — Content slides** (alternating backgrounds, one topic per slide)
- **Final slide — Closing / CTA slide** (dark navy, centred summary + footer)

#### Body & Slide Sizing

```css
html { overflow-x: hidden; background: #0F1923; }

body {
  width: 1280px;
  margin: 0 auto;
  font-family: '{FONT_FAMILY}', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif;
  line-height: 1.6;
  box-shadow: 0 8px 60px rgba(0,0,0,0.5);
}

.slide {
  width: 1280px;
  height: 720px;            /* 16:9 */
  aspect-ratio: 16 / 9;
  box-sizing: border-box;
  overflow: hidden;
  position: relative;
  padding: 52px 96px;
}
```

Do **not** insert any divider element between slides — slides stack directly with no separator bars.

#### Page Markers (required for per-page PNG export)

Every top-level page element — each `.slide`, the header, all `<section>` elements, and the `<footer>` — **must** carry a `data-infographic-page` attribute with a sequential 1-based integer. This allows puppeteer to screenshot each page precisely by its bounding box rather than using fixed viewport-height slices.

Standard (non-slidemode) infographics:
```html
<header data-infographic-page="1" class="header">…</header>
<section data-infographic-page="2" class="section section-white">…</section>
<section data-infographic-page="3" class="section section-consol">…</section>
<footer data-infographic-page="4" class="footer">…</footer>
```

Slidemode infographics — add the attribute to every `.slide` div:
```html
<div data-infographic-page="1" class="slide slide-title">…</div>
<div data-infographic-page="2" class="slide">…</div>
…
<div data-infographic-page="N" class="slide slide-closing">…</div>
```

> **Rule:** The `data-infographic-page` numbering must be sequential, starting at 1, with no gaps or duplicates. The footer is always the last page number.

#### Title Slide (`.slide-title`)

The title slide uses two stacked background layers — a soft left-side glow and a subtle right-side radial — to create depth without hard color edges. All classes are defined in `design-system.css`.

> **⚠️ Gradient rule:** Never use `var(--color-navy)` directly in a title slide gradient. At 3× DPI (4K export), the hard boundary between `--color-navy` (#0E2841) and `--bg-page` (#0D0D18) produces a visible artifact stripe. Always use `rgba(21,96,130,N)` fading to `transparent` for a smooth glow with no edges at any resolution.

```css
/* All of these are in design-system.css — do not re-define in the slide's inline <style> */
.slide-title { background: var(--bg-page); padding: 0; }

.title-side-bar {
  /* Soft steel-blue glow — rgba prevents hard-edge artifact at 3× DPI */
  position: absolute; left: 0; top: 0; bottom: 0; width: 520px;
  background: linear-gradient(to right, rgba(21,96,130,0.28) 0%, transparent 100%);
}
.title-geo {
  position: absolute; right: 0; top: 0; bottom: 0; width: 900px;
  background: radial-gradient(ellipse at 70% 50%, rgba(28,42,58,0.2) 0%, transparent 70%);
}
.title-content {
  position: relative; z-index: 2; display: flex; flex-direction: column;
  justify-content: center; height: 100%; padding: var(--space-8) var(--space-16);
}
.title-h1 {
  font-size: 52px; font-weight: 700; color: var(--text-primary); line-height: 1.05;
  letter-spacing: -1.5px; max-width: 720px; margin-bottom: 18px;
}
.title-h1 span { color: var(--color-toyota-red); }
.title-sub {
  font-size: var(--text-lg); color: var(--text-muted); max-width: 560px;
  line-height: 1.55; margin-bottom: 28px;
}
.title-badges { display: flex; gap: 10px; flex-wrap: wrap; }
.title-badge {
  padding: 6px 16px; border-radius: var(--radius-full);
  font-size: var(--text-sm); font-weight: 700;
  background: rgba(235,10,30,0.12); color: #FF6B7A; border: 1px solid rgba(235,10,30,0.3);
}
.title-badge-blue {
  background: rgba(0,176,240,0.10); color: var(--accent-primary);
  border: 1px solid rgba(0,176,240,0.25);
}
```

Structure:
```html
<div class="slide slide-title">
  <div class="title-side-bar"></div>   <!-- soft steel-blue left glow (rgba, fades to transparent) -->
  <div class="title-geo"></div>        <!-- subtle right-side radial overlay -->
  <div class="title-content">
    <div class="title-eyebrow">…</div>           <!-- e.g. "Division · Team · Project" — accent small caps -->
    <h1 class="title-h1">Main <span>Title</span></h1>  <!-- accent span for key word in red -->
    <p class="title-sub">…</p>                   <!-- muted subtitle, max-width 560px -->
    <div class="title-badges">
      <span class="title-badge">Tag One</span>
      <span class="title-badge title-badge-blue">Tag Two</span>
    </div>
  </div>
  <!-- Optional: .title-metrics panel (right-aligned KPI cards) -->
</div>
```

#### Content Slides

Each content slide uses a numbered section header and fills the remaining vertical space with its content. Content must not overflow — scale down font sizes, reduce padding, or use a tighter grid if needed.

**Light mode:** all content slides use the same white background — no alternating colors, no separator bars.

| Theme | Background |
|---|---|
| Light (default) | `#FFFFFF` |
| Dark callout (light deck) | `#0F1923` |
| Dark mode | `#0F1923` |

> **⛔ No alternating backgrounds in light mode.** Do NOT use tinted variants (`#FFF7F7`, `#F0FAF1`, `#FFFCF0`). Every light-mode content slide is `#FFFFFF`.

Slide header pattern (title + subtitle only — number and section label live in the footer):
```html
<div class="slide-header">
  <h2 class="slide-title-text">Section Title</h2>
  <div class="slide-subtitle">Optional secondary line</div>
</div>
```

#### Content Density Rules for Slides

Since each slide has a fixed 720px height and 52px top/bottom padding (leaving ≈616px usable), content must be **tight and scannable**:

- Use 3-column grids for card sets (max 6 cards per slide — 3×2)
- Keep card body text at `font-size: 11–12px`, titles at `13–14px`
- Limit bullet text to 1–2 lines per item
- Use icon + title + short description (no more than 2 sentences)
- If content doesn't fit in one slide, split across two slides with a consistent label (e.g., "Part 1 of 2")
- Section headers should be compact: `margin-bottom: 18–24px`

#### Closing Slide (`.slide-closing`)

Dark navy, flex-column layout (`display:flex; flex-direction:column`) with:
- A large summary statement or key takeaway quote
- Sub-caption in muted colour
- Optional: small grid of 2–4 outcome pills/badges
- The standard CXD `<footer class="footer">` as the **last flex child** with `margin-top: auto` (see **Footer Specification** → "Correct placement — slidemode"). Never use `position:absolute`.

#### Backup / Appendix Divider Slide (`.slide-backup-divider`) — **REQUIRED before backup slides**

When a deck has backup or appendix slides, **always insert a full-bleed dark divider slide** immediately before them. This is the visual separator that signals the transition from main content to supplemental slides. The `slide-backup-divider` class and all sub-classes are defined in `design-system.css`.

```html
<div data-infographic-page="N" class="slide slide-backup-divider">
  <div class="sbd-grid"></div>
  <div class="sbd-content">
    <div class="sbd-eyebrow">Appendix</div>
    <div class="sbd-word">BACKUP</div>
    <div class="sbd-sub">Supporting &amp; reference slides follow</div>
  </div>
</div>

> **Rules:**
> - No footer on the backup divider slide — omit the `<footer>` entirely
> - Count this slide in the total (`data-infographic-page` sequence)

#### CSS Variables for Slide Mode

Add these to `:root` in addition to the standard theme variables:

```css
:root {
  /* … standard theme vars … */
  --slide-w: 1280px;
  --slide-h: 720px;
  --slide-pad-x: 96px;
  --slide-pad-y: 52px;
}
```

#### Slide Mode Meta Tag

Add an extra metadata tag when `--slidemode` is used:

```html
<meta name="x-infographic-mode" content="slidemode">
```

---

### Step 3c — Source Icons via Iconify CDN

**Before writing any HTML**, identify all icons needed in the infographic (one per card, section header, alert, etc.) and **fetch real SVG content from the Iconify API using `curl`**.

> **Rule:** Never hand-write `<path d="…">` data. SVG path strings are error-prone and produce broken icons that are impossible to verify without rendering. Always `curl` from Iconify.

#### Fetch workflow (required for every icon)

For each icon needed, run:

```bash
curl -s "https://api.iconify.design/tabler:{icon-name}.svg"
```

This returns a verified, production-quality inline SVG. Store the output as a shell/Python variable and inject it verbatim at the point of use.

```bash
# Example: fetch multiple icons at once
ICON_ALERT=$(curl -s "https://api.iconify.design/tabler:alert-triangle.svg")
ICON_ROUTE=$(curl -s "https://api.iconify.design/tabler:arrows-split-2.svg")
ICON_BUG=$(curl -s "https://api.iconify.design/tabler:bug.svg")
ICON_FIX=$(curl -s "https://api.iconify.design/tabler:tool.svg")
ICON_LOCK=$(curl -s "https://api.iconify.design/tabler:lock.svg")
ICON_CODE=$(curl -s "https://api.iconify.design/tabler:code.svg")
ICON_SHIELD_OFF=$(curl -s "https://api.iconify.design/tabler:shield-x.svg")
ICON_SHIELD_OK=$(curl -s "https://api.iconify.design/tabler:shield-check.svg")
ICON_CHECK=$(curl -s "https://api.iconify.design/tabler:circle-check.svg")
```

#### Common Tabler icon names

| Concept | Icon name |
|---|---|
| Warning / gap / alert | `alert-triangle` |
| Split paths / entry points | `arrows-split-2` |
| Route / waypoints | `route` |
| Missing guard / shield broken | `shield-x` |
| Correct / protected path | `shield-check` |
| Bug / defect | `bug` |
| Fix / wrench | `tool` |
| Lock / auth / capability | `lock` |
| Code / syntax | `code` |
| Success / check | `circle-check` |
| Car / vehicle | `car` |
| Graph / metric | `chart-bar` |
| Database | `database` |
| Clock / time | `clock` |
| User | `user` |

Browse all 6,000+ names at: **https://tabler.io/icons**

For non-Tabler icons use Iconify's universal API: `https://api.iconify.design/{set}:{name}.svg`
(e.g. `ph:rocket-bold` for Phosphor, `heroicons:shield-check` for Heroicons)

#### Requirements for sourced icons

- **Format:** inline SVG (`<svg>…</svg>`) only — no `<img src>`, no base64 PNG icons
- **Color:** Iconify returns `currentColor` strokes — do not override; CSS controls the color
- **Size:** all Tabler icons use `viewBox="0 0 24 24"`, rendered at 20–24px via CSS
- **License:** Tabler = MIT, Phosphor = MIT, Heroicons = MIT — no attribution required

Store fetched SVG markup and inject at the point of use:

```html
<div class="cc-icon">
  <!-- SVG fetched via: curl -s "https://api.iconify.design/tabler:rocket.svg" -->
  <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24">
    <path fill="none" stroke="currentColor" stroke-linecap="round"
          stroke-linejoin="round" stroke-width="2" d="…actual path from curl…"/>
  </svg>
</div>
```

> **Rule:** Never place Unicode emoji in `.cc-icon`, `.card-media`, or any other visual slot. Emoji may only appear in conversational assistant text, never in generated HTML output.

---

### Step 3d — Load Brand Fonts and CXD Logo

Before writing any HTML, load the brand assets from the skill's canonical asset directory and base64-encode them for inline embedding. This keeps the output fully self-contained.

#### Font Selection Logic

Always use `ToyotaType` for every infographic — light, dark, and slidemode. Never use Nobel or any other font family.

| Font file | Weight | Style |
|---|---|---|
| `ToyotaType-Regular.ttf` | 400 | normal |
| `ToyotaType-Bold.ttf` | 700 | normal |

> **Rule:** Use exactly one font family per infographic. Always `ToyotaType` — never Nobel, Lexus, or any other brand font.

#### Asset Loading (run via bash before generating HTML)

```bash
SKILL_ASSETS="$HOME/.agents/skills/infographic/assets"

# CXD logo for footer
CXD_LOGO_B64=$(base64 -i "$SKILL_ASSETS/cxd.png" | tr -d '\n')

# Absolute path to the external design system CSS
DESIGN_SYSTEM_CSS="$SKILL_ASSETS/design-system.css"
```

Every generated HTML file **must** link to the external `design-system.css` via an absolute path `<link>` tag placed in `<head>` — **do not embed the CSS inline**. Fonts remain embedded as base64 (they cannot be externally referenced portably). The only inline `<style>` block should contain:
1. `@font-face` declarations (base64-embedded fonts)
2. Page/slide-specific layout CSS that is not part of the design system

```html
<link rel="stylesheet" href="/Users/shawn.casey1/.agents/skills/infographic/assets/design-system.css">
```

> **Single source of truth:** All color, spacing, shadow, radius, and component styles live exclusively in `assets/design-system.css`. Any update to that file is automatically reflected in all generated infographics when opened. Never copy token values into the inline `<style>` — use the CSS variables by name.

#### @font-face Declarations

Place these **at the very top of the `<style>` block**, before the `:root` variables:

```css
@font-face {
  font-family: '{FONT_FAMILY}';
  src: url('data:font/truetype;base64,{FONT_REGULAR}') format('truetype');
  font-weight: 400;
  font-style: normal;
  font-display: block;
}
@font-face {
  font-family: '{FONT_FAMILY}';
  src: url('data:font/truetype;base64,{FONT_BOLD}') format('truetype');
  font-weight: 700;
  font-style: normal;
  font-display: block;
}
```

Apply the font on `body`:

```css
body {
  font-family: '{FONT_FAMILY}', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif;
}
```

---

### Step 3e — Format Swift Code Snippets

Before writing any HTML, run every Swift code block through `swiftformat` so indentation and style are consistent. Both `swiftformat` and `swiftlint` are available at `/opt/homebrew/bin/`; use `swiftformat` (it is a formatter, not just a linter).

#### Workflow (run once per Swift snippet)

```bash
# Write the raw snippet to a temp file, format in-place, then read it back
SWIFT_TMP=$(mktemp /tmp/infographic-swift-XXXXXX.swift)
cat > "$SWIFT_TMP" << 'SWIFT_EOF'
{raw Swift code here}
SWIFT_EOF

/opt/homebrew/bin/swiftformat "$SWIFT_TMP" --quiet 2>/dev/null
FORMATTED_SWIFT=$(cat "$SWIFT_TMP")
rm -f "$SWIFT_TMP"
```

Use `$FORMATTED_SWIFT` as the content of the `<pre><code>` block in the HTML. HTML-escape `<`, `>`, and `&` after formatting:

```bash
ESCAPED=$(echo "$FORMATTED_SWIFT" \
  | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
```

> **Rule:** Never embed raw, hand-indented Swift in the HTML output. Always pass it through `swiftformat` first. If `swiftformat` exits non-zero, fall back to the original snippet and log a warning.

---

### Step 4 — Design the Infographic

Generate a self-contained HTML file following these design rules:

#### Layout
- Use CSS Grid or Flexbox — no external frameworks
- Responsive: readable at 1200px wide, printable at A4/letter
- Card-based layout with clear visual hierarchy
- Max 2–3 columns depending on content density

#### Theme Selection

All token values come from `assets/design-system.html` — extract them verbatim (Step 3d). The tables below show which token serves each role; look up actual values in the file.

---

##### 🌕 Light Theme (default)

Token source: `:root` block · Font: `ToyotaType`

| Role | Token |
|---|---|
| Page background | `--bg-page` |
| Card / surface | `--bg-surface` |
| Surface alt (section bg) | `--bg-surface-2` |
| Header background | gradient: `--color-navy` → `--color-blue` |
| Title text | `--text-primary` |
| Body / muted text | `--text-primary` / `--text-muted` |
| Secondary labels | `--text-secondary` |
| Accent (primary) | `--accent-primary` (Steel Blue) |
| Accent (CTA / highlight) | `--accent-secondary` (Orange) |
| Border subtle / default | `--border-subtle` / `--border-default` |
| Card shadow | `--shadow-md` |
| Hover shadow | `--shadow-lg` |

**Badge variants:** `badge-primary` · `badge-orange` · `badge-green` · `badge-sky` · `badge-purple` · `badge-navy` — styles defined in `design-system.html`.

**Risk indicators:** use `.badge-red` / `.badge-orange` / `.badge-green` for danger/caution/safe — never color emoji circles

---

##### 🌑 Dark Theme (`--dark`)

Token source: `[data-theme="dark"]` overrides · Font: `ToyotaType`

| Role | Token |
|---|---|
| Page background | `--bg-page` |
| Card / surface | `--bg-surface` |
| Surface alt | `--bg-surface-2` |
| Header background | gradient: `--color-dark-bg` → `--color-dark-navy` |
| Title / body text | `--text-primary` |
| Muted text | `--text-muted` |
| Secondary labels | `--text-secondary` (Electric Blue) |
| Accent (primary) | `--accent-primary` (Electric Blue) |
| Accent (CTA) | `--accent-secondary` (Orange — unchanged) |
| Border subtle / default | `--border-subtle` / `--border-default` |
| Card shadow | `--shadow-md` |
| Glow / hover shadow | `--shadow-lg` |

- **Accent usage**: section header left-border `4px solid var(--accent-primary)`, featured card glow `box-shadow: 0 0 16px var(--accent-primary)33`
- **Badge dark variants** — styles defined in `design-system.html` under `[data-theme="dark"]`
- **Risk indicators (dark):** use `.badge-red` / `.badge-orange` / `.badge-green` — values in design system, never emoji

---

##### Shared rules (both themes)

- **Single source of truth**: all token values come from `assets/design-system.html`. Never invent hex values.
- **Spacing**: `--space-*` scale (4 px base grid: `--space-1` … `--space-24`). Card padding = `--space-5`, section gap = `--space-8`.
- **Border radius**: `--radius-sm` for badges/chips · `--radius-md` for cards · `--radius-lg` for hero elements · `--radius-full` for pills.
- **Shadows**: `--shadow-sm / md / lg / xl` — navy-tinted in light, black-tinted in dark.
- **Fonts**: `ToyotaType` for all themes — never Nobel or any Lexus brand font
- **Icons/art**: always use the `find-graphics` skill (or `graphics-finder` agent) to source inline SVG icons — never use Unicode emoji in visual deliverables. Request `currentColor` SVGs so they inherit CSS color.
- Pure CSS bars or inline SVG for charts/progress
- Viewport width 1400px, `fullPage: true` for PNG export

#### Component Usage (REQUIRED)

**Do not invent custom card or badge styles.** Always use the component classes defined in `assets/design-system.html`. These are extracted verbatim in Step 3d and embedded in the output HTML's `<style>` block.

**Icons:** Always source inline SVG icons via the `find-graphics` skill or `graphics-finder` agent **before** writing any HTML. Use `currentColor` SVGs so the icon inherits CSS color. Never use Unicode emoji as icons in generated infographics.

**Card selection guide:**
| Use case | Component |
|---|---|
| Large KPI / metric number | `.card-stat` (`cs-good` / `cs-bad` / neutral) |
| Named item with icon, key, description, meta | `.epic-card` + `.icon-*` + `.epic-grid` |
| Colored callout / problem statement | `.card-ds` + color variant |
| Outcome insight with bullet list | `.card-content` + color variant |
| Schedule / roadmap list | `.card-list` |

##### Cards

Use the `.card` component for any content panel, info box, or grouped section:

```html
<div class="card">
  <div class="card-body">
    <div class="card-label">Category Label</div>     <!-- accent-colored eyebrow -->
    <div class="card-title">Card Heading</div>        <!-- bold, display font -->
    <div class="card-text">Supporting body copy.</div><!-- muted, 14px -->
  </div>
</div>
```

For cards with a header bar or media area:
```html
<div class="card">
  <div class="card-media"><!-- gradient bar or SVG icon (currentColor) --></div>
  <div class="card-body">…</div>
</div>
```

For two-tone outcome/insight cards with label, large title, and bullet list, use `.card-content`:
```html
<div class="card-content cc-blue">
  <div class="cc-header">
    <div class="cc-header-top">
      <div class="cc-label">Category subtitle — one line, truncated</div>
      <div class="cc-icon"><!-- inline SVG 20×20, currentColor --></div>
    </div>
    <div class="cc-title">Large Headline Title</div>
  </div>
  <div class="cc-divider"></div>
  <div class="cc-body">
    <ul class="cc-list">
      <li>Bullet item one</li>
      <li>Bullet item two</li>
    </ul>
  </div>
</div>
```
Color variants: `cc-blue` · `cc-green` · `cc-red` · `cc-orange` · `cc-sky` · `cc-purple`

For large KPI/metric display cards with semantic background shading, use `.card-stat`:
```html
<!-- neutral (default) — navy-tinted surface, informational -->
<div class="card-stat">
  <div class="cs-value">50</div>
  <div class="cs-label">Mobile Engineers</div>
  <div class="cs-detail">Optional sub-detail line</div>
</div>

<!-- good — green-tinted, positive metric -->
<div class="card-stat cs-good">
  <div class="cs-value">141</div>
  <div class="cs-label">PRs Merged / Sprint</div>
</div>

<!-- bad — red-tinted, problem metric -->
<div class="card-stat cs-bad">
  <div class="cs-value">3 days</div>
  <div class="cs-label">Avg PR Pipeline Time</div>
</div>
```
Semantic themes: default (neutral) · `cs-good` (green) · `cs-bad` (red)

The `.card` and `.card-content` and `.card-stat` classes provide `border: 1px solid var(--border-subtle)`, `border-radius: var(--radius-xl)`, `box-shadow: var(--shadow-sm)`. Never re-implement these on custom classes.

##### Design Card (`.card-ds`) — **Approved pattern for colored informational cards**

Use `.card-ds` + a color variant for any card that needs a colored accent label and a horizontal divider. This is the **approved replacement** for the old `border-left` alert/box pattern.

> **⛔ Do NOT use `border-left: N px solid <color>` on info boxes** — this is an unapproved design pattern. Use `.card-ds` instead.

Color variants: `cds-red` · `cds-blue` · `cds-amber` · `cds-green` · `cds-purple` · `cds-sky`

```html
<div class="card-ds cds-blue">
  <div class="cds-header">
    <div class="cds-top">
      <div class="cds-label">01 · Category</div>
      <div class="cds-icon"><!-- 18×18 inline SVG, currentColor --></div>
    </div>
    <div class="cds-title">Card Headline</div>
  </div>
  <div class="cds-divider"></div>
  <div class="cds-body">
    <p class="cds-p">Body copy here.</p>
    <!-- OR: a bullet list -->
    <ul class="cds-list">
      <li>Item one</li>
      <li>Item two</li>
    </ul>
  </div>
</div>
```

For a **problem statement** or prominent callout (no body needed), use the header-only form:

```html
<div class="card-ds cds-red" style="flex-shrink:0">
  <div class="cds-header">
    <div class="cds-top"><div class="cds-label">Problem Statement</div></div>
    <div class="cds-title" style="font-size:12px;font-weight:400;color:var(--text-primary);line-height:1.5">
      Long description text here.
    </div>
  </div>
  <div class="cds-divider"></div>
</div>
```

##### Epic Card (`.epic-card`) — **Named work-item detail card**

Use `.epic-card` for any named deliverable, feature, task, or work item that needs icon + key + title + description + meta rows. This is the correct pattern for "Closed Epics", "Active Work", or any item-level detail grid.

> **Preferred over `card-ds`** when showing named items with metadata (stories, progress, dates). Use `card-ds` for informational callouts; use `epic-card` for item cards.

Layout grids: `.epic-grid` (3-column) · `.epic-grid-2` (2-column)

Icon color helpers (pair with `.epic-card-icon`): `.icon-green` · `.icon-blue` · `.icon-orange` · `.icon-red` · `.icon-purple` · `.icon-sky`

Progress fill colors: `.fill-green` · `.fill-orange` · `.fill-blue` · `.fill-red` · `.fill-purple`

```html
<div class="epic-grid">
  <div class="epic-card">
    <div class="epic-card-header">
      <div>
        <div class="epic-card-icon icon-green"><!-- inline SVG 18×18, currentColor --></div>
        <div class="epic-card-key">KEY-123</div>
        <div class="epic-card-title">Feature Name</div>
      </div>
      <span class="badge badge-green">Done</span>
    </div>
    <div class="epic-card-body">
      <div class="epic-card-desc">Short description of the work item and its outcomes.</div>
      <div class="epic-card-meta">
        <div class="epic-meta-row">
          <span class="epic-meta-label">Stories</span>
          <span class="epic-meta-val">12 Done · 2 Open</span>
        </div>
      </div>
      <div class="epic-progress-bar">
        <div class="epic-progress-fill fill-green" style="width:85%"></div>
      </div>
    </div>
  </div>
</div>
```

##### Badges / Pills / Status Tags

Use `.badge` + a variant modifier for **every** status indicator, pill, tag, or label chip:

```html
<span class="badge badge-primary">In Review</span>
<span class="badge badge-green">Complete</span>
<span class="badge badge-orange">In Progress</span>
<span class="badge badge-sky">Planned</span>
<span class="badge badge-purple">Blocked</span>
<span class="badge badge-navy">Archived</span>
```

| Status | Badge class |
|---|---|
| Complete / Done / Shipped | `.badge.badge-green` |
| In Progress / WIP / Active | `.badge.badge-orange` |
| In Review / Pending | `.badge.badge-primary` |
| Planned / Upcoming | `.badge.badge-sky` |
| Blocked / At Risk | `.badge.badge-purple` |
| Archived / Deprecated | `.badge.badge-navy` |

**Never** create custom pill classes (e.g. `rm-pill-wip`, `.pill-complete`, `.status-tag`). Always use `.badge-*` variants from the design system.

##### Alerts

Use `.alert` + variant for callout boxes:
```html
<div class="alert alert-info">Informational callout</div>
<div class="alert alert-success">Success message</div>
<div class="alert alert-warning">Warning or caution</div>
<div class="alert alert-error">Error or critical issue</div>
```

#### Sections to always include
- A bold header banner with the title and a one-line subtitle
- A footer (see **Footer Specification** below)

#### Footer Specification

Every infographic — standard and slidemode — **must** end with a footer that matches the Connected Experiences Division brand.

##### Footer DOM Placement (CRITICAL)

> **⛔ NEVER use `position:absolute` for a footer inside a `.slide` div.**
>
> The CXD logo (`cxd.png`) base64-encodes to ~60 KB of characters inside the `<img src="data:image/png;base64,…">` attribute. Any string-based tool that removes the wrapper `<div class="footer">` will leave this orphaned blob as raw text in the document, corrupting the HTML irreparably. Browsers render garbage; PNG export silently breaks.

**Correct placement — standard infographics:**

The `<footer>` is a direct child of `<body>`, placed after all `<header>` and `<section>` elements. It is never nested inside a section, card, or content div.

```html
<body>
  <header data-infographic-page="1">…</header>
  <section data-infographic-page="2">…</section>
  <section data-infographic-page="3">…</section>
  <footer data-infographic-page="4" class="footer">…</footer>
</body>
```

**Correct placement — slidemode (closing slide footer):**

The CXD footer lives inside the closing slide's flex column, pushed to the bottom with `margin-top: auto`. The slide must use `display: flex; flex-direction: column`.

```html
<div data-infographic-page="N" class="slide slide-closing"
     style="display:flex;flex-direction:column;padding:52px 96px;">
  <!-- closing content (headline, badges, etc.) -->
  <footer class="footer" style="margin-top:auto;">…</footer>
</div>
```

**Correct placement — slidemode (ALL content slides):**

Every content slide uses the full CXD footer (same as the closing slide). All slides must use `display:flex;flex-direction:column` so the footer can use `margin-top:auto`:

```html
<div class="slide" style="display:flex;flex-direction:column;">
  <!-- slide content -->
  <footer class="footer" style="margin-top:auto;">
    <div class="footer-brand">
      <img src="data:image/png;base64,{CXD_LOGO_B64}" alt="CXD" class="footer-logo-img">
      <div>
        <div class="footer-name">Connected Experiences Division</div>
        <div class="footer-sub">Mobile Engineering &nbsp;·&nbsp; Toyota Motor North America</div>
      </div>
    </div>
    <div class="footer-right">
      <div class="footer-slide-label">{Section Label}</div>
      <div class="footer-page-num">{N} / {TOTAL}</div>
    </div>
  </footer>
</div>
```

> **⛔ No compact bar:** Do NOT use a `slide-footer-bar` div or a reduced-size logo on any slide. Every slide uses the identical full footer.

> **Footer background is transparent** — the `.footer` class has `background: transparent` so the slide background shows through. Do NOT add a background color.

> **Footer padding** — negative margins (`-96px` left/right, `-52px` bottom) break the footer flush to the slide's outer edges. Internal padding is `14px 96px 14px` — 14px top creates breathing room from slide content; 96px left/right keeps inner content aligned with the slide's own padding.

**Slides with NO footer** (title slides, backup-divider slides): simply omit the footer entirely — do not add an empty div or hidden element.

> **⛔ No slide-num-circle:** Do not use `.slide-num-circle` or any large standalone number element at the top of content slides. The slide number and section label appear only in the footer's `.footer-right` element.

##### Footer CSS & HTML

> **The `.footer`, `.footer-brand`, `.footer-logo-img`, `.footer-name`, `.footer-sub`, `.footer-right`, `.footer-slide-label`, and `.footer-page-num` classes are defined in `assets/design-system.css`** — do NOT re-define them in the inline `<style>` block.

Use this exact HTML structure for ALL content and closing slides:

```html
<footer class="footer" style="margin-top:auto;">
  <div class="footer-brand">
    <img src="data:image/png;base64,{CXD_LOGO_B64}" alt="CXD" class="footer-logo-img">
    <div>
      <div class="footer-name">Connected Experiences Division</div>
      <div class="footer-sub">Mobile Engineering &nbsp;·&nbsp; Toyota Motor North America</div>
    </div>
  </div>
  <div class="footer-right">
    <div class="footer-slide-label">{Section Label}</div>
    <div class="footer-page-num">{N} / {TOTAL}</div>
  </div>
</footer>
```

> **⛔ No footer-meta:** Never include a "Generated [date]" or "Source: [file]" section in any footer.

Key sizing from design-system.css (do not override):
- `.footer-logo-img` → `height: 48px` (used on all slides)
- `.footer` → `margin: 0 -96px -52px; padding: 14px 96px 14px` — flush left/right/bottom against slide edges, 14px top padding separates from slide content

#### Code Structure

Every generated infographic **must** include the following metadata tags in `<head>`. These enable theme-swapping without content re-parsing on future invocations:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Infographic skill metadata — do not remove -->
  <meta name="x-infographic-generator" content="infographic-skill">
  <meta name="x-infographic-theme" content="light">  <!-- or: dark -->
  <meta name="x-infographic-accent" content="{accent-hex}">
  <meta name="x-infographic-source" content="branch|file|prompt">
  <meta name="x-infographic-generated" content="{ISO-8601-date}">

  <title>{Title}</title>
  <!-- Design system: tokens + all component classes (card-content, card-stat, card-list, badges…) -->
  <link rel="stylesheet" href="/Users/shawn.casey1/.agents/skills/infographic/assets/design-system.css">

  <style>
    /* ─── Brand Fonts (embedded base64 from Step 3d) ─── */
    @font-face { … }   /* ToyotaType — inserted by Step 3d */

    /*
     * ─── Page / Slide-specific CSS only ─────────────────────────────────────
     * All token values (colors, spacing, shadows, radii, components) come from
     * the linked design-system.css above. Use CSS variables by name:
     *
     *   Colors:   --color-navy, --color-blue, --color-orange …
     *   Semantic: --bg-page, --bg-surface, --bg-surface-2
     *             --text-primary, --text-secondary, --text-muted
     *             --border-subtle, --border-default
     *             --accent-primary, --accent-secondary
     *   Scale:    --space-1 … --space-24  (4 px base grid)
     *             --radius-sm … --radius-full
     *             --shadow-sm … --shadow-xl
     *
     * DO NOT copy token values here. DO NOT re-define component classes
     * (.card-content, .card-stat, .card-list, .badge-*, etc.) — they are
     * already provided by design-system.css.
     * ────────────────────────────────────────────────────────────────────────
     */
  </style>
</head>
<body>
  <!-- Header banner -->
  <!-- Card grid -->
  <!-- Footer -->
</body>
</html>
```

> **Important:** All theme colors in the CSS must use the `:root` CSS variables from `design-system.css` (linked in `<head>`) — never hardcode hex values directly into selectors. Always set `data-theme="dark"` on `<html>` when generating a dark infographic.

### Step 5 — Write Output File

Save the HTML file to the current working directory:

```bash
# New infographic: filename derived from title or branch name, lowercase-hyphenated
# e.g. climate-feature-update.html, q2-roadmap.html

# Retheme of existing file: append theme suffix to base name
# e.g. climate-feature-update-dark.html, climate-feature-update-light.html
```

Ensure all five `x-infographic-*` metadata tags (see Code Structure above) are present and accurate in the written file.

### Step 6 — Export to PDF or PNG

#### PDF export (single-page, no page breaks)

When the user asks for a PDF, measure the full content height and generate a single-page PDF at that exact height. Write the script to a temp file and run it with `NODE_PATH=/opt/homebrew/lib/node_modules node /tmp/infographic-pdf.js`.

```js
// /tmp/infographic-pdf.js
const puppeteer = require('puppeteer');

(async () => {
  const htmlFile = '/absolute/path/to/{output}.html';
  const outFile  = '/absolute/path/to/{output}.pdf';

  const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const pg = await browser.newPage();
  await pg.setViewport({ width: 1400, height: 900 });
  await pg.goto('file://' + htmlFile, { waitUntil: 'networkidle0' });
  await pg.evaluateHandle('document.fonts.ready');

  const fullHeight = await pg.evaluate(() => document.body.scrollHeight);

  await pg.pdf({
    path: outFile,
    width: '1400px',
    height: fullHeight + 'px',
    printBackground: true,
    margin: { top: '0', right: '0', bottom: '0', left: '0' },
  });

  await browser.close();
  console.log('PDF written: ' + outFile);
})();
```

> **Shadow rule:** `design-system.css` includes a `@media print` block that automatically suppresses all `box-shadow` and `text-shadow` — these cause rendering artifacts in Chromium PDF output. Do **not** add a manual `addStyleTag` workaround; the CSS handles it automatically.

---

#### PNG export (if `--png` flag given)

After writing the HTML, attempt PNG export using the best available tool.

#### Per-page export (preferred when `data-infographic-page` markers are present)

When the HTML contains `data-infographic-page` attributes, generate **one PNG per page** by screenshotting each element's bounding box. Name each file `{base}-page-{NN}.png` (zero-padded two-digit index).

Use puppeteer with `NODE_PATH` pointed at the global node_modules (e.g. `/opt/homebrew/lib/node_modules`):

Write the script to a temp file and run it with `NODE_PATH=/opt/homebrew/lib/node_modules node /tmp/infographic-pages.js`. Do **not** use inline `-e` to avoid shell-expansion issues.

```js
// /tmp/infographic-pages.js
const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const htmlFile = '/absolute/path/to/{output}.html';
  const outDir   = '/absolute/path/to/output/dir';
  const baseName = '{base-name}';
  const viewW    = 1340;

  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const pg = await browser.newPage();
  await pg.setViewport({ width: viewW, height: 900 });
  await pg.goto('file://' + htmlFile, { waitUntil: 'networkidle0' });

  const pages = await pg.$$('[data-infographic-page]');
  for (let i = 0; i < pages.length; i++) {
    const pad = i < 9 ? '0' : '';
    const outFile = path.join(outDir, baseName + '-page-' + pad + (i + 1) + '.png');
    await pages[i].screenshot({ path: outFile });
    console.log('  page ' + (i + 1) + ' -> ' + outFile);
  }

  await browser.close();
  console.log('Done.');
})();
```

#### Full-page fallback (no markers, or `--png` without slidemode)

If no `data-infographic-page` markers exist, fall back to a single full-page screenshot:

```bash
# Option A: webkit2png (macOS, lightweight)
webkit2png --width=1400 --fullsize -o {output} {output}.html

# Option B: Node + puppeteer (preferred) — write to temp file, then:
# NODE_PATH=/opt/homebrew/lib/node_modules node /tmp/infographic-full.js

# Option C: Chromium headless
# /Applications/Google Chrome.app/Contents/MacOS/Google Chrome \
#   --headless --disable-gpu --screenshot={output}.png \
#   --window-size=1280,900 file://{output}.html
```

Try each option in order (A → B → C) and stop at the first that succeeds. If none are available, install the requirements needed.

> **Slide mode note:** When `--slidemode` is active and `data-infographic-page` markers are present (which they always should be), the per-page export above will produce one 1280×720 PNG per slide automatically.

### Step 7 — Print File Summary (Always Last)

This must be the **last thing printed to stdout**, regardless of which files were produced:

```
╔══════════════════════════════════════════════════════════╗
║  📄 Infographic Output                                   ║
╠══════════════════════════════════════════════════════════╣
║  HTML  →  /absolute/path/to/{output}.html                ║
║  PNG   →  /absolute/path/to/{output}.png   (if created)  ║
╠══════════════════════════════════════════════════════════╣
║  open {output}.html                                      ║
╚══════════════════════════════════════════════════════════╝
```

Always show absolute paths. If PNG was not generated, omit that line. This callout **must always appear last** in stdout so it is visible without scrolling.

---

## Quality Checklist

Before finishing, verify:
- [ ] `<link rel="stylesheet" href="…/design-system.css">` is present in `<head>` — CSS is **never** embedded inline
- [ ] All colors use tokens from `design-system.css` — no invented hex values
- [ ] Spacing uses `--space-*` scale from the design system (not arbitrary px values)
- [ ] Shadows use `--shadow-sm/md/lg/xl` from the design system
- [ ] Border radius uses `--radius-sm/md/lg/xl/2xl/full` from the design system
- [ ] **Card elements use `.card` + `.card-body` + `.card-label`/`.card-title`/`.card-text`** — no custom card classes
- [ ] **KPI metric cards use `.card-stat`** (`cs-good`/`cs-bad`/neutral) — not `card-ds` for numbers
- [ ] **Named work-item cards use `.epic-card`** with `.epic-card-icon.icon-*`, `.epic-card-key`, `.epic-card-title`, `.epic-card-body`, `.epic-card-desc`, `.epic-card-meta` — not custom item card classes
- [ ] **Status pills/tags use `.badge .badge-*`** (green=complete, orange=in-progress, sky=planned, etc.) — no custom pill classes
- [ ] Alert callouts use `.alert .alert-*` — no custom alert classes
- [ ] `data-theme="dark"` set on `<html>` for dark infographics
- [ ] Correct font family used: `ToyotaType` for all themes — never Nobel or Lexus fonts
- [ ] Only `@font-face` (base64 fonts) and page/slide-specific CSS are in the inline `<style>` block
- [ ] Renders correctly at full width in a browser
- [ ] All sections have content — no empty placeholders
- [ ] Any Swift code blocks were passed through `swiftformat` before embedding (Step 3e)
- [ ] Title and subtitle are prominent and accurate
- [ ] Correct theme applied (`--dark` → dark theme, `--light` / default → light)
- [ ] Dark theme: accent color is consistent throughout (borders, pills, glows)
- [ ] All theme colors use `:root` CSS variables — no hardcoded hex in selectors
- [ ] All five `x-infographic-*` meta tags are present and correct
- [ ] Retheme mode: content HTML is unchanged, only `<style>` and meta tags updated
- [ ] Color contrast is readable in whichever theme is used
- [ ] Footer uses the CXD brand image (`cxd.png` embedded as base64 `<img>` in `.footer-logo-img`), "Connected Experiences Division", "Mobile Engineering · …" sub-line
- [ ] Footer does **not** include a "Generated [date]" or "Source: [file]" section — no footer-meta div
- [ ] Footer does **not** use the old text-based "CXD" red div
- [ ] Footer does **not** reference LoomAI or any specific internal project name
- [ ] **Footer DOM placement**: slidemode → `<footer class="footer">` is the last flex child of **every content slide** (and closing slide) with `margin-top:auto`; parent slide must have `display:flex;flex-direction:column`
- [ ] **Footer background is transparent** — never add `background:` to `.footer`; the slide background shows through
- [ ] **Footer has slide section + counter** — `<div class="footer-right">` wraps `<div class="footer-slide-label">{Section Label}</div>` and `<div class="footer-page-num">{N} / {TOTAL}</div>` on the right side of every footer
- [ ] **No `position:absolute` footers** — footers inside `.slide` divs must use flexbox (`margin-top:auto`), never `position:absolute`
- [ ] **No compact footer bar** — do not use `slide-footer-bar`; every slide uses the identical full footer
- [ ] **No slide-num-circle** — do not use large standalone number elements at the top of content slides
- [ ] Title slides and backup-divider slides intentionally have **no footer markup at all**
- [ ] PNG generated successfully if `--png` was passed
- [ ] All top-level page elements (`<header>`, `<section>`, `.slide`, `<footer>`) have sequential `data-infographic-page` attributes starting at 1
- [ ] **Slide mode** (if `--slidemode`): every `.slide` is exactly 1280×720, `overflow: hidden`, no content bleeds outside
- [ ] **Slide mode**: `x-infographic-mode` meta tag is set to `slidemode`
- [ ] **Slide mode**: title slide + content slides + closing slide all present
- [ ] **Slide mode**: content density is appropriate — no overflow, text is legible at 11–14px
- [ ] File summary callout is the **last thing** printed to stdout

---

## Example Invocations

```
# Show help
/infographic --help

# Generate new infographic
/infographic The new ClimateFeature remote start flow with 3 steps
/infographic The new ClimateFeature remote start flow --dark
/infographic .planning/phases/12/PLAN.md
/infographic .planning/phases/12/PLAN.md --dark
/infographic --branch
/infographic --branch release/3.4.0
/infographic --branch --dark
/infographic --branch --dark --png
/infographic The Q2 roadmap overview --png

# Slide deck mode — 16×9 slides, one topic per slide
/infographic The new ClimateFeature remote start flow --slidemode
/infographic .planning/phases/12/PLAN.md --slidemode
/infographic The Q2 roadmap overview --slidemode --png
/infographic --branch --slidemode --dark
/infographic --branch --slidemode --dark --png

# Retheme an existing infographic (fast path — no content re-parse)
/infographic climate-feature-update.html --dark
/infographic climate-feature-update-dark.html --light
/infographic climate-feature-update.html --dark --png
```
