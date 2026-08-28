# ai-news

Automated AI news digest. Updated every 6 hours.

## Rules

- **Brief.** One line per story: bold headline, one short clause, source link.
  No paragraphs, no summaries of summaries.
- **Only reputable sources.** TechCrunch, CNBC, Bloomberg, The Information, and
  the labs' own blogs. Skip SEO content farms — they invent model names and
  release dates that do not exist.
- **Technical, not financial.** Prefer model and product releases, research
  results, benchmarks, architectures, open source, and chip or infrastructure
  engineering. Skip funding rounds, valuations, M&A, stock moves and regulatory
  drama unless what is being *built* is the point of the story.
- **One story per run.** Publish the single most technical of the new
  candidates, not a roundup. Everything else is dropped, however consequential
  — and dropped stories are not recorded in `data/seen.json`, so a later run
  can still pick one up if it is that run's most technical candidate.
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
4. Otherwise pick the one most technical story, append it to today's
   `news/YYYY-MM-DD.md` (create it if absent), add its URL to `data/seen.json`,
   update the README's Latest + Archive lines, then commit and push to `main`.

## Scheduling

Run by the Claude Code scheduled task `ai-news-digest` (Routines in the app
sidebar), every 6 hours at `7 */6 * * *` in local time.

The prompt lives in this repo, at `scheduled-tasks/ai-news-digest/SKILL.md`.
The registered task holds only a pointer to it: it sets PATH, changes to this
directory, runs `git pull --rebase`, then reads that file and follows it. So
edits here take effect on the next run — there is nothing to copy back.

Change the registered task itself only to alter the bootstrap (the repo path or
the schedule). Everything about *what the digest does* belongs in the file.

### Model and effort

The routine runs on Opus 5 with ultracode (xhigh effort plus dynamic-workflow
orchestration). Three pieces have to line up, and they live in three places:

- **Model** — the per-routine `model` field, set in the Routines UI. The
  scheduled-task MCP tools do not expose it.
- **Ultracode** — `ultracode: true` in `.claude/settings.local.json` (gitignored,
  so it is per-machine and has to be re-applied on a new checkout), alongside
  `enableWorkflows: true` and `model`. There is no per-routine effort field.
- **Permission to orchestrate** — the Orchestration section of the task file.
  Sessions carry a standing "do not use workflows unless the user requested it"
  instruction, so ultracode alone changes the effort level and nothing else. The
  task prompt has to make the request itself.

The `ultracode` keyword in a prompt does *not* work here: a scheduled fire is
non-human input, and the keyword trigger is gated against that.

To check whether a run actually had it, look for an `ultra_effort_enter`
attachment in the run's transcript under
`~/.claude/projects/-Users-izeye-workspaces-claude-ai-news/`. Grepping for the
reminder text finds nothing — transcripts store the attachment type, not the
rendered string.

Six hours, not five, because cron is a calendar filter rather than an interval
timer: `*/5` on hours selects 00/05/10/15/20 and then wraps, giving four 5-hour
gaps and one 4-hour gap at midnight. Only steps that divide 24 are uniform. The
minute is 7 rather than 0 to stay off the crowded top of the hour.

## Website

Published with GitHub Pages from `main` (root) at
https://ctbot000.github.io/ai-news/ — Jekyll renders the Markdown, and
`jekyll-relative-links` rewrites `news/*.md` links to their `.html` pages, so
digests stay plain Markdown with no front matter.

`README.md` is the site's index. Its **Latest** and Archive lines are what a
visitor navigates by, so keeping them current is part of publishing, not
bookkeeping. `_config.yml` excludes repo plumbing from the site.
