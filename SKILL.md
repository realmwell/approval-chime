---
name: approval-chime
description: "Plays a pleasant chime sound from the computer's speakers whenever Claude needs the user to approve something. Useful so the user can step away and be notified audibly. Only chimes once even if multiple approval prompts stack up."
metadata:
  author: maxmac
  version: "1.0.0"
---

# Approval Chime

Plays a pleasant audio chime on macOS whenever Claude Code is waiting for user approval, so the user can hear it from across the room.

## How It Works

This skill uses a **Claude Code hook** to trigger a shell script whenever a tool requires user permission. The script debounces so that if multiple tools need approval in quick succession, only one chime plays.

## Setup

Add the following hook to your Claude Code settings file (`~/.claude/settings.json` or project-level `.claude/settings.json`):

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.agents/skills/approval-chime/scripts/chime.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.agents/skills/approval-chime/scripts/chime.sh"
          }
        ]
      }
    ]
  }
}
```

Two hooks are used to cover all approval scenarios:
- **`PreToolUse`** — fires before every tool call, catching permission prompts
- **`Notification`** — fires when Claude sends a notification needing attention

The debounce in the script ensures only one chime plays even if both hooks fire.

## Configuration

### Changing the Sound

Edit `scripts/chime.sh` and replace the sound file path. Available macOS system sounds are in `/System/Library/Sounds/`:

| Sound | Character |
|-------|-----------|
| `Glass.aiff` | Pleasant chime (default) |
| `Hero.aiff` | Bright, upbeat |
| `Ping.aiff` | Short ping |
| `Pop.aiff` | Soft pop |
| `Purr.aiff` | Gentle purr |
| `Tink.aiff` | Light tink |

Example: `afplay /System/Library/Sounds/Hero.aiff &`

### Changing the Cooldown

Edit the `COOLDOWN_SECONDS` variable in `scripts/chime.sh`. Default is 5 seconds - any approval prompts within this window after the first chime will be silent.

## Files

- `SKILL.md` — This file (instructions and documentation)
- `scripts/chime.sh` — The chime script with debounce logic

## How the Debounce Works

1. When the hook fires, the script checks `/tmp/claude-approval-chime.lock` for a timestamp
2. If the last chime was less than `COOLDOWN_SECONDS` ago, it exits silently
3. Otherwise, it writes the current timestamp and plays the sound
4. The sound plays in the background (`&`) so it doesn't block Claude

## Uninstall

1. Remove the `Notification` and `PreToolUse` hook entries from your Claude Code settings
2. Delete the `~/.agents/skills/approval-chime/` directory
3. Optionally remove `/tmp/claude-approval-chime.lock`
