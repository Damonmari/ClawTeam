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

- **Dependencies:** needs `ffmpeg` and `yt-dlp`. The skill checks on first use (`scripts/setup.py`) and walks through installation — in cloud sessions the container is fresh, so expect a one-time `apt-get install ffmpeg` + `pip install yt-dlp` per session.
- **Whisper key (optional):** most public videos have captions (free). Only videos without captions need a `GROQ_API_KEY` (preferred) or `OPENAI_API_KEY` in `~/.config/watch/.env`; without one, caption-less videos come back frames-only.
- **Updating:** re-copy `skills/watch/` from the upstream repo over `.claude/skills/watch/`. On a local machine you can instead install the auto-updating plugin: `/plugin marketplace add bradautomates/claude-video` then `/plugin install watch@claude-video`.

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
