#!/usr/bin/env bash
# A) Upgrade: a home drained by the base code (fold v8 cursor that dropped the
#    decision at done:) is then drained by the head code.
# B) Current-state + working: line: fm-crew-state reading for a finished ship,
#    a later working: line, and a decision opened AFTER done:.
set -u
BASE=$1; HEAD=$2
W=$(mktemp -d /tmp/fm-e2e-up.XXXX); H=$W/home; mkdir -p $H/state $H/data $H/projects/wt
FB=$W/fb; mkdir -p $FB; cat > $FB/tmux <<'SH'
#!/usr/bin/env bash
case "$1" in display-message) case "$*" in *pane_current_command*) echo claude;; *) echo '%1';; esac;; list-windows) echo fm-t1;; capture-pane) printf 'quiet\n> \n';; esac; exit 0
SH
 printf '#!/usr/bin/env bash\nexit 0\n' > $FB/no-mistakes; chmod +x $FB/*
printf 'window=firstmate:fm-t1\nworktree=%s/projects/wt\nkind=ship\nharness=claude\n' "$H" > $H/state/t1.meta
S=$H/state/t1.status
printf 'needs-decision [key=ci-nochecks]: merge without CI?\ndone: PR checks green\n' > $S
run() { local r=$1; shift; env -u NO_MISTAKES_GATE FM_GATE_REFUSE_BYPASS=1 PATH="$FB:$PATH" FM_HOME=$H FM_ROOT_OVERRIDE=$H FM_STATE_OVERRIDE=$H/state "$r/bin/$@" 2>&1; }
echo "=== A. base drain (persists its fold cursor)"
run $BASE fm-wake-drain.sh | grep -E 'OPEN DECISIONS|key=' || echo ">> base: no OPEN DECISIONS"
echo "--- cursor files:"; ls -a $H/state | grep -iv -E '^\.$|^\.\.$' | grep -i -E 'cursor|fold|open' ; for c in $(ls -a $H/state | grep -i -E 'cursor|open-dec'); do echo "[$c]"; head -3 "$H/state/$c"; done
echo "--- head drain on the same home (upgrade):"
run $HEAD fm-wake-drain.sh | grep -E 'OPEN DECISIONS \(|key=' || echo ">> head: no OPEN DECISIONS"
echo
# mark the harness idle through its semantic busy record so the status log is the current-state source
gen=$(run $HEAD fm-busy-event.sh arm $H/state t1); run $HEAD fm-busy-event.sh apply $H/state t1 idle --gen "$gen" --source claude-hook --event stop >/dev/null
echo "=== B1. crew state of a finished ship holding an older open decision"
run $HEAD fm-crew-state.sh t1 | head -5
echo "=== B2. a later working: line does not close the decision"
printf 'working [key=ci-nochecks]: started on the answer\n' >> $S
run $HEAD fm-wake-drain.sh | grep -E 'key=ci-nochecks' || echo ">> closed (unexpected)"
echo "=== B3. decision opened AFTER done: becomes current state"
printf 'needs-decision [key=post-done]: re-open the PR?\n' >> $S
run $HEAD fm-crew-state.sh t1 | head -5
run $HEAD fm-wake-drain.sh | grep -E 'key=' 
rm -rf $W
