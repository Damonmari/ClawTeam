# /watch — Video Analysis Skill

The `/watch` skill gives Claude the ability to watch a video and answer questions about it — useful for reviewing site walkthrough recordings, drone footage, training videos, vendor demos, or a screen recording of a software bug.

Installed at `.claude/skills/watch/` from [bradautomates/claude-video](https://github.com/bradautomates/claude-video) (v0.2.0, upstream commit `83da59f`). The folder is self-contained: `SKILL.md` (the skill contract Claude follows) plus `scripts/` (pure-stdlib Python, no packages required).

## Usage

```
/watch <video-url-or-path> [question]
```

Examples:

```
/watch https://youtu.be/dQw4w9WgXcQ what happens at the 30 second mark?
/watch site-walkthrough.mp4 summarize the punch-list items called out
/watch bug-repro.mov when does the UI break?
/watch recording.mp4 --start 2:15 --end 2:45     # focus on a section (denser frames)
```

## How it works

1. `yt-dlp` checks for native captions first (free; URL sources only) and downloads only what the run needs.
2. `ffmpeg` extracts frames as JPEGs — scene-aware by default, with near-duplicate frames dropped so the frame budget goes to distinct content.
3. The transcript comes from native captions when available, else the Whisper API (Groq or OpenAI) if a key is configured.
4. Claude `Read`s every frame as an image, aligns them with the timestamped transcript, and answers grounded in what's actually on screen.

Key knobs (see `.claude/skills/watch/SKILL.md` for the full list):

- `--detail transcript|efficient|balanced|token-burner` — fidelity/token-cost dial (default `balanced`, scene-aware, 100-frame cap)
- `--start T` / `--end T` — focus on a section; far better than a sparse scan for videos over ~10 minutes
- `--resolution 1024` — only when Claude needs to read on-screen text (slides, terminals, drawings)

## Dependencies (cloud sessions)

Claude Code on the web runs in an ephemeral container, so the two binaries need reinstalling in a fresh session before first use:

```bash
apt-get update && apt-get install -y ffmpeg && pip install yt-dlp
```

The skill's preflight (`python3 .claude/skills/watch/scripts/setup.py --check`) detects missing binaries and prints these commands itself, so Claude can self-remediate on first `/watch` in a session.

Two environment notes:

- **Network policy.** Downloading from YouTube and similar sites depends on the session environment's network policy — the default proxy configuration blocks video hosts (verified: `youtube.com` returns 403 through the proxy). Local video files committed to the repo, uploaded to the session, or produced in-session always work.
- **Whisper key (optional).** Videos without captions get a transcript only if `GROQ_API_KEY` (preferred) or `OPENAI_API_KEY` is set in `~/.config/watch/.env` or the environment. Without a key the skill still runs frames-only for caption-less videos.

## Verified

On install (2026-08-12, Linux container, Python 3.11 / ffmpeg 6.1.1 / yt-dlp 2026.07.04):

- Upstream pytest suite: 71/71 passed.
- End-to-end run on an ffmpeg-synthesized 3-scene clip: frame extraction, dedup, and report generation all correct; frames render via `Read`.

## Updating

Upstream ships updates via the plugin marketplace; this repo pins a copy instead. To update, re-copy the skill folder from the upstream repo:

```bash
git clone https://github.com/bradautomates/claude-video /tmp/claude-video
rm -rf .claude/skills/watch && cp -r /tmp/claude-video/skills/watch .claude/skills/watch
```

Then update the version/commit noted at the top of this file.
