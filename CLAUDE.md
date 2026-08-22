# ai-news

Automated AI news digest. Updated every 6 hours.

## Rules

- **Brief.** One line per story: bold headline, one short clause, source link.
  No paragraphs, no summaries of summaries.
- **Only reputable sources.** TechCrunch, CNBC, Bloomberg, The Information, and
  the labs' own blogs. Skip SEO content farms — they invent model names and
  release dates that do not exist.
- **Only what is new.** `data/seen.json` holds every URL already published.
  Filter candidates against it before writing anything.
- **Publish nothing when nothing is new.** Say so in chat instead. An empty
  digest file or a "no news today" commit is not the goal.

## Update procedure

0. `git pull --rebase` first. More than one scheduler may write to this
   repo, and a stale checkout turns the final push into a non-fast-forward.
1. Search reputable sources for AI news since the last digest.
2. Drop any URL already in `data/seen.json`.
3. If nothing remains, stop — report in chat, do not commit.
4. Otherwise append to today's `news/YYYY-MM-DD.md` (create it if absent),
   add the URLs to `data/seen.json`, update the README's Latest + Archive lines,
   then commit and push to `main`.

## Scheduling

Run by the Claude Code scheduled task `ai-news-digest` (Routines in the app
sidebar), every 6 hours at `7 */6 * * *` in local time. The task prompt lives at
`~/.claude/scheduled-tasks/ai-news-digest/SKILL.md`; keep it in sync with
`prompts/update.md`.

Six hours, not five, because cron is a calendar filter rather than an interval
timer: `*/5` on hours selects 00/05/10/15/20 and then wraps, giving four 5-hour
gaps and one 4-hour gap at midnight. Only steps that divide 24 are uniform. The
minute is 7 rather than 0 to stay off the crowded top of the hour.
