---
name: ai-news-digest
description: Publishes new AI news to the ctbot000/ai-news repo every 6 hours; stays silent when there is nothing new.
---

Update the AI news digest in the repository at /Users/izeye/workspaces/claude/ai-news.

Work from that directory. Prepend /opt/homebrew/bin to PATH — Homebrew is Apple Silicon and is not on the inherited PATH.

The repo's CLAUDE.md and prompts/update.md hold the authoritative rules; read them first. The procedure, in summary:

1. `git pull --rebase` before touching anything, so the final push is not a non-fast-forward.

2. Read data/seen.json. Its "seen" array lists every article URL already published.

3. Use WebSearch to find AI news published since the most recent file in news/. Restrict yourself to reputable sources: techcrunch.com, cnbc.com, bloomberg.com, theinformation.com, and the labs' own blogs (openai.com, anthropic.com, deepmind.google, blog.google, ai.meta.com). Do NOT cite SEO content farms — they routinely invent model names, version numbers and release dates. If a claim appears only on a site you do not recognize, drop it.

   Important: reuters.com, theverge.com, arstechnica.com and wired.com block our crawler. Never put them in allowed_domains — one blocked domain makes the whole search return HTTP 400 with zero results. An errored search means "not asked", NOT "no news"; fix the domain list and retry.

4. Drop every candidate whose URL already appears in data/seen.json. Also drop anything that merely restates a story already in today's digest from a different outlet.

5. If nothing new remains, publish nothing: no new file, no commit, no push. Report "no new AI news" in one line and stop. That is a successful run, not a failure.

6. Otherwise:
   - Append to news/YYYY-MM-DD.md for today's date, creating it with a "# AI News — YYYY-MM-DD" heading if absent.
   - One line per story, and keep it brief: `- **Bold headline.** One short clause. — [Source](url)`. No paragraphs.
   - Add each new URL to the "seen" array in data/seen.json. Keep it valid JSON; verify with: python3 -c "import json;json.load(open('data/seen.json'))"
   - Update README.md so the "**Latest:**" line points at today's file, and add a dated line to the Archive list if not already present.
   - Commit naming the date and story count, then push to main.

Cap each run at roughly 7 stories, preferring the most consequential. Brevity is a hard requirement from the user: one line per story, never a paragraph.

Finish with a one- or two-line report of what you published, or that there was nothing new.