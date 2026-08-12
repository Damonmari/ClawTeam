# AIOC Project — ClawTeam

**AI-Optimized Construction (AIOC)** is a project management toolkit built for General Contractors specializing in data centers and large multifamily buildings.

## What's in This Repo

- **docs/** — Project plans, specifications, and reports
- **tools/** — Scripts and utilities to streamline construction project workflows
- **templates/** — Reusable templates for day-to-day GC operations
- **resources/** — Reference materials, code standards, and best practices
- **.claude/skills/** — Claude Code skills available in every session of this repo (see below)

## Claude Skills

### /watch — let Claude watch a video

Vendored from [bradautomates/claude-video](https://github.com/bradautomates/claude-video) (v0.2.0, MIT license) at `.claude/skills/watch/`. It loads automatically as a project skill in any Claude Code session on this repo — local or cloud.

Paste a video URL or local file path and ask a question; Claude downloads it (yt-dlp), extracts frames (ffmpeg), pulls a timestamped transcript (native captions first, Whisper API fallback), then reads the frames as images and answers grounded in what's actually on screen. Useful for site walkthrough recordings, drone footage review, training videos, and vendor/product demos.

```
/watch https://youtu.be/<id> what happens at the 30 second mark?
/watch site-walkthrough.mp4 summarize the issues shown
/watch <url> --start 2:15 --end 2:45        # focus on a section (denser frames)
/watch <url> --detail transcript             # transcript only, cheapest
```

Notes:

- **Dependencies:** needs `ffmpeg` and `yt-dlp`. In cloud (Claude Code on the web) sessions these are installed automatically at session start by `.claude/hooks/session-start.sh`, which also pre-configures the skill so it never blocks on first-run questions. On a local machine the skill checks on first use (`scripts/setup.py`) and walks through installation.
- **Whisper key (optional):** most public videos have captions (free). Only videos without captions need a `GROQ_API_KEY` (preferred) or `OPENAI_API_KEY` — set it as an environment variable (cloud: environment settings; the skill reads process env first) or in `~/.config/watch/.env`. Without one, caption-less videos come back frames-only.
- **URLs in cloud sessions need network access to the video host.** With a restricted environment network policy, `yt-dlp` gets a proxy 403 on sites like youtube.com — local video files still work fully. To watch URLs in cloud sessions, allow the video host in the environment's network policy (or run `/watch` on a local machine).
- **Updating:** re-copy `skills/watch/` from the upstream repo over `.claude/skills/watch/`. On a local machine you can instead install the auto-updating plugin: `/plugin marketplace add bradautomates/claude-video` then `/plugin install watch@claude-video`.

### /humanizer — remove AI writing patterns from prose

Vendored from [blader/humanizer](https://github.com/blader/humanizer) (v2.9.1, MIT license) at `.claude/skills/humanizer/`. It loads automatically as a project skill in any Claude Code session on this repo. Pure Markdown, no dependencies.

Rewrites text to remove the telltale signs of AI-generated writing (33 documented patterns, based on Wikipedia's "Signs of AI writing" guide) while preserving every fact. It never invents names, dates, or details that aren't in the source. Useful as a final pass on client-facing prose: formal correspondence, RFI narratives, claim submissions, reports.

```
Humanize this text: [paste draft]
Humanize the prose in docs/reports/monthly-report.md   # rewrites the file in place
```

To match a specific person's writing style, include 2-3 paragraphs of their own writing as a sample before the text to rewrite.

Notes:

- **Updating:** re-copy `SKILL.md` from the upstream repo over `.claude/skills/humanizer/SKILL.md` and update the version noted here. See `docs/reports/blader-humanizer-analysis.md` for a full analysis of the upstream repo.

## Project Types

1. **Data Centers** — High-power, mission-critical facilities with strict MEP coordination
2. **Large Multifamily Buildings** — Residential projects with repeatable unit types and complex phasing

## Getting Started

1. Browse the templates/ folder for ready-to-use forms and checklists
2. Check docs/ for project-specific documentation
3. See tools/ for any automation scripts

## Contributing

Team members can add documents, templates, and tools by creating a branch and submitting a pull request.

---

*Maintained by the ClawTeam — Adventure AI Agency*
