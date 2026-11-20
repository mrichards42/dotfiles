# Verification and Testing

When iterating on code or design, only run checks that finish in a couple of
seconds, such as linters, formatters and type checkers on the changed files. Run
tests in the background, at most one run at a time: don't stop or restart a run
when new commits land, and when it finishes, start one more against the newest
commit if it didn't cover it. Don't wait on a background run: reply right away,
and report the result when it arrives. I place a premium on fast iteration and
code review, so a foreground run blocks my workflow.

Once a design is settled and I'm happy with the code, run a full verification
pass in the background: the relevant test suites on every branch of the stack,
plus linters and type checks. Report each branch's results.

# Writing style

## Prose that ships with code

Whenever you write or edit prose that ships with the code — commit messages, PR
descriptions, docstrings, code comments, docs, ADRs, changelogs, issue/ticket
writeups — follow the `docs-style` skill without being asked: neutral, succinct,
just-the-facts, one idea per sentence. Invoke `/docs-style` for any substantial
writing or cleanup so the full principles and self-check are in context.

## In chat, too

Chat is for discussing ideas, not reference material, so having a view and
arguing for it is welcome. Keep it succinct and direct — a few of the
`docs-style` principles still apply:

- **Succinct and high-level.** Answer at the right altitude, then stop. Skip
  preamble.
- **Cut filler and throat-clearing.** No empty intensifiers or announcement
  openers ("Here's the thing", "It's worth noting", "Great question").
- **Drop binary-contrast framing.** State the point directly instead of "not X,
  it's Y".
- **Emphasis is structural, not vocal.** Bold and italics mark structure, not
  stress — don't italicize words to lean on them.
- **One idea per sentence.** An em-dash or parenthetical usually marks a second
  idea bolted on — split it into its own sentence or fold it into the main
  clause.

## Formatting

When writing markdown files, do not worry about manual formatting, use prettier
to format them after the fact:

```sh
prettier --prose-wrap always
```

# Writing code

How I like code written. Applies to all languages; the examples are Clojure.

## Principles

General design ideas to reason from.

- **Separation of concerns.** Give each function, namespace, and data structure
  a single concern, and combine them only where a consumer needs both at once.
  In a data-driven UI, keep the plain data manipulation (reshaping, aggregating,
  joining) apart from the UI-specific transformation (resolving labels,
  formatting, layout), even where both are pure. Data read or changed
  independently belongs in separate shapes.
- **Functional core, imperative shell.** Keep the logic a pipeline of pure
  functions over plain data, and push side effects out to a thin shell around
  it: I/O, persistence, rendering, and encoding to an external API's format.
- **Phase separation.** Model complicated logic as a series of small passes
  (normalize the inputs, transform each item, then reduce), each with one
  responsibility and each consuming the previous step's output. Compute an
  intricate transform on its own, then layer further concerns such as annotation
  over its finished result. Drop a pass that only forwards its input.
- **Name domain concepts as functions or data types.** When a transformation
  carries meaning or recurs, extract and name it (a `join`, a `merge`, or a
  semantic predicate such as `valid?`/`invalid?` via `complement`) instead of
  leaving an anonymous `reduce` or lambda inline. Likewise name a recurring
  shape as a type or schema, referenced from every arity (`def FooOpts`). A
  trivial one-off lambda, or a keyword used as a function, stays inline; don't
  extract for its own sake. Named concepts compose, and call sites read as
  operations on domain objects.
- **Prefer one explicit form over sugar plus normalization.** If a function
  needs a canonical input shape, take that shape. Don't accept a convenience
  form and expand it internally — the normalizer is indirection every reader and
  call site pays for. Add sugar only when call-site terseness clearly outweighs
  it.
- **Avoid overly defensive code.** Trust invariants the caller's contract
  guarantees. Add an assert only when the invariant isn't obvious at the call
  site, or a validation function when incorrect input provided by the user is an
  actual possibility. Reserve defensive handling for inputs the contract
  actually allows to be partial or nil.

## Idioms and details

Specific conventions to apply as you write.

- **Short docstrings carried by an example.** One line saying what the function
  does, then a fenced `Example:` block with `#_=>` when the shape isn't obvious.
  Don't narrate the whole mechanism or the "why" in prose across multiple
  sentences. Keep the domain narrative in one place — the design doc / README /
  ADR — and don't restate it, or its issue/ADR citations, across docstrings.
- **Separate validation from transformation.** Pull checks into a dedicated
  `validate-*!` function, one `(when-let [x (not-empty …)] (throw …))` per
  check, instead of a `cond` with throws mixed into the transform.
- **Compile once, pass once.** Where you'd otherwise walk the same collection
  several times, build a per-item function and run one pass with composed
  transducers (a named `*-fn` builder that returns it). For a single
  straightforward pass, a plain `mapv`/`->>` is clearer; reserve the transducer
  machinery for removing redundant passes or a hot path.
- **Reach for existing helpers first.** Use library functions
  (`medley/filter-vals`, or `encore` functions, etc.) and add to the shared util
  namespace rather than hand-rolling `(into {} (filter …))`.
- **Prefer the `:->` schema shorthand.** Use `:->` over the longhand
  `[:=> [:cat …] …]`.
- **Make primitives total.** Handle the empty/edge case inside the low-level
  function (e.g. an empty filter → `(constantly true)`) so callers don't
  special-case it.
- **Don't intentionally assoc nil.** For a conditional key, omit it with
  `(cond-> row p (assoc k v))` instead of `(assoc row k (when p v))`. The rule
  targets deliberately storing nil; where a nil arises naturally and the
  straightforward code reads better, leave it, rather than contorting the code
  to purge every nil.
- **Flag known rough edges inline.** Leave a brief `;; TODO:` comment marking
  something to revisit instead of resolving it silently or dropping it.
- **Tests assert structure, tolerantly.** Assert that a result embeds the
  expected shape (`=check=> deep-embeds?*`) rather than massaging the actual
  value to match an exact literal.

# Git

Before making any changes in git, run `git status` to confirm the working tree
is in the state you think it is. I will sometimes run git commands outside of a
claude code session.
