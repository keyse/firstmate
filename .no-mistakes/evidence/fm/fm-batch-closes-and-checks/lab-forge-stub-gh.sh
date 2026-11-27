#!/bin/bash
echo "gh $*" >> "$LAB_LOG"
if [ "$1 $2" = "run view" ]; then
  case "$LAB_SCENARIO" in
    failed) echo "e2e-golden-path  Run tests  FAIL GoldenPath.Checkout: expected receipt page, got 500 from /api/payments";;
    cancelled) echo "e2e-golden-path  The operation was canceled. Concurrency group cancelled after merge.";;
  esac; exit 0; fi
echo "unsupported in lab stub" >&2; exit 2
