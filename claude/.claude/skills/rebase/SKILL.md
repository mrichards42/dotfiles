---
name: rebase
description:
  Rebase the current branch onto another branch (default main), resolve the
  conflicts, then review what changed upstream and adapt the branch's work to
  it. Use when the user asks to rebase, update a branch from main, or bring a
  branch up to date.
argument-hint: [onto-branch or instructions]
user-invocable: true
---

# Rebase

Arguments: `$ARGUMENTS`

The arguments are usually a branch name. They may instead describe the rebase in
words, such as "onto the release branch" or "keep my version of the migration".
Pick the branch out of the description and follow any instructions in it.
Default to `main` when no branch is named.

1. **Check the state.** Run `git status`.
   - If a rebase is in progress, it likely stopped on conflicts. Read the
     original tip and target from `.git/rebase-merge/` (`orig-head`, `onto`) and
     go to step 3.
   - If the tree is dirty with no rebase in progress, stop and ask.
2. **Rebase.** Fetch (if not in a network-restricted sandbox), then run
   `git rebase --update-refs --autosquash` onto the newer of `<onto>` and
   `origin/<onto>`.
3. **Resolve conflicts.** Read upstream's change to each conflicted file and
   keep both sides' intent, including anything upstream added next to the
   branch's edits. Lint the auto-merged files too, since they can reference
   names the branch removed. Ask if a conflict needs a product decision.
   Continue until the rebase finishes.
4. **Adapt to upstream.** Review the upstream commits between the old merge-base
   and the target. Find new code that relies on what the branch changed, such as
   callers of a changed signature, tests against the old API, or features built
   the old way. Commit each fix separately on top of the current branch:
   - If the branch the fix belongs to has a remote branch, make a plain commit,
     unless the instructions ask for fixups.
   - Otherwise, commit it with `git commit --fixup=<commit it belongs to>`.

   A fix for a lower branch in a stack must touch only code that branch has.
   Otherwise moving it down conflicts or breaks that branch.

   Then place them all with one rebase:
   `GIT_SEQUENCE_EDITOR=<script> git rebase -i --update-refs --autosquash <target>`.
   The script moves each plain commit's `pick` line to just before the
   `update-ref` line of the branch it belongs to, so it lands at the top of that
   branch. Autosquash places the fixups. Commits for the current branch stay
   where they are. Pass `GIT_SEQUENCE_EDITOR=:` when there are no plain commits
   to move.

5. **Report.** List the conflicts and how you resolved them, and what step 4
   changed. Note that pushing needs a force-push. Don't push unless asked.
   When rebasing multiple branches, list all the branches, in order at the end.
