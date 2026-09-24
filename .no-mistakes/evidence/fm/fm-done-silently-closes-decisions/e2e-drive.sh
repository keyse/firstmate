#!/usr/bin/env bash
# Live E2E drive of firstmate CLIs (fm-wake-drain, fm-send --resolve-key,
# fm-fleet-snapshot, fm-fleet-view) against an isolated home.
# Usage: e2e-drive.sh <code-root> <label>
set -u
R=$1; L=$2
W=$(mktemp -d /tmp/fm-e2e-$L.XXXX)
FB=$W/fakebin; mkdir -p $FB
# tmux is not installed on this host: a transport stub that accepts send-keys,
# reports an empty composer and an idle pane.
cat > $FB/tmux <<'SH'
#!/usr/bin/env bash
case "${1:-}" in
  send-keys) exit 0 ;;
  display-message) for a in "$@"; do case "$a" in *cursor_y*) echo 1; exit 0;; *pane_current_command*) echo claude; exit 0;; esac; done; echo '%1'; exit 0 ;;
  capture-pane) printf '╭────╮\n│    │\n╰────╯\n'; exit 0 ;;
  list-windows) sed -n 's/^window=[^:]*://p' "$FM_HOME"/state/*.meta; exit 0 ;;
esac
exit 0
SH
printf '#!/usr/bin/env bash\nexit 0\n' > $FB/sleep
printf '#!/usr/bin/env bash\nexit 0\n' > $FB/no-mistakes
chmod +x $FB/*
H=$W/home; mkdir -p $H/state $H/data $H/projects/pin-wt $H/config
cat > $H/data/backlog.md <<B
## In flight
- [ ] dotfiles-pin-claude-code - Pin claude code (repo: dotfiles) (kind: ship) (since 2026-09-23)
B
cat > $H/state/dotfiles-pin-claude-code.meta <<M
window=firstmate:fm-dotfiles-pin-claude-code
worktree=$H/projects/pin-wt
project=dotfiles
harness=claude
kind=ship
mode=ship
M
K=nm-01M38NPKKB7XAK5R6ARXEJQCXB-ci-nochecks
S=$H/state/dotfiles-pin-claude-code.status
printf 'working: pinning claude-code\nneeds-decision [key=%s]: repo has no CI checks; merge anyway?\nworking: finishing the pin\ndone: PR checks green\n' "$K" > $S
run() { env -u NO_MISTAKES_GATE FM_GATE_REFUSE_BYPASS=1 PATH="$FB:$PATH" FM_ROOT_OVERRIDE="$H" FM_HOME="$H" FM_STATE_OVERRIDE="$H/state" FM_SEND_SETTLE=0 FM_SEND_LOG=$W/send.log "$@"; }
echo "######## [$L] code root: $R"
echo "=== status log"; cat $S
echo; echo "=== 1. wake drain after needs-decision then done:"
run "$R/bin/fm-wake-drain.sh" 2>&1 | sed -n '/OPEN DECISIONS/,$p' | head -8
run "$R/bin/fm-wake-drain.sh" 2>&1 | grep -q 'OPEN DECISIONS' && echo ">> OPEN DECISIONS present" || echo ">> NO OPEN DECISIONS section"
echo; echo "=== 2. fleet snapshot --json (task hints)"
run "$R/bin/fm-fleet-snapshot.sh" --json 2>/dev/null | jq -c '.tasks[] | select(.id=="dotfiles-pin-claude-code") | {id, current_state: .current_state.state, source: .current_state.source, pending_decision: .hints.pending_decision, open_decisions: [.hints.open_decisions[].key]}'
echo "=== 2b. --secondmate-home-summary decisions_open"
run "$R/bin/fm-fleet-snapshot.sh" --secondmate-home-summary 2>/dev/null | jq -c '[.decisions_open[] | {id,key}]'
echo "=== 2c. fleet view (human renderer)"
run "$R/bin/fm-fleet-view.sh" 2>&1 | head -30
echo; echo "=== 3. mistyped key refused"
run "$R/bin/fm-send.sh" dotfiles-pin-claude-code --resolve-key nm-typo "x" ; echo "rc=$?"
echo; echo "=== 4. fm-send --resolve-key $K"
run "$R/bin/fm-send.sh" dotfiles-pin-claude-code --resolve-key "$K" "moot now, PR merged" ; echo "rc=$?"
echo "--- status log tail"; tail -2 $S
echo "--- drain after answer"
run "$R/bin/fm-wake-drain.sh" 2>&1 | grep -q 'OPEN DECISIONS' && echo ">> OPEN DECISIONS still present" || echo ">> NO OPEN DECISIONS section"
run "$R/bin/fm-fleet-snapshot.sh" --json 2>/dev/null | jq -c '.tasks[] | select(.id=="dotfiles-pin-claude-code") | {current_state: .current_state.state, pending_decision: .hints.pending_decision, open_decisions: [.hints.open_decisions[].key]}'
echo; echo "=== 5. re-answer the now-closed key is refused"
run "$R/bin/fm-send.sh" dotfiles-pin-claude-code --resolve-key "$K" "again" ; echo "rc=$?"
rm -rf "$W"
