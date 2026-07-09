# Writing style

## Prose that ships with code

Whenever you write or edit prose that ships with the code — commit messages, PR
descriptions, docstrings, code comments, docs, ADRs, changelogs, issue/ticket writeups —
follow the `docs-style` skill without being asked: neutral, succinct, just-the-facts, one
idea per sentence. Invoke `/docs-style` for any substantial writing or cleanup so the full
principles and self-check are in context.

## In chat, too

Chat is for discussing ideas, not reference material, so having a view and arguing for it is
welcome. Keep it succinct and direct — a few of the `docs-style` principles still apply:

- **Succinct and high-level.** Answer at the right altitude, then stop. Skip preamble.
- **Cut filler and throat-clearing.** No empty intensifiers or announcement openers ("Here's
  the thing", "It's worth noting", "Great question").
- **Drop binary-contrast framing.** State the point directly instead of "not X, it's Y".
- **Emphasis is structural, not vocal.** Bold and italics mark structure, not stress — don't
  italicize words to lean on them.
- **One idea per sentence.** An em-dash or parenthetical usually marks a second idea bolted
  on — split it into its own sentence or fold it into the main clause.

# Writing code

How I like code written. Applies to all languages; the examples are Clojure.

- **Short docstrings carried by an example.** One line saying what the function does, then a
  fenced `Example:` block with `#_=>` when the shape isn't obvious. Don't narrate the whole
  mechanism or the "why" in prose across multiple sentences. Keep the domain narrative in one
  place — the design doc / README / ADR — and don't restate it, or its issue/ADR citations,
  across docstrings.
- **Compile once, pass once.** Build a per-row/per-item function and run a single pass with
  composed transducers, rather than a separate whole-collection pass per case. Prefer named
  `*-fn` builders that return the function.
- **Small named helpers over inline lambdas.** Extract semantic predicates (`valid?`,
  `invalid?` as a `complement`) and small marker fns instead of inlining
  `(fn [[_ {:keys [status]}]] …)` or repeated `assoc`s.
- **Separate validation from transformation.** Pull checks into a dedicated `validate-*!`
  function, one `(when-let [x (not-empty …)] (throw …))` per check, instead of a `cond` with
  throws mixed into the transform.
- **Name and reuse schemas.** Extract a `(def FooOpts …)` and reference it from every arity;
  use the `:->` shorthand over `[:=> [:cat …] …]`.
- **Reach for existing helpers first.** Use library functions (`medley/filter-vals`, or `encore`
  functions, etc.) and add to the shared util namespace rather than hand-rolling `(into {} (filter …))`.
- **Make primitives total.** Handle the empty/edge case inside the low-level function (e.g. an
  empty filter → `(constantly true)`) so callers don't special-case it.
- **Prefer one explicit form over sugar plus normalization.** If a function needs a canonical
  input shape, take that shape. Don't accept a convenience form and expand it internally — the
  normalizer is indirection every reader and call site pays for. Add sugar only when call-site
  terseness clearly outweighs it.
- **Omit a key rather than assoc nil.** Use `(cond-> row p (assoc k v))`, not
  `(assoc row k (when p v))`.
- **Phase separation.** Split a transform into distinct passes with single responsibilities
  (normalize the inputs, then transform each item, then reduce) rather than interleaving them.
- **Flag known rough edges inline.** Leave a brief `;; MR:` comment marking something to
  revisit instead of resolving it silently or dropping it.
- **Tests assert structure, tolerantly.** Assert that a result embeds the expected shape
  (`=check=> deep-embeds?*`) rather than massaging the actual value to match an exact literal.
