#!/bin/bash
# SessionStart hook — makes the /watch video skill (.claude/skills/watch)
# runnable in Claude Code on the web by installing its runtime dependencies
# and pre-answering its first-run setup so sessions stay non-interactive.
set -euo pipefail

# Local machines manage their own dependencies; only remote containers need this.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

# ffmpeg ships ffprobe in the same package. The container's apt index is stale
# at boot, so update first; a blocked third-party PPA may warn — ignore it.
if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  apt-get update -qq >/dev/null 2>&1 || true
  apt-get install -y -qq --no-install-recommends ffmpeg >/dev/null
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  python3 -m pip install -q yt-dlp
fi

# Pre-configure /watch (keyless is a supported state: native captions cover most
# public videos, and SETUP_COMPLETE=true stops the skill from re-running its
# interactive first-run interview in every fresh container). Whisper fallback
# for caption-less videos activates if GROQ_API_KEY or OPENAI_API_KEY is set in
# the Claude environment settings — the skill reads process env before this file.
CONFIG_FILE="$HOME/.config/watch/.env"
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cat > "$CONFIG_FILE" << 'CONF'
# /watch skill config — see .claude/skills/watch/SKILL.md
# Whisper keys may also be provided via environment variables (checked first).
# GROQ_API_KEY=
# OPENAI_API_KEY=
WATCH_DETAIL=balanced
SETUP_COMPLETE=true
CONF
  chmod 600 "$CONFIG_FILE"
fi

echo "/watch ready: $(ffmpeg -version 2>/dev/null | head -1 | awk '{print $1, $2, $3}'), yt-dlp $(yt-dlp --version)"
