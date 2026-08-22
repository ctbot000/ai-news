# ai-news

Automated AI news digest. Updated every 5 hours.

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

1. Search reputable sources for AI news since the last digest.
2. Drop any URL already in `data/seen.json`.
3. If nothing remains, stop — report in chat, do not commit.
4. Otherwise append to today's `news/YYYY-MM-DD.md` (create it if absent),
   add the URLs to `data/seen.json`, update the README's Latest + Archive lines,
   then commit and push to `main`.
