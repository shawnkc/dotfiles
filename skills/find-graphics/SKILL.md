---
name: find-graphics
description: Find and recommend free, high-quality SVG graphics (icons, emoji-style, illustrations) from curated open-source sources based on context. Use instead of stock OS emoji when producing presentations, infographics, markdown, or any visual content.
argument-hint: "[describe what you need — e.g., 'icons for a CI/CD pipeline diagram' or 'illustration for an onboarding slide']"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, WebSearch, WebFetch
---

<objective>
Find and recommend the RIGHT free graphics for the current context. Never default to
stock OS Unicode emoji (🚀, 📋, ✅) when producing visual content. Instead, surface
vetted, high-quality SVG assets with working CDN URLs and proper license notes.

This skill covers three asset tiers:
1. **Icons** — UI/concept icons (Tabler, Phosphor, Simple Icons, Material Symbols)
2. **Emoji-style** — Expressive graphic emoji (Fluent Emoji, Noto Emoji, OpenMoji, Twemoji)
3. **Illustrations** — Scene/people illustrations (unDraw, Humaaans, Open Doodles, DrawKit)
</objective>

<source-library>
## Tier 1 — Icons (MIT / Apache 2.0 / CC0 — No Attribution Required)

### Tabler Icons (MIT, 6,000+ icons)
- CDN: `https://cdn.jsdelivr.net/npm/@tabler/icons@latest/icons/{name}.svg`
- Browse: https://tabler.io/icons
- Iconify: `https://api.iconify.design/tabler:{name}.svg`
- Style: Clean outline stroke, covers every UI/business/tech concept

### Phosphor Icons (MIT, 9,000+ icons × 6 weights)
- CDN: `https://cdn.jsdelivr.net/npm/@phosphor-icons/core@latest/assets/regular/{name}.svg`
- Weights: thin / light / regular / bold / fill / duotone
- Browse: https://phosphoricons.com
- Iconify: `https://api.iconify.design/ph:{name}.svg`
- Style: Versatile; duotone is great for infographics

### Material Symbols (Apache 2.0, 15,000+ icons)
- CDN: https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined
- SVG downloads: https://fonts.google.com/icons
- Iconify: `https://api.iconify.design/material-symbols:{name}.svg`
- Style: Google/Material Design; unmatched coverage

### Simple Icons (CC0, 3,400+ brand logos)
- CDN with color: `https://cdn.simpleicons.org/{slug}/{hex-color}`
- Dark mode: `https://cdn.simpleicons.org/{slug}/{light-hex}/{dark-hex}`
- Browse: https://simpleicons.org
- Style: Flat brand/tech logos (GitHub, Docker, React, AWS, etc.)

### Heroicons (MIT, ~300 curated)
- Iconify: `https://api.iconify.design/heroicons:{name}.svg`
- Browse: https://heroicons.com
- Style: Minimal, Tailwind-native

### Iconify Universal API (access ALL sets)
- Any icon: `https://api.iconify.design/{set}:{name}.svg`
- Sizing: append `?width=32&height=32`
- Browse all 275k+ icons: https://icones.js.org

---

## Tier 2 — Emoji-Style Graphics (No Attribution Required)

### Fluent Emoji — Microsoft (MIT)
- GitHub: https://github.com/microsoft/fluentui-emoji/tree/main/assets
- Styles per emoji: `3D`, `Color` (flat), `High Contrast`
- Browse: https://fluent-emoji.lobehub.com
- npm: `@lobehub/fluent-emoji`
- Best for: Modern, polished, Windows 11/M365 aesthetic

### Noto Emoji — Google (Apache 2.0)
- GitHub: https://github.com/googlefonts/noto-emoji
- PNG CDN: `https://raw.githubusercontent.com/googlefonts/noto-emoji/main/png/128/emoji_u{codepoint}.png`
- Best for: Max Unicode coverage, clean Google style

### OpenMoji (CC BY-SA 4.0 — attribution required)
- Browse + download: https://openmoji.org/library
- CDN: `https://cdn.jsdelivr.net/npm/@svgmoji/openmoji/`
- Unique: Has **outline/monochrome variant** — ideal for one-color print/slides

### Twemoji — Twitter/jdecked (CC BY 4.0 — attribution required)
- CDN SVG: `https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/{codepoint}.svg`
- CDN PNG: `https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/72x72/{codepoint}.png`
- Best for: Familiar Twitter emoji style with great CDN support

---

## Tier 3 — Illustrations & Clip-Art (No Attribution Required)

### unDraw (Custom open license ≈ MIT)
- Browse + download: https://undraw.co/illustrations
- Color customization: built-in picker before download
- Style: Flat, modern, consistent — ideal for slides and READMEs
- Restriction: Cannot resell as asset pack, no AI training

### Humaaans (CC0 — public domain)
- Download: https://www.humaaans.com
- Style: Mix-and-match flat people characters — diverse, customizable
- Also in Blush app for component-level customization

### Open Doodles (CC0 — public domain)
- Download: https://www.opendoodles.com
- Style: Sketchy, hand-drawn people in casual scenes

### DrawKit (MIT)
- Browse + download: https://www.drawkit.com
- Style: Hand-drawn vectors, business/tech/nature scenes

### Blush Design (CC varies per pack — most free for commercial use)
- Browse + API: https://blush.design
- API for programmatic illustration: https://blush.design/api

---

## Markdown Embed Patterns

```html
<!-- Icon via Iconify (universal) -->
<img src="https://api.iconify.design/tabler:rocket.svg?width=32&height=32" alt="rocket" />

<!-- Simple Icons brand logo with color -->
<img src="https://cdn.simpleicons.org/github/181717" width="28" alt="GitHub" />

<!-- Twemoji emoji (requires attribution) -->
<img src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f680.svg" width="32" alt="rocket" />

<!-- Dark/light mode icon in GitHub README -->
<img src="https://cdn.simpleicons.org/typescript/3178C6/white" width="28" alt="TypeScript" />
```
</source-library>

<process>
When invoked (or when the main agent needs graphics):

1. **Understand the context** — What is being produced? (slide deck, README, infographic, diagram, doc)
   What concepts need visual representation?

2. **Select the right tier**:
   - UI/concept/tech → Tier 1 Icons (start with Tabler or Phosphor)
   - Expressive/fun/emoji replacement → Tier 2 Emoji-style (start with Fluent Emoji)
   - Scene/people/narrative → Tier 3 Illustrations (start with unDraw)
   - Brand/tech logos → Simple Icons (always CC0)

3. **Provide ready-to-use output**:
   - Specific icon/illustration names (search terms for the browse URLs)
   - Working CDN `<img>` embed snippets where applicable
   - License tier note (MIT/CC0/requires attribution)

4. **Prefer SVG over PNG** — scales perfectly, smaller file size

5. **Never suggest stock OS emoji** (🚀📋✅) as the final graphic — they render
   inconsistently across platforms and look unprofessional in presentations/infographics.
   Unicode emoji are fine in conversational text responses but NOT in delivered visual assets.
</process>

<output-format>
Return recommendations grouped by tier with:
- Asset name and source
- License (one of: MIT · Apache 2.0 · CC0 · CC BY 4.0 · CC BY-SA 4.0)
- Ready-to-use CDN URL or download link
- Embed snippet for markdown/HTML where applicable
</output-format>
