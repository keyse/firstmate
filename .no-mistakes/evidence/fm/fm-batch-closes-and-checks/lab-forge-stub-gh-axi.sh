#!/bin/bash
# Disposable forge stub for a lab batch PR. Scenario from $LAB_SCENARIO.
echo "gh-axi $*" >> "$LAB_LOG"
url="https://github.com/example/warka/pull/1264"
case "$1 $2" in
"pr view") echo "number: 1264"; echo "url: $url"; echo "title: Batch: 3 branches"; echo "state: MERGED"; echo "mergedAt: 2026-11-27T10:00:00Z";;
"pr checks")
  case "$LAB_SCENARIO" in
   failed) printf 'checks[2]{name,state,link}:\n  build,pass,https://github.com/example/warka/actions/runs/1/job/1\n  e2e-golden-path,fail,https://github.com/example/warka/actions/runs/2/job/2\n'; exit 1;;
   cancelled) printf 'checks[2]{name,state,link}:\n  build,pass,https://github.com/example/warka/actions/runs/1/job/1\n  e2e-golden-path,cancel,https://github.com/example/warka/actions/runs/2/job/2\n'; exit 1;;
   skipped) printf 'checks[2]{name,state,link}:\n  build,pass,https://github.com/example/warka/actions/runs/1/job/1\n  e2e-golden-path,skipping,https://github.com/example/warka/actions/runs/2/job/2\n';;
  esac;;
*) echo "unsupported in lab stub" >&2; exit 2;;
esac
