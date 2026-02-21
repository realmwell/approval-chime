#!/bin/bash
# Plays a chime sound when Claude needs user approval.
# Debounces so only one chime plays even if multiple approvals stack up.

LOCK_FILE="/tmp/claude-approval-chime.lock"
COOLDOWN_SECONDS=5

# Check if we recently chimed (debounce)
if [ -f "$LOCK_FILE" ]; then
  last_chime=$(cat "$LOCK_FILE" 2>/dev/null)
  now=$(date +%s)
  elapsed=$((now - last_chime))
  if [ "$elapsed" -lt "$COOLDOWN_SECONDS" ]; then
    exit 0
  fi
fi

# Write current timestamp to lock file
date +%s > "$LOCK_FILE"

# Play the chime sound (non-blocking)
afplay /System/Library/Sounds/Glass.aiff &
