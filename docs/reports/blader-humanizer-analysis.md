# Analysis: blader/humanizer

Repo: https://github.com/blader/humanizer
Version analyzed: 2.9.1 (commit `523374d`, 2026-07-21)
License: MIT (copyright 2025 Siqi Chen)
Cloned and reviewed: 2026-08-12

## What it is

Humanizer is a portable agent skill that rewrites text to remove the telltale signs of AI-generated writing. The entire product is one Markdown file, `SKILL.md`: YAML frontmatter followed by an editor prompt. There is no code at runtime, no build step, and no dependencies. Any harness that can load Markdown skill instructions can run it, including Claude Code, Codex, and OpenCode.

The pattern list is grounded in Wikipedia's "[Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)" guide, maintained by WikiProject AI Cleanup from observations of thousands of instances of AI text on Wikipedia. That gives the skill an unusual advantage over most "make it sound human" prompts: its rules come from a large, curated corpus of real detections rather than one author's hunches.

## Repository anatomy

The repo is small (9 files, ~316 KB) and every file has a clear job:

| File | Role |
|------|------|
| `SKILL.md` | The skill itself. Source of truth. 412 lines: frontmatter, 33 numbered patterns with before/after examples, detection guidance, process loop. |
| `README.md` | Human-facing docs: installation (skills CLI, Claude Code plugin, manual copy), usage, voice calibration, a summary table of all 33 patterns, full before/after example, version history. |
| `AGENTS.md` | Maintenance contract for AI coding agents editing the repo: keep SKILL.md, README, and plugin.json in sync; keep wording harness-neutral; run the validators before publishing. |
| `.claude-plugin/plugin.json` | Claude Code plugin manifest (v2.9.1). |
| `.claude-plugin/marketplace.json` | Single-repo marketplace entry so `/plugin marketplace add blader/humanizer` works. |
| `agents/openai.yaml` | Interface metadata for OpenAI-style harnesses (display name, default prompt). |
| `scripts/validate-package.py` | Dependency-free validator: frontmatter validity, no nonportable keys, version sync across the three surfaces, patterns numbered exactly 1-33 in both SKILL.md and the README table, and a 500-line budget on SKILL.md. |
| `.github/workflows/validate.yml` | CI on every push and PR: runs the validator, checks Agent Skills discovery (`npx skills add . --list`), and runs `claude plugin validate .`. |
| `LICENSE` | MIT. |

I ran `scripts/validate-package.py` against the clone; it reports `Humanizer package v2.9.1 is valid`.

## How the skill works

Given text to rewrite, the skill scans for 33 numbered patterns, each documented with words to watch, the problem it signals, and a before/after example. The groups:

- Content patterns (1-6): significance inflation, notability name-dropping, superficial "-ing" analyses, promotional language, vague attributions, formulaic "challenges" sections.
- Language and grammar (7-13): overused AI vocabulary ("delve", "testament", "landscape"), copula avoidance ("serves as" for "is"), negative parallelisms, rule-of-three overuse, synonym cycling, false ranges, passive voice and subjectless fragments.
- Style (14-19, 26-33): em and en dashes (a hard cut, with a final scan before delivery), boldface overuse, inline-header lists, title-case headings, emojis, curly quotes, hyphenated word pairs, persuasive authority tropes, signposting, fragmented headers, diff-anchored writing, manufactured punchlines, aphorism formulas, fake-candid openers.
- Communication artifacts (20-22): chatbot closers ("I hope this helps!"), knowledge-cutoff disclaimers and speculative gap-filling, sycophancy.
- Filler and hedging (23-25): filler phrases, stacked hedges, generic upbeat conclusions.

Beyond the pattern list, four design decisions stand out:

1. A no-fabrication rule (added in v2.9.0). The rewrite may not contain any fact, name, number, date, quote, or citation that is not in the source. Specificity has to come from the source or the author. This matters for professional use: a rewriter that invents detail to sound human is a liability in anything contractual.
2. Information over shape. Every claim in the original must survive, but paragraph structure can change. When keeping the information and mirroring the structure conflict, the information wins.
3. Voice calibration. If the user supplies a sample of their own writing, matching it outranks the skill's style rules, including the em dash ban. The goal is the author's voice, not a generic "clean" register.
4. False-positive guardrails. A long "what NOT to flag" section prevents over-editing: curly quotes alone, em dashes alone, formal vocabulary, quoted or secondhand text, and plain dry prose are not evidence of AI on their own. The skill looks for clusters of tells, not isolated ones.

The process is a three-step loop: draft rewrite, then a self-audit ("What makes the below so obviously AI generated?" plus a fabrication check), then a final rewrite. Three invocation modes control the output: pasted text returns draft, audit notes, and final; file mode rewrites a file in place, touching prose only and leaving code blocks, frontmatter, data, and link targets alone; embedded mode returns only the final text, for use as one step inside a larger job run by another skill or agent.

## Quality assessment

For a prompt-only repo this is unusually well engineered. Metadata sync is enforced by CI rather than convention. The validator enforces a portability budget (SKILL.md stays under 500 lines) and rejects frontmatter keys that break other harnesses. AGENTS.md gives future contributors, human or agent, an explicit maintenance contract. The version history explains why each change was made, including behavioral fixes like the no-fabrication rule (closed issue #187 upstream).

Caveats worth knowing:

- It is a rewriting aid, not a guarantee. The output quality depends on the model applying the instructions, and no rewrite makes text undetectable to statistical detectors.
- The em dash ban is opinionated. It is deliberate (the em dash is one of the most reliable tells) and a user voice sample overrides it, but writers who like dashes will notice.
- File mode edits in place. On a shared repo that is fine under version control, but worth knowing before pointing it at the only copy of something.

## Fit for ClawTeam / AIOC

This repo's output is prose that goes to clients, consultants, and contract counterparties: formal correspondence, RFI narratives, EOT claim submissions, quality plans, progress reports, submittal reviews. Much of that starts as an AI draft. Humanizer is a natural final pass:

- Embedded mode is built for exactly this: a drafting skill (correspondence, claims, reports) can run humanizer as its last step and emit only the finished text.
- File mode fits the repo workflow: point it at a drafted letter or report in `docs/` and it rewrites in place.
- The no-fabrication rule aligns with contractual writing, where an invented date or name in a notice is worse than a stiff sentence.
- Voice calibration lets it match a PM's or director's actual writing style from a couple of sample paragraphs.

## Clone and install

The repo was cloned and reviewed at `/workspace/blader/humanizer` (session-local). Since session containers are ephemeral, the durable copy is vendored into this repo at `.claude/skills/humanizer/` (SKILL.md plus the upstream MIT license), following the same convention as the `/watch` skill. It loads automatically as a project skill in any Claude Code session on this repo.

Alternatives, if the team prefers them later:

- Per-user plugin install with automatic updates: `/plugin marketplace add blader/humanizer` then `/plugin install humanizer@humanizer` (invoked as `/humanizer:humanizer`).
- Cross-agent global install: `npx skills add blader/humanizer --global`.

To update the vendored copy, re-copy `SKILL.md` from the upstream repo and note the new version in the ClawTeam README.

## Version history highlights

Upstream has iterated steadily: 1.0.0 initial release; 2.0.0 rewrite from the raw Wikipedia article; 2.2.0 added the audit and second-pass rewrite; 2.4.0 added voice calibration; 2.7.0 and 2.8.0 expanded the list to 33 patterns and made the em dash rule a hard cut; 2.9.0 added the no-fabrication rule; 2.9.1 improved packaging and portability. The pattern list has been stable at 33 since 2.8.0.
