---
name: docs-style
description: Edit any writing that ships with the code — docs, ADRs, READMEs, commit messages, PR descriptions, docstrings, code comments, changelog/release notes, issue and ticket writeups — into a neutral, professional, just-the-facts tone. Apply whenever you write or edit such text, proactively and not only when explicitly asked to make it more professional, less salesy, or more concise.
argument-hint: [file-or-dir ...]
user-invocable: true
---

# Docs Style

Make writing that ships with the code read like a reference, not a pitch: neutral, direct,
concise, just-the-facts. This covers design docs, ADRs, and READMEs, but also commit
messages, PR descriptions, docstrings, code comments, changelog entries, and issue/ticket
writeups — any prose whose job is to explain, not persuade.

This is a tone-and-wording pass — preserve the information, cross-links, and code examples;
change how it reads, not what it says.

Assume every artifact is Markdown — docs, READMEs, commit messages, docstrings, and code
comments alike. Use Markdown for any markup: fenced ` ```lang ` blocks for code, backticks for
inline code, `-`/`*` lists. Don't use reStructuredText or other markup (e.g. a trailing `::`
literal block, `:param:` fields) even in docstrings; rewrite such markup as Markdown.

When invoked, apply the principles below to the target text ($ARGUMENTS, or the writing
under discussion).

**Judge by the whole unit, not the diff.** When your edit lands inside a larger unit — a
glossary entry, a docstring, an ADR section, a paragraph — re-read and fix that *entire* unit,
not just the lines you changed. Bloat accumulates over many small edits in lines no
single diff-scoped pass ever re-reads, so reviewing only the changed lines is the most common
reason a pass misses what it should have caught. If you touched a unit, you own all of it.

## Principles

1. **State the fact, not the verdict.** Cut sentences that sell a decision rather than
   describe it ("which is what makes X safe", "lowers the stakes to almost nothing",
   "reads far better", "by design", "the beauty is", "that's usually what you want"). And
   name the specific thing instead of asserting importance in the abstract: "the
   implications are significant", "the stakes are high", "this is the deepest problem" all
   say nothing — replace each with the concrete consequence, or cut it.

2. **Stay succinct and high-level.** Cover what the reader needs at the right altitude — the
   essential behavior and motivation — then stop; don't tour the internals. Let detail earn its
   place, and where the full detail lives elsewhere, summarize and link rather than reproduce
   it. Code comments are the exception: they can go into implementation specifics, but only
   where it helps the reader understand the code in front of them.

3. **Cut filler and throat-clearing.** Delete empty intensifiers and hedges — *really,
   just, simply, actually, genuinely, truly, fundamentally, inherently* (keep adverbs that
   carry information, like *asynchronously* or *lazily*). Delete announcement openers
   ("Here's the thing", "It turns out", "The truth is", "It's worth noting") and emphasis
   crutches ("This matters because", "Make no mistake", "Note that"). Delete rhetorical
   connectors that stage-direct the reader ("The point is…", "That's why…", "This isn't
   just tidiness."). In each case, keep the content and drop the frame.

4. **Drop binary-contrast framing.** State the point directly instead of telegraphing it
   through a negation: "Not X, it's Y", "The problem isn't X, it's Y", "X isn't the
   problem, Y is", and negative-listing buildups ("Not a cache, not a queue — a log"). Say
   "Y" or "The problem is Y." Replace with a positive statement.

5. **Emphasis is structural, not vocal.** Use italics only to introduce a defined term and
   bold only for headings/labels. Remove italics whose job is stress ("*really* the same",
   "*genuinely* ambiguous", "*after* aggregation"). Drop rhetorical absolutes
   (never/always/exactly/the one thing) unless they state a literal invariant.

6. **No decision-history narration.** The final state is the fact, not the path to it.
   Delete the play-by-play ("then we realized… then we dropped… an earlier draft
   bundled…") — this applies as much to a commit body or PR description as to an ADR.
   Where a rejected path is genuinely instructive, compress it to **one line** (in an ADR,
   under a "Considered and rejected" heading) — what was rejected and why, nothing more. A
   rejected path stated timelessly rather than as narration ("there is no X") is the same
   noise — see principle 10.

7. **One idea per sentence.** Break run-on chains and stacked parentheticals. An em-dash or
   parenthetical usually marks a second idea bolted onto the sentence, so treat each one as a
   prompt to restructure. If the aside is a full idea, give it its own sentence. If it is a
   qualifier, fold it into the main clause. If it is neither, cut it. Keep the dash or parens
   only for a short, subordinate aside that would derail as its own sentence.

8. **Cite precedent once.** Name prior art (a library, a paper, a sibling system) where it
   justifies a decision — once, where the decision is made. Don't repeat "the same idea as
   X" as reassurance elsewhere; reference and how-to text should define and instruct.

9. **Terminology discipline.** One term per concept, used consistently across the artifact
   and its neighbors. Define a term once. In a glossary, lead each entry with a one-sentence
   definition, then elaborate, and keep any rejected-synonym note to rejected terms only.
   When you rename a term or heading, propagate the new name everywhere the old one appears —
   across the library and its siblings, not just this file — and fix inbound links to the
   renamed anchor (the rename sweep in Quick self-check finds the stragglers). A glossary
   `_Avoid_` list rejects synonyms for *this* concept; before rejecting a term, confirm no
   sibling doc uses it as its own sanctioned term — if one does, the two docs contradict, so
   reconcile the naming instead of just listing it.

10. **No ghost alternatives.** Don't define or reassure by contrast with a design that was
   never shipped, or that the reader has no reason to expect — "there is no `:role` tag",
   "no separate additivity flag", "not a wrapper object". State what the thing *is*. A
   negation earns its place only when it redirects the reader away from something they'd
   actively expect and look for: a sibling system's feature ("no value-axis channel, no
   `:y`"), the previous version's API, or the obvious-but-wrong place to look ("granularity
   has no top-level key — it rides on the temporal dimension"). Test every "there is no X" /
   "not a Y": if a reader wouldn't have expected X unprompted, cut it and state the positive
   fact; if they would, keep it once. This is the static cousin of principle 6 — a rejected
   path needn't be narrated as history to be noise.

11. **Free verbs from hyphens; question hyphenated qualifiers.** Keep a verb a verb; don't glue a
   modifier onto it (or onto a state word) to coin a term the reader has to unfold. "frequency-rank
   them" → "rank them by frequency"; "lint-clean" → "passes the linter"; "row-drop the misses" →
   "drop the missing rows". The tell is a compound whose head is a verb, or that stands in for an
   action — rephrase as verb plus object, adverb, or prepositional phrase (a compound that has
   entered usage as a standard term, like "double-count", is exempt). A coined attributive adjective (a compound modifying a noun) is grammatically fine but
   usually adds implementation detail without clarity: "a content-addressed slice column" says no
   more to the caller than "a slice column", and "a hash-keyed cache" no more than "a cache". Cut
   the qualifier unless it separates the thing from an alternative the reader cares about
   ("single-grain dataset" earns it where multi-grain datasets exist; "lower-dimensional metric"
   earns it in a join). Standard prefixes ("re-fetch", "non-additive", "pre-aggregate") and
   established hyphenated nouns ("fan-out", "round-trip", "trade-off") are fine as-is.

12. **Say it plainly, from the reader's standpoint.** Prefer an active sentence that names the
   actor and what it does over a nominalized one that buries the actor in an abstract noun phrase
   and a trailing passive. The tell is an abstract subject plus a "…-ed automatically" tail that
   hides who acts — "the dependencies are resolved and wired in automatically". Name the agent
   and, where it helps, address the reader: "the framework resolves the dependencies and wires
   them in for you". This has no sell-word or punctuation signature, so no grep finds it — read
   each sentence and ask *who does what to what*; if the answer isn't in the sentence, rewrite it
   so it is.

## Applying across artifacts

The principles are the same everywhere; here is how they land on the common cases. Follow
each artifact's own format conventions — these notes are about wording, not format.

- **README / usage guides (README.md, USAGE.md):** an introductory guide teaches a reader
  to *use* the thing, so it is scoped and ordered differently from a reference. Introduce the
  data before the operations on it — a reader can't follow what a function does to a structure
  before knowing the structure, so lead with the record/frame shapes, then the verbs. Cover the
  main path, not the full surface: a usage guide is not the reference, so drop edge-case sections
  and API-inventory tables and let the schema, ADRs, and code own completeness (principle 2).
  Teach with paired good/bad examples that show the failure mode inline, rather than asserting a
  property in the abstract — the contrast is what the reader learns from. Say what the library
  *is*, not its role in the surrounding architecture, and explain in plain terms and known
  analogies (a SQL table, a left join) rather than coined internal vocabulary — let CONTEXT.md or
  the glossary own the terms so the guide doesn't require them pre-loaded (principle 9). Other
  docs — references, ADRs, glossaries — carry more detail and their own structure; these three
  moves are specific to the introductory guide.
- **Glossary / reference entries (CONTEXT.md, design docs):** lead with a one-sentence
  definition, then elaborate only as far as the reader needs to *recognize and use* the
  term, including how it differs from adjacent terms. Test every sentence after the
  definition and route what is not definitional to its home: *how* it works (the engine's
  steps and phases, the data structures, where a value physically rides) and *why* it
  exists (rationale, motivation, "it exists because…") go to the ADR or code; *which
  option* to pass (API forms, keys, shorthands, flags) goes to the usage guide; *what it
  replaced* (migration and precedent notes) is usually just cut. Keep only what lets a
  reader tell the term from its neighbors and use it correctly, and link out for the
  rest (principle 2). An entry grown past a tight
  paragraph is usually reproducing what an ADR or USAGE already owns. When two sibling
  entries explain the same thing, one owns it and the other links — define-once applied
  between entries, not only within one.
- **Commit messages / PR descriptions:** say what changed and why, and what a reviewer
  should check. Not a narrative of the debugging session (principle 6). No selling the
  change ("massively improves…") — state the effect. Keep it high-level (principle 2): a
  short prose summary of the change and its motivation, then a list of the new or changed
  public surface (e.g. new API methods, GraphQL resolvers, CLI flags) — not a per-file or
  per-function walkthrough of the implementation. Point to an ADR or doc for the reasoning behind a
  cross-cutting change rather than re-explaining it in the message. Even at a high level,
  call out any bug fixed in passing and any behavior or API change a caller could trip over
  (e.g. an argument that was silently ignored and is now honored) — these are what a reviewer
  and a future bisector most need to see, so keep them even when trimming detail elsewhere.
- **Docstrings / comments:** describe the behavior and contract plainly. Comments explain
  *why*; the code already shows *what*. No marketing ("a blazingly fast helper"). Keep a
  docstring to the contract (principle 2): the behavior, inputs/outputs, and invariants a
  caller needs, not a tour of the internals. **Default to one sentence — what it returns or
  does.** Add a second only for an input, invariant, or gotcha the caller can't infer from the
  signature (an error condition, a nil/empty edge, a required pre-narrowing). Past ~3 sentences,
  you are almost always explaining mechanism (*how* it works step by step), rationale (*why* it
  exists, what it's a dual of), or how it fits other functions — none of which the caller needs:
  cut it, or move a load-bearing *why* to a comment at the relevant line or an ADR. Symptoms to
  cut on sight: a sentence restating a phase pipeline, a "so that…/which lets…" clause justifying
  the design, narration of what a *sibling* function does with the result. Future-cleanup / TODO
  notes and references to internal collaborators go in comments by the relevant line, not in the
  docstring: the docstring is the current contract, and "remove after the legacy path is gone" is
  a maintenance note that bloats it and goes stale. A cross-reference that orients the caller among
  sibling APIs (variations of each other, like `sort` vs `sort-by`) earns its place — it tells
  them which of a related set to reach for. (A namespace/module-level or class-level docstring is
  the exception: a short orienting paragraph there is warranted, since it defines the central data
  shape and vocabulary once for everything below.)
- **Changelog / release notes:** one line per change, factual, user-facing effect first.
- **Issue / ticket writeups:** symptom, reproduction, expected vs actual. State the
  problem; skip the editorializing.

## ADR template

For an Architecture Decision Record, standardize to these sections, in order:

```
# <decision, stated as a fact>

## Context
The problem and constraints. No solution yet.

## Decision
What we do, in the present tense — the rule and contract the decision commits to, not how the code implements it. The longest of the four sections, but still tight.

## Considered and rejected
- **<Alternative>.** Rejected: <one-line reason>.

## Consequences
What this costs or commits callers to: caller-facing behavior, rough edges, deferrals — not the mechanism.
```

**One decision per ADR, and keep it short.** An ADR records a single decision, and most land
around 150–250 words: Context a sentence or two of problem, Decision a few short paragraphs or
a tight bullet list, the other two sections a few lines each. A genuinely intricate decision
runs to ~400, but that's the ceiling, not the target. When an ADR balloons past it, it is
almost always doing one of two things, and the word count is the symptom, not the problem:

- **Narrating mechanism** — the phase pipeline, helper and function names, internal flags, a
  step-by-step of how the engine resolves it. This belongs in code comments. The no-mechanism
  rule below is not scoped to Consequences: the Decision section states the rule and contract,
  not the implementation, so cut mechanism there too.
- **Bundling two decisions** — the tell is an "and" in the title or two independent rules in
  the Decision. Split it into one ADR each; two tight ADRs beat one sprawling one.

Also hold "Considered and rejected" to one line per alternative (what was rejected and why); a
multi-sentence rebuttal is itself mechanism narration.

Don't add a `Status` line — a merged ADR is an accepted one. Fold ad-hoc bold lead-ins
(`**Why:**`, `**Why not X:**`) into Context/Decision; move every "we rejected…" into
"Considered and rejected". If an ADR is later superseded, note it inline at the top
(`Superseded by #<nickname>-NNNN`, see below) rather than carrying a status on every ADR.

Keep Consequences caller-facing: state the observable effect and what it costs, not the
mechanism that produces it (helper names, data structures, internal wiring). Implementation
detail belongs in code comments, not the ADR.

Write a deferral as a trigger plus the option it leaves open — "if performance becomes an
issue, we can adopt a columnar library" — not a vague reassurance that the design is flexible
("easy to change later", "easy to work with"). The trigger tells a future reader when to
revisit the decision; "flexible" tells them nothing (principle 1).

## Cross-referencing ADRs

Every ADR carries an anchor token in an HTML comment on its own line directly under the H1:
`<!-- ##<nickname>-NNNN -->`. The double `##` marks the canonical definition (a citation uses a
single `#`, below); the nickname is the kebab-cased name of the component the ADR set governs —
the owning library, or the repo for a top-level set — and `NNNN` is the zero-padded number. So
`lib/metrics/adr/0005-….md` is `<!-- ##metrics-0005 -->`, `operations/data_service/adr/0001-….md`
is `<!-- ##data-service-0001 -->`, and a repo-wide `adr/0001-….md` is `<!-- ##<repo>-0001 -->`.
The comment keeps the token out of the rendered doc while leaving it as plain text a grep finds;
the token is derivable from the path.

Cite an ADR from a code comment or docstring with a single-`#` token, not a path or a bare
number: `(#metrics-0005)`, or `(#metrics-0005, #metrics-0006)` for several. A bare `ADR-0005`
is ambiguous once a repo has more than one ADR set, and the full path is long and not a clean
grep target. The token is short and unambiguous, and one grep (`rg '#metrics-0005'`) returns
the defining ADR (its `##` anchor) plus every site that cites it.

Cite the ADR from the code that implements the decision, not from code that merely uses it.
Several disparate implementation sites can each carry the link — this is about implementation
versus usage, not citing once. A function or type whose behavior embodies the decision cites
it; a caller that relies on that behavior does not.

In markdown prose — an ADR citing a sibling, or a CONTEXT/USAGE doc — keep a clickable
relative link, using the token as the link text: `[#metrics-0005](./adr/0005-….md)`. A reworded
label (`[metrics ADR-0005]`) still links, but drops out of the token grep above.

## What not to change

Information content, cross-references, anchors/links, code examples, and the structure of
instructional walk-throughs. If removing a phrase would drop a fact, rewrite the fact
neutrally instead of cutting it.

Some style guides ban sentence mechanics wholesale — em-dashes, all -ly adverbs, three-item
lists, wh- sentence openers, passive voice. This skill deliberately **does not**: none is
wrong here, and technical writing uses them well (e.g. "data is fetched at native
granularity"). But each reads as a mild tell when it piles up, so favor the lighter form on
a tie and trim overuse — fewer em-dashes, active voice where naming the actor helps. Never
contort a clear sentence to avoid one; that costs more than it saves.

## Quick self-check

Grep the result for residual tells and confirm each remaining hit is factual, not vocal:

```
grep -nEi "deliberate|simply|really|genuinely|actually|fundamentally|powerful|elegant|seamless|the beauty|reads (far )?better|that's usually|by design|it'?s worth noting|the point is|make no mistake|not (a|the) .*,? (it'?s|but)" <files>
```

Then sweep for ghost alternatives (principle 10) — confirm each hit redirects from a real
expectation, else cut it and state the positive fact:

```
grep -nEi "there (is|are|'s) no |no separate |not a (separate|top-level|new|real) |which avoids|what avoids" <files>
```

If you renamed a concept, term, or heading in this pass (principle 9), sweep the whole library
and its siblings — not just the files you edited — for the old name and for inbound links to the
old anchor. A rename that's clean in the file you touched still leaves stragglers and dangling
`#old-anchor` links elsewhere.

```
grep -rniE "<old-term>" <library-root> <sibling-roots>   # stale references to the renamed concept
grep -rnE  "#<old-anchor>" <library-root> <sibling-roots> # links to the renamed/removed heading
```

Then confirm every cross-reference resolves. Dead anchors and mislabeled citations slip in without
any rename, so this runs every pass, not only after one. List all in-doc anchor links and ADR
citations, and check each points at a real heading and the right file (slugify a heading the way the
renderer does: lowercase, spaces→`-`, punctuation dropped):

```
grep -rnoE '\]\([^)]*#[a-z0-9-]+\)' <files>          # each #anchor link — its target heading must exist
grep -rnoE '\[#[a-z0-9-]+-[0-9]+\]\([^)]+\)' <files> # each ADR citation — its number must match the target filename
```

Last, list every em-dash and parenthetical and re-read each against principle 7. Most mark a
second idea that reads clearer split into its own sentence or folded into the main clause; keep
the punctuation only where the aside is short and genuinely subordinate.

```
grep -nE "—|\(" <files>
```

This last grep assumes a prose file. On a code file (docstrings/comments embedded in
`.py`, `.go`, etc.) the two halves behave differently:

- `—` still travels: em-dashes don't occur in code syntax, so every hit is in a comment,
  docstring, or string. Keep this half.
- `\(` is prose-only: in code it matches every call, signature, and tuple, drowning the
  parenthetical asides it's meant to find. Drop it and review the prose lines directly —
  read the comment and docstring lines you added (for a commit, `git show <sha>` and scan
  the added `#`/docstring lines), since the grep can't tell `foo(v)` from "(now stale)"
  but your eye can.
