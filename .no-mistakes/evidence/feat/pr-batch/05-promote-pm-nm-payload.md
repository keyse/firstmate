Your scout task has been promoted to a ship task, mode=no-mistakes. Your window, worktree, and context stay as they are; only the contract below changes.

# Task
## Captain's intent
Fix what the scout found.

## Firstmate spec
If these promotion steps were already completed before a relaunch, preserve the existing `fm/pm-nm` branch and continue from its current state; do not repeat them destructively.
1. **Verify isolation before anything else.** Run `pwd -P` and `git rev-parse --show-toplevel`; both must resolve to the disposable task worktree you were launched in, such as a treehouse pool path or an Orca-managed worktree, not the primary checkout firstmate operates from. If either does not resolve to the worktree you were launched in, stop and escalate to firstmate.
2. Inventory this worktree's scratch state with `git status` and `git log` before changing anything.
3. Return to a clean default-branch base, then create your branch: `git checkout -b fm/pm-nm --`.
4. Carry over only the intended fix changes. Leave scratch commits, debug edits, and experiment files behind.
5. If you reproduced a bug, turn that reproduction into a regression test.
6. Treat the scout-time Firstmate spec and any unmarked legacy `# Task` text as investigation context, not captain intent or current ship-time instructions.
7. Everything else in your original instructions carries over unchanged: the status protocol; the instruction inbox and its acknowledgement; the escalation rules, including ask-user; and every safety rule, except where the current delivery contract below explicitly replaces scout-only delivery rules.


# Current delivery mode contract
This task is now kind=ship with mode=no-mistakes pr=batch.
This section supersedes every earlier brief instruction about delivery mode.
These current ship instructions supersede the scout delivery rules and report-based Definition of done.
Any earlier "Never push" or scout-only delivery language in this file is superseded.
This replaces the scout rule limiting outside-worktree writes to the report and status file.
Keep project edits inside this worktree; keep proof and scratch output outside it, under `/var/folders/zl/jngkp57j2fl0x5_p_m19jgfw0000gn/T//fm-lab.qIEfoH/data/pm-nm/` or a temporary directory.
Outside the worktree, write only that task material and the status and steering-inbox records authorized below.
Leave the worktree clean before reporting done.
The mode-specific Definition of done below is the current delivery contract.

# Current ship safety rule
1. Never push to the default branch. Never merge a PR. The one exception is `scripts/batch.sh ship`, which your Definition of done has you run: it pushes the project's batch branch, opens or extends the shared batch PR, and may arm its auto-merge under the project's own setting. Never push to a batch branch, or open, edit, merge, or close a batch PR, any other way.

The no-mistakes ask-user escalation below supersedes the scout rule 6 escalation shape.
   For a no-mistakes ask-user gate specifically, escalate all ask-user findings as one event plus one snapshot file, using that same shape even when the gate holds only a single ask-user finding: write only the ask-user findings, verbatim and unparaphrased (id, severity, file, line, description, authority), to `/var/folders/zl/jngkp57j2fl0x5_p_m19jgfw0000gn/T//fm-lab.qIEfoH/data/pm-nm/nm-<run>-findings.txt`, then report the gate with
   `needs-decision [at=<epoch>] [key=nm-<run>-<step>]: ask-user findings=<id1>,<id2>,... file=/var/folders/zl/jngkp57j2fl0x5_p_m19jgfw0000gn/T//fm-lab.qIEfoH/data/pm-nm/nm-<run>-findings.txt`
   naming every ask-user finding id from that gate. The status line only points at the file; it never restates or summarizes a finding's content.

# Definition of done
Delivery contract: mode=no-mistakes pr=batch
Ship branch: fm/pm-nm
This project batches its finished branches into one PR at a time with its own `scripts/batch.sh`, so **no-mistakes runs here as a validation pass that pushes the branch**, and the batch, not the pipeline, opens the PR.
Pass `--skip pr,ci` on every `no-mistakes axi run` for this task, and skip nothing else: `review`, `test`, `document`, `lint`, and `push` still run, and `ci` has no pipeline-opened PR to watch.
The task is complete only when committed on your branch.
When you believe it is complete, append `done [at=<epoch>]: {summary}` to the status file and stop.
Firstmate will then instruct you to run /no-mistakes to validate and push.
That first `done:` is the handoff that starts the pipeline, which owns the push; it is not a request to push from this copy.

You drive no-mistakes by responding to its gates, not by implementing fixes.
Follow the guidance no-mistakes itself provides for the mechanics: it loads when you invoke /no-mistakes, and `no-mistakes axi run --help` plus the `help` lines in each `axi` response are authoritative and version-matched to the installed binary.
When starting no-mistakes, pass `--intent` as only this brief's `## Captain's intent` subsection body, not its heading, plus any later words the captain actually said.
Preserve the actual words without adding speaker labels or direct address; the subsection heading supplies provenance outside the pipeline input.
For a legacy brief with no such subsection, include only words on lines marked `[captain] `, excluding that metadata prefix; never copy its mixed `# Task` wholesale.
If it has no provenance-marked captain words, stop and ask firstmate instead of starting no-mistakes.
Do not include `## Firstmate spec`, later Firstmate build constraints, or your own decisions and tradeoffs.
The `--intent` string you pass must be self-sufficient: that string plus the codebase must let a reader reconstruct roughly the same specification, without depending on a separate report, a PR, or context that lives only in this conversation.
When the captain's intent refers to a report, decision, or PR ("do items 1, 2, 3, and 7 of the report"), write the substance of the referenced items into `--intent` in the captain's terms, not only the pointer; that substance is the captain's ask by reference, while Firstmate's build instructions and your own decisions still stay out.
This replaces the no-mistakes skill's advice to enrich `--intent` with decisions and tradeoffs; that advice does not apply to Firstmate-dispatched work.
Do not hand-edit, commit, or fix findings yourself while a run is active - the pipeline applies every fix.

One drive call blocks until the next gate or outcome, which routinely outlives what your harness lets a single command run: Claude Code kills a command at ten minutes maximum, while one fix round is capped around thirty minutes and up to three rounds chain.
So background the drive call instead of sitting in one blocking hold your harness will kill, and read its return when it finishes.
Declare that wait using the brief's status-reporting rule before waiting on the backgrounded drive call.
Where a harness's own command limit is not established, assume it bounds commands and use that same backgrounded shape.
Whenever a drive call returns without a gate or an outcome - its own wait elapsed, or it was killed or timed out - reattach at once by re-running `no-mistakes axi run` without flags, backgrounded the same way; if it refuses because no run is active, read the finished outcome from `no-mistakes axi status`.
A killed or timed-out call is never evidence the daemon died: the daemon accepts your response immediately and runs the round in the background, so the call was only ever waiting for a read while the run kept working.
Reattach and keep going rather than reporting the pipeline blocked; rule 7 owns the checks that decide when a pipeline block is real.

Two firstmate-specific rules layer on top of that guidance:
- ask-user findings are never yours to answer: escalate to firstmate using rule 6's ask-user format and stop.
  Firstmate applies `ask-user-authority` and obtains any required captain decision.
  When the decision comes back, feed it to the gate with `no-mistakes axi respond` and let the pipeline apply it - do not route the question to "the user" or implement the fix yourself.
- NEVER pass `--yes` (or `-y`) to `no-mistakes axi run` or `no-mistakes axi respond`. It is banned fleet-wide.
  It auto-resolves every gate including ask-user findings with no escalation, and answering your own ask-user finding is a hard rule violation.

When the run's outcome is passed, passed-with-skips, or passed-with-override, its push step has put your validated branch on the forge.
Ship the pushed branch into a batch with the project's own `scripts/batch.sh`, run from this copy; its header explains the batching.
Until `scripts/batch.sh ship` takes `fm/pm-nm` into a batch it is still yours to fix. From that moment never rewrite it - no rebase, amend, reset, or force-push - because a batch merges each branch exactly as it was pushed.
1. Wait for the project's per-branch check on your pushed head: find its run, the newest one for your head commit in `gh run list --branch fm/pm-nm --limit 5`, and watch it with `gh run watch <id> --exit-status`, under the ten-minute command limit as the driving rules bound every wait, re-running the watch while it is still in progress.
   Then run `scripts/batch.sh status` and find `fm/pm-nm`. If it is still listed as waiting for that check, watch again.
   If it is listed as failed, read the failed run with `gh run view <id> --log-failed`, commit the fix on your branch, drive a new run with the same `--skip pr,ci`, which pushes it, and wait again.
2. Run `scripts/batch.sh ship`. It is idempotent: when it reports that another ship is running, run `scripts/batch.sh status` once more and then `ship` again.
   When it reports that `fm/pm-nm` conflicts with the batch, merge origin's default branch (`origin/<default>`) into your branch (`git fetch origin` first), resolve the conflict, drive a new run with the same `--skip pr,ci`, which pushes it, and go back to step 1.
3. Run `scripts/batch.sh status` again and find `fm/pm-nm`:
   - Under "in the open batch": the open batch PR carries your branch. Read its URL from `gh-axi pr view <number>`, with the number the status printed, and go to step 4.
   - Under "ready for the next batch": another batch is open and your branch waits for the next one, which is a normal outcome, not a failure. Append `paused [at=<epoch>]: queued for the next batch behind PR {open batch PR url}` and stop. When that PR merges or closes, firstmate tells you to resume, and you continue at step 2, which opens the next batch with your branch in it.
   - Under "fixes, joining the open batch at the next ship", or still waiting for the per-branch check: go back to step 1.
4. Wait for the batch PR's checks with `gh-axi pr checks <number> --watch`, under the ten-minute command limit as the driving rules bound every wait, and run the same command again whenever it returns with checks still pending. The project may merge a green batch on its own; a merged batch PR counts as green.
   - When its checks are green or it has merged, append `done [at=<epoch>]: PR {batch PR url} checks green` and stop. You are finished. Other tasks may report the same batch PR; firstmate tracks each against it, and they land together when it merges.
     That `done:` is accepted only when this copy's HEAD - your latest commit - is the pushed head of `fm/pm-nm`, so commit nothing after shipping.
   - When a check fails, do not fix it on your branch, which the batch already carries. Append `blocked [at=<epoch>]: batch PR {url} failed {check}: {one-line cause from its log}; needs a fix-forward branch cut from scripts/batch.sh base` and stop. Firstmate dispatches the fix as a separate task whose branch joins this batch, then tells you to resume at step 4.
   - When it closes without merging, go back to step 2.
Never run a `scripts/batch.sh` subcommand other than `status`, `ship`, and `base`.