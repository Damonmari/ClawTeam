# AIOC Project — ClawTeam

**AI-Optimized Construction (AIOC)** is a project management toolkit built for General Contractors specializing in data centers and large multifamily buildings.

## What's in This Repo

- **docs/** — Project plans, specifications, and reports
- **tools/** — Scripts and utilities to streamline construction project workflows
- **templates/** — Reusable templates for day-to-day GC operations
- **resources/** — Reference materials, code standards, and best practices

## Project Types

1. **Data Centers** — High-power, mission-critical facilities with strict MEP coordination
2. **Large Multifamily Buildings** — Residential projects with repeatable unit types and complex phasing

## Getting Started

1. Browse the templates/ folder for ready-to-use forms and checklists
2. Check docs/ for project-specific documentation
3. See tools/ for any automation scripts

## Claude Skills

- **.claude/skills/watch/** — `/watch` lets Claude watch a video (YouTube/Loom/TikTok URL or local file) and answer questions about it. Usage: `/watch <url-or-path> [question]`. Vendored from [bradautomates/claude-video](https://github.com/bradautomates/claude-video) (MIT). Requires `ffmpeg` and `yt-dlp` on PATH — in a fresh remote session: `apt-get update && apt-get install -y ffmpeg && pip install yt-dlp`. A Whisper API key (`GROQ_API_KEY` in `~/.config/watch/.env`) is only needed for videos without captions.

## Contributing

Team members can add documents, templates, and tools by creating a branch and submitting a pull request.

---

*Maintained by the ClawTeam — Adventure AI Agency*
