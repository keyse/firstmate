Your scout task has been promoted to a ship task, mode=direct-PR. Your window, worktree, and context stay as they are; only the contract below changes.

# Task
## Captain's intent
Fix what the scout found.

## Firstmate spec
If these promotion steps were already completed before a relaunch, preserve the existing `fm/pm-dpr` branch and continue from its current state; do not repeat them destructively.
1. **Verify isolation before anything else.** Run `pwd -P` and `git rev-parse --show-toplevel`; both must resolve to the disposable task worktree you were launched in, such as a treehouse pool path or an Orca-managed worktree, not the primary checkout firstmate operates from. If either does not resolve to the worktree you were launched in, stop and escalate to firstmate.
2. Inventory this worktree's scratch state with `git status` and `git log` before changing anything.
3. Return to a clean default-branch base, then create your branch: `git checkout -b fm/pm-dpr --`.
4. Carry over only the intended fix changes. Leave scratch commits, debug edits, and experiment files behind.
5. If you reproduced a bug, turn that reproduction into a regression test.
6. Treat the scout-time Firstmate spec and any unmarked legacy `# Task` text as investigation context, not captain intent or current ship-time instructions.
7. Everything else in your original instructions carries over unchanged: the status protocol; the instruction inbox and its acknowledgement; the escalation rules, including ask-user; and every safety rule, except where the current delivery contract below explicitly replaces scout-only delivery rules.


# Current delivery mode contract
This task is now kind=ship with mode=direct-PR pr=batch.
This section supersedes every earlier brief instruction about delivery mode.
These current ship instructions supersede the scout delivery rules and report-based Definition of done.
Any earlier "Never push" or scout-only delivery language in this file is superseded.
This replaces the scout rule limiting outside-worktree writes to the report and status file.
Keep project edits inside this worktree; keep proof and scratch output outside it, under `/var/folders/zl/jngkp57j2fl0x5_p_m19jgfw0000gn/T//fm-lab.qIEfoH/data/pm-dpr/` or a temporary directory.
Outside the worktree, write only that task material and the status and steering-inbox records authorized below.
Leave the worktree clean before reporting done.
The mode-specific Definition of done below is the current delivery contract.

# Current ship safety rule
1. Never push to the default branch (push only your `fm/pm-dpr` branch). Never merge a PR. The one exception is `scripts/batch.sh ship`, which your Definition of done has you run: it pushes the project's batch branch, opens or extends the shared batch PR, and may arm its auto-merge under the project's own setting. Never push to a batch branch, or open, edit, merge, or close a batch PR, any other way.

# Definition of done
Delivery contract: mode=direct-PR pr=batch
Ship branch: fm/pm-dpr
This task ships **direct-PR** without the no-mistakes pipeline into a project that batches its finished branches into one PR at a time, so you push your branch and its batch, not you, opens the PR.
The task is complete only when committed on your branch.
When it is implemented and committed, push your branch (`git push origin HEAD:refs/heads/fm/pm-dpr`) and open no PR.
Ship the pushed branch into a batch with the project's own `scripts/batch.sh`, run from this copy; its header explains the batching.
Until `scripts/batch.sh ship` takes `fm/pm-dpr` into a batch it is still yours to fix. From that moment never rewrite it - no rebase, amend, reset, or force-push - because a batch merges each branch exactly as it was pushed.
1. Wait for the project's per-branch check on your pushed head: find its run, the newest one for your head commit in `gh run list --branch fm/pm-dpr --limit 5`, and watch it with `gh run watch <id> --exit-status`, under the ten-minute command limit as the driving rules bound every wait, re-running the watch while it is still in progress.
   Then run `scripts/batch.sh status` and find `fm/pm-dpr`. If it is still listed as waiting for that check, watch again.
   If it is listed as failed, read the failed run with `gh run view <id> --log-failed`, commit the fix on your branch, push the branch again, and wait again.
2. Run `scripts/batch.sh ship`. It is idempotent: when it reports that another ship is running, run `scripts/batch.sh status` once more and then `ship` again.
   When it reports that `fm/pm-dpr` conflicts with the batch, merge origin's default branch (`origin/<default>`) into your branch (`git fetch origin` first), resolve the conflict, push the branch again, and go back to step 1.
3. Run `scripts/batch.sh status` again and find `fm/pm-dpr`:
   - Under "in the open batch": the open batch PR carries your branch. Read its URL from `gh-axi pr view <number>`, with the number the status printed, and go to step 4.
   - Under "ready for the next batch": another batch is open and your branch waits for the next one, which is a normal outcome, not a failure. Append `paused [at=<epoch>]: queued for the next batch behind PR {open batch PR url}` and stop. When that PR merges or closes, firstmate tells you to resume, and you continue at step 2, which opens the next batch with your branch in it.
   - Under "fixes, joining the open batch at the next ship", or still waiting for the per-branch check: go back to step 1.
4. Wait for the batch PR's checks with `gh-axi pr checks <number> --watch`, under the ten-minute command limit as the driving rules bound every wait, and run the same command again whenever it returns with checks still pending. The project may merge a green batch on its own; a merged batch PR counts as green.
   - When its checks are green or it has merged, append `done [at=<epoch>]: PR {batch PR url} checks green` and stop. You are finished. Other tasks may report the same batch PR; firstmate tracks each against it, and they land together when it merges.
     That `done:` is accepted only when this copy's HEAD - your latest commit - is the pushed head of `fm/pm-dpr`, so commit nothing after shipping.
   - When a check fails, do not fix it on your branch, which the batch already carries. Append `blocked [at=<epoch>]: batch PR {url} failed {check}: {one-line cause from its log}; needs a fix-forward branch cut from scripts/batch.sh base` and stop. Firstmate dispatches the fix as a separate task whose branch joins this batch, then tells you to resume at step 4.
   - When it closes without merging, go back to step 2.
Never run a `scripts/batch.sh` subcommand other than `status`, `ship`, and `base`.
Do NOT run /no-mistakes. The configured merge authority decides whether to merge the batch PR; firstmate relays the outcome.