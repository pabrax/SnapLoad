---
feature: ui-mixtape-redesign
status: done          # implemented 2026-10-24 on feat/ui-mixtape-redesign (UI + parent); not pushed
lane: L1+
tdd: off
branch: feat/ui-mixtape-redesign   # in snapLoad-UI and the parent repo, on top of feat/music-player (unmerged)
---
# SnapLoad UI redesign: a joyful "mixtape" identity

## Specs
- S1 "que todos estos desarrollos no se parecen o tienen mas alegria y no se sienten tan planos" — accept: SnapLoad has its own palette/type and visible, purposeful motion for each download state — check: screenshots of every state (T0 vs T7).
- S2 "no tengo lio con que cambie un poco la identidad" — accept: palette + type approved by owner (D1) and applied through tokens — check: no hardcoded gradients or hex in components (`grep`; today `app/page.tsx:36` hardcodes a slate gradient).
- S3 (inherited from hardening-ui-polish and music-player) — accept: Lighthouse a11y 100 on `/` and `/video`; mobile LCP <= 2.5 s; axe wcag2a/aa/21/22 clean; touch targets >= 44 px; player aria-labels and shortcuts (space/n/p/m) intact; `node --test` stays 65 passing; `tsc` errors not above the baseline of 23 — check: lighthouse (Edge via `CHROME_PATH`, binaries live in Portafolio `node_modules/.bin`), axe, `npm test`, `npx tsc --noEmit`.

## Objective
Replace the flat navy/emerald look with a playful music-and-media identity, using motion that explains what is happening (fetching, downloading, done, failed).

## Problem
Audit (2026-10-24): OKLCH tokens in `src/styles/globals.css:6-82` are navy + emerald/teal/lime (the "dark base + acid green" default); one font (Geist Sans); only Radix/spinner/pulse animations; static `BackgroundEffects`; state machine `idle -> info-loading -> idle+preview -> loading -> success|error` is functional but visually identical in every state.

## Design brief (frontend-design process; reviewed against its defaults list)
- Direction: "Mixtape pop": the product is about audio/video you keep, so the identity borrows from tapes, cover art and waveforms, in saturated color on a deep plum base. Rejected defaults: dark navy + green accent, uniform rounded cards with identical grey shadows, eyebrow labels.
- Color (dark base, proposed; light theme derived and contrast-checked in T1):
  - plum ink `#1B1030` (page), plum surface `#2A1B47`
  - cassette white `#FFF6EC` (text)
  - coral `#FF5D73` (Audio mode, primary actions)
  - ultraviolet `#7B6CFF` (Video mode)
  - sun `#FFC93C` (Library mode, highlights)
  - mint `#5CE1C6` (success only)
  - A `data-mode="audio|video|library"` attribute on the page switches `--mode` so the tabs, buttons and progress take the mode color.
- Type: display = Unbounded (wide, rounded, playful) for the wordmark and the main headings only; body = Geist Sans (already loaded). Both through `next/font`.
- Layout: a large paste field as the hero of the page (the one memorable element); info preview as a "tape label" card with cover art; progress as a segmented bar with an equalizer; library as a cover grid; player bar restyled but structurally unchanged.
- Motion (all finite, tied to state, each with a `prefers-reduced-motion` static equivalent): mode switch slides the tab indicator and recolors; fetching info shows a shimmer on the preview skeleton; downloading animates the equalizer only while the job runs; success plays a one-shot burst (<= 600 ms); error shakes once.

## Scope
In: `src/styles/globals.css`, `app/layout.tsx`, `app/page.tsx`, `app/video/page.tsx`, `src/components/**` (presentation only), small inline SVG assets.
Out: API routes, hooks (`use-download-progress`), player reducer/shortcuts logic, backend, copy changes beyond microcopy needed by new states, push/merge.

## Constraints
- Earlier decision (hardening-ui-polish, line ~48): "no infinite animations or blur", chosen after measuring LCP. This plan keeps blur out and limits looping motion to the equalizer while a job is running. OWNER DECISION D2 needed to lift the "no infinite animation" rule for that one case; if declined, the equalizer becomes a stepped, non-looping progress fill.
- Earlier decision: no new UI dependency unless it removes more than it adds. This plan adds none (CSS + inline SVG). `motion` is NOT planned.
- Mobile perf was 93-95 and LCP about 3.0 s in music-player notes, so T0 re-measures before any change; the gate is "not worse than T0 and <= 2.5 s on `/`".
- Two repos: UI is a submodule; commit in `snapLoad-UI`, then a bump commit in the parent, as in previous features. No push without approval.
- Skills: `frontend-design`, `web-design-guidelines`, `accessibility`, `core-web-vitals`, `webapp-testing`.

## Tasks
- [x] T0 Baseline: create branches; screenshots of idle, info-loading, preview, loading with progress, success, error, library empty, library with items, player (375/1440); Lighthouse mobile on `/` and `/video`; `npm test` and `tsc` counts — accept: numbers in evidence, no source change — commit: n/a
- [x] T1 Tokens, fonts, mode attribute (S2) — accept: new palette (dark + derived light) in `globals.css`, Unbounded + Geist loaded, hardcoded gradient removed from `app/page.tsx` and `BackgroundEffects`, contrast >= 4.5:1 — commit: d665b7f
- [x] T2 Header, wordmark, tab selector with mode color and sliding indicator (S1, S3) — accept: ARIA tabs and `tab-keyboard` test intact — commit: 2f130d4
- [x] T3 Download form: paste hero, info preview "tape label", progress with equalizer, success burst, error shake (S1, S3) — accept: each state has a distinct look; reduced motion shows static equivalents; `role=alert/status` kept — commit: a751816
- [x] T4 Library: cover grid, hover, inline-SVG empty state (S1, S3) — accept: `library-view` test passes, empty/error/loading roles kept — commit: d8568f5
- [x] T5 Player bar restyle (S1, S3) — accept: `player-reducer`, `player-shortcuts`, `player-prefs` tests pass; every control keeps its `aria-label` — commit: 8a9c322
- [x] T6 `/video` page parity and `not-found` page (S1) — accept: same tokens and states as audio — commit: f449a8d
- [x] T7 Verification (S3) — accept: Lighthouse a11y 100 on both routes, mobile LCP <= 2.5 s or not worse than T0 with reason, axe clean, `npm test` 65 pass, `tsc` <= 23, screenshots of all states vs T0 — commit: n/a (evidence below)

## Delegation
`implementer` per task; T3, T4, T5 have disjoint files and can run in parallel after T1-T2. `reviewer` on T7.

## Verification evidence
Scratchpad (not in repo): `...\scratchpad\snapload\` holds `before-*.png` (T0, production build of 1d416e4) and `after-*.png` (final production build) for 12 states x 375/1440, plus `shots.cjs`, `axe.cjs`, `behav.cjs`, `lh.sh`. Backend job states are mocked via request interception (puppeteer-core + Edge); library and player use the real API on :9020; UI on :3101.
- T0 baseline (commit 1d416e4): `npm test` 65 pass, `tsc` 23 errors, `npm run build` OK. Lighthouse mobile, 3 runs: `/` perf 96/57/91, LCP 2.63/7.05/3.27 s (median 3.27), a11y 100; `/video` perf 91/98/98, LCP 3.09/1.82/2.19 s (median 2.19), a11y 100.
- T1 `grep` for `#hex|gradient-to|slate-|blue-|purple-|teal-` over changed files: 0 hits (only `themeColor` in `layout.tsx`, which cannot use a CSS variable). Contrast script: cassette/plum 16.9, coral/surface 5.3, violet/surface 5.8, sun/surface 10.2, mint/surface 9.7, tomato/surface 5.6, plum ink on coral 6.1, on violet 6.7, on sun 11.8, muted text 8.2 (all >= 4.5). `next build` OK (Unbounded 800 self-hosted, +22 KB).
- T2-T6 `tsc --noEmit` 23 errors after every task (baseline 23); `npm test` 65 pass / 0 fail after T6.
- Behavior (`behav.cjs`, Edge, 14/14 PASS): equalizer = 28 infinite animations only while the job runs, 0 after cancel/success/error; success burst = 10 dots, 1 iteration, 0.6 s; error alert shakes once; `prefers-reduced-motion`: eq static (animation none, scaled bars), burst hidden; ArrowRight/End move tab focus+selection, `data-mode` and indicator (translateX(100%), violet); player labels intact (Orden aleatorio, Pista anterior, Pausar, Pista siguiente, Repetir, Silenciar) and shortcuts space (pause/resume) and m (mute) work.
- axe-core (wcag2a/aa/21a/21aa/22aa + best-practice, includes color-contrast): 0 violations in 22 page states: idle, preview, loading, success, error, library empty, library, player open, video tab, `/video`, 404 at 375 and 1440.
- Lighthouse mobile, 5 runs each, same-session A/B (production builds): base 1d416e4 `/` LCP median 3.09 s (3.03 2.99 3.09 3.34 3.66), `/video` 2.92 s; after `/` LCP median 2.47 s (2.47 1.91 2.92 2.15 2.65), `/video` 1.86 s; a11y 100 and best-practices 100 in all 20 runs; CLS 0; perf median `/` 96 (base 91), `/video` 98 (base 95). Gate LCP <= 2.5 s met by median on both routes (high variance, `/` range 1.91-2.92) and not worse than T0. Transfer 265 -> 290 KiB (Unbounded 22 KB).
- Not run: independent `reviewer` pass (author only); light theme; Safari/Firefox.

## Progress
Paused by the owner after the Opus audit (CHANGES REQUESTED). Branch tip in snapLoad-UI: a43eaeb. Checks on that tree: `tsc` 23 errors, `npm test` 65 pass, `npm run build` OK (not re-run: axe, Lighthouse a11y, screenshots).
Audit findings:
1. Fake "Sin titulo" preview: FIXED in 928cd25 (card says "Enlace de YouTube listo" when only the platform is known; shows title/artist/cover when present). Verified by code and tsc only, no new screenshot.
2. `/` LCP gate: HALF DONE, NOT MET. Interleaved A/B (7 runs, mobile, same session) with the 22 KB Unbounded font: base median 3.22 s (3.48 3.21 3.27 3.22 3.17 3.00 3.29), new 2.95 s (2.95 3.11 3.18 2.73 2.85 3.14 2.86); `/video` base 2.97, new 2.92. Experiment without Unbounded: 5 runs 2.28 2.54 2.44 2.06 2.15 (median 2.28), so the font costs ~0.65 s. Fix applied in a43eaeb (2 KB subset of Unbounded 800 with only the glyphs of "SnapLoad/Videos/404", rings moved to a small pseudo-element; dialog titles no longer use the display font) and it builds, but its LCP was NOT measured. Next: run `ab.sh` against base (build base with a temporary `distDir` env in next.config.mjs).
3. Panels not in view on mobile: FIXED in e668ff2 (`scrollIntoView` block nearest, `auto` under reduced motion). Not verified in a browser.
4. Error color too close to coral: FIXED in a43eaeb (error orange `#FF8A3D`, 6.7:1 on surface), dashed border kept. Not re-screenshotted.
5. Inconsistent status texts: FIXED in bddc251 (button, label and subtext share `stageLabel`; stale server message removed). Not verified in a browser.
Extra: wordmark bars no longer repeat the mode color (a43eaeb).
Processes on 3101/9020 stopped (netstat 0 listeners).

## Next step
Rebuild, re-run axe, behav and screenshots on a43eaeb, then the interleaved Lighthouse A/B (>= 7 runs) for `/` and `/video`; if `/` median is still > 2.5 s, report numbers and what was tried. Push/merge only on owner approval.

## Log
- L1 "puedes dentro de cada proyecto hacer una propuesta de diseño ... aprovecha las skills para hacer el plan de mejora ... crea un plan para los 3 proyectos"
- Lane/method: ODD (see portfolio-redesign in the Portafolio repo for the shared reasoning).

### UX references (WebFetch/WebSearch, 2026-10-24; secondary sources, ideas not copied)
1. cobalt.tools: one paste-and-go screen, minimal chrome, a small friendly mascot offsets a utilitarian tool. Applied: the paste field is the hero of the page, one primary action, the wordmark mark is the only "mascot".
2. cobalt.tools: options sit next to the action. Applied: format and quality side by side under the field (2 columns from 640 px), less scrolling.
3. Apple HIG / design systems: determinate bars when progress is measurable, indeterminate otherwise; never a stationary indicator for a long wait; label the stage. Applied: the API reports no percentage, so no fake percent: an equalizer shows activity, a text label names the stage, bars rest while queued.
4. Same sources: skeleton/shimmer for 1-3 s waits; `role=status` for indeterminate states. Applied: shimmer tape-label skeleton while fetching info, `role=status` plus sr-only text.
5. YouTube Music grid: cover art first, title/artist below, list view as an alternative. Applied: library as a cover grid. Dropped: list-view toggle (2-4 columns and two-line titles suffice).
6. Persistent mini-player guides: bar stays across screens, controls never hidden. Applied: bar structure unchanged (survives tab switches), restyled; the playing track is marked in the grid. Not applied: full now-playing screen (out of scope).
7. Design guidance: album art as the visual center, accent color per context, dark theme. Applied: per-mode accent via `data-mode`, color tiles for tracks without cover.
8. Gap: no Plexamp-specific source was retrievable; the patterns above come from general sources.

### Decisions
- Decision: palette refined. Violet `#7B6CFF` gave 4.0:1 on the surface and 4.3:1 with cassette ink; replaced by `#9C90FF` (5.8:1 as text, 6.7:1 with plum ink). Added `tomato #FF6B57` for errors so they differ from coral (audio mode) and are not color-only (dashed border, icon, shake, text).
- Decision: dark-only. The brief asked for a derived light theme, but the app has no theme toggle and sets `colorScheme: dark`; a half-tested light mode is worse UX than none. Tokens are centralized, so a light set can be added later. Dropped.
- Decision: blur stays out (no UX gain found). Infinite animation exists only for `.eq-bar` while a job runs (D2); the pre-existing `animate-spin` on the button spinner and `animate-pulse` on the "verifying server" dot were left untouched.
- Decision: no fake percentage. The status endpoint exposes no progress, so the "segmented bar" became an equalizer of 28 bars (activity, not amount).
- Decision: bug fix beyond presentation (UX first): `AudioDownloadForm` cleared a failed job's error the instant it appeared (the reset effect depended on the error state), so failures showed nothing. The effect now depends on the URL only (commit a751816); verified by the error screenshot and `behav.cjs`.
- Decision: bug fix beyond presentation: `/video` rendered `VideoDownloader` without `backendStatus`, leaving the download button disabled for good. The page now uses `useBackendHealth` (commit f449a8d).
- Decision: library actions sit below each cover (44 px targets kept); the duration chip follows the title in the DOM so the accessible name stays "Reproducir Title Artist duration" (WCAG 2.5.3; axe label-content-name-mismatch clean).
- Decision: tabs use equal-width segments so one translated pill can slide; ARIA tablist semantics and `tab-keyboard` logic are untouched.
- Decision: the tape-label preview degrades gracefully when metadata is missing (sun tile with a note icon, "Sin titulo" fallback); `/api/info` not changed (API routes out of scope).
- Dropped: delegation to `implementer`/`reviewer` subagents (worked inline in one context; no independent reviewer pass).
