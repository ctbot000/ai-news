---
name: ai-news-digest
description: Publishes new AI news to the ctbot000/ai-news repo every 6 hours; stays silent when there is nothing new.
---

This file is the authoritative prompt for the `ai-news-digest` scheduled task.
The task registered in Claude Code holds only a pointer to it, so edits here
take effect on the next run — no copying back required.

You are already in this repository, with `git pull --rebase` done. CLAUDE.md
holds the standing rules; this file is the procedure.

Run every shell command as its own Bash call. Do not chain with `&&` or `;`, and
do not prefix a command with `export` — a compound command matches no permission
rule, so an unattended run stops on a prompt nobody is there to answer. PATH
needs no changes: `git` and `python3` are in /usr/bin, and the GitHub credential
helper is configured with an absolute path (`!/opt/homebrew/bin/gh auth
git-credential`), so pushes authenticate with or without Homebrew on PATH.

All dates are Korean time (KST, UTC+9), the machine's local zone — `date +%F` is
already correct. Never use a UTC date for the digest filename; for nine hours of
every day it names the wrong file.

1. Read `data/seen.json`. Its `seen` array lists every article URL already
   published.

2. Use WebSearch to find AI news published since the most recent file in
   `news/`. Restrict yourself to reputable sources: techcrunch.com, cnbc.com,
   bloomberg.com, theinformation.com, and the labs' own blogs (openai.com,
   anthropic.com, deepmind.google, blog.google, ai.meta.com). Do NOT cite SEO
   content farms — they routinely invent model names, version numbers and
   release dates. If a claim appears only on a site you do not recognize, drop
   it.

   Important: reuters.com, theverge.com, arstechnica.com and wired.com block our
   crawler. Never put them in `allowed_domains` — one blocked domain makes the
   whole search return HTTP 400 with zero results. An errored search means "not
   asked", NOT "no news"; fix the domain list and retry.

3. Drop every candidate whose URL already appears in `data/seen.json`. Also drop
   anything that merely restates a story already in today's digest from a
   different outlet.

4. If nothing new remains, publish nothing: no new file, no commit, no push.
   Report "no new AI news" in one line and stop. That is a successful run, not a
   failure.

5. Otherwise:
   - Append to `news/YYYY-MM-DD.md` for today's KST date, creating it with a
     `# AI News — YYYY-MM-DD` heading if absent.
   - One line per story, and keep it brief:
     `- **Bold headline.** One short clause. — [Source](url)`. No paragraphs.
   - Add each new URL to the `seen` array in `data/seen.json`. Keep it valid
     JSON; verify with `python3 -c "import json;json.load(open('data/seen.json'))"`.
   - Update `README.md` so the `**Latest:**` line points at today's file, and add
     a dated line to the Archive list if not already present.
   - Stage explicit paths rather than `git add -A`, read back
     `git diff --cached --name-status` before committing, then commit naming the
     date and story count, and push to `main`.

Cap each run at roughly 7 stories, preferring the most consequential. Brevity is
a hard requirement from the user: one line per story, never a paragraph.

Finish with a one- or two-line report of what you published, or that there was
nothing new.
