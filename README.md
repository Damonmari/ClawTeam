# AIOC Project — ClawTeam

**AI-Optimized Construction (AIOC)** is a project management toolkit built for General Contractors specializing in data centers and large multifamily buildings.

## What's in This Repo

- **docs/** — Project plans, specifications, and reports
- **tools/** — Scripts and utilities to streamline construction project workflows
- **templates/** — Reusable templates for day-to-day GC operations
- **resources/** — Reference materials, code standards, and best practices
- **.claude/skills/** — Project-level skills for Claude Code (available in every session on this repo)

## Claude Skills

### /watch — let Claude watch a video

Vendored from [bradautomates/claude-video](https://github.com/bradautomates/claude-video) (v0.2.0). Paste a video URL or a local file path and ask a question — Claude downloads it with `yt-dlp`, extracts scene-aware frames with `ffmpeg`, pulls a timestamped transcript (native captions first, Whisper API fallback), then reads the frames as images and answers from what's actually on screen.

```
/watch https://youtu.be/<video> summarize this
/watch site-walk-recording.mp4 what's blocking the corridor on level 3?
/watch bug-repro.mov what goes wrong in the UI?
/watch https://youtu.be/<video> --start 2:15 --end 2:45   # focus on a section
```

Useful for site-walk recordings, drone footage review, screen recordings of software issues, training videos, and subcontractor submittal videos.

**Requirements:** `ffmpeg` and `yt-dlp` on PATH (the skill's setup walks you through installing them on first run). Optional: a `GROQ_API_KEY` or `OPENAI_API_KEY` in `~/.config/watch/.env` for transcribing videos that have no captions (local files, most site recordings). Without a key, caption-less videos come back frames-only.

**Note for Claude remote/web sessions:** the sandbox network proxy blocks YouTube and most video hosts, so URL-based watching generally only works in local Claude Code sessions. Local video files committed to or copied into the workspace work everywhere.

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
