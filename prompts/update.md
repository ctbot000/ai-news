Update the AI news digest in this repository (your current working directory).
Read CLAUDE.md first — it defines the format and rules — then follow this procedure.

1. Read data/seen.json. Its "seen" array lists every article URL already published.

2. Use WebSearch to find AI news published since the most recent file in news/.
   Restrict yourself to reputable sources: techcrunch.com, cnbc.com, bloomberg.com,
   theinformation.com, and the labs' own blogs (openai.com, anthropic.com,
   deepmind.google, blog.google, ai.meta.com). Do NOT cite SEO content farms — they
   routinely invent model names, version numbers and release dates. If a claim
   appears only on a site you do not recognize, drop it.

   Important: reuters.com, theverge.com, arstechnica.com and wired.com block our
   crawler. Never put them in allowed_domains — a single blocked domain makes the
   whole search return HTTP 400 with zero results. An errored search means "not
   asked", NOT "no news"; fix the domain list and retry.

3. Drop every candidate whose URL already appears in data/seen.json.

4. If nothing new remains, publish nothing: no new file, no commit, no push. Say
   that there was no new AI news and stop. That is a successful run, not a failure.

5. Otherwise:
   - Append to news/YYYY-MM-DD.md for today's date, creating it with a
     "# AI News — YYYY-MM-DD" heading if absent.
   - One line per story, brief:
     `- **Bold headline.** One short clause. — [Source](url)`
     No paragraphs.
   - Add each new URL to the "seen" array in data/seen.json. Keep it valid JSON;
     verify with: python3 -c "import json;json.load(open('data/seen.json'))"
   - Update README.md so the "**Latest:**" line points at today's file, and add a
     dated line to the Archive list if not already present.
   - Commit naming the date and story count, then push to main.

Cap each run at roughly 7 stories, preferring the most consequential. Finish by
reporting in one or two lines what you published, or that there was nothing new.
