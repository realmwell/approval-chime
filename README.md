# Approval Chime for Claude Code

A [Claude Code](https://claude.ai/code) skill that plays a pleasant chime sound from your computer's speakers whenever Claude needs your approval. Step away from your desk and hear when you're needed.

**Only chimes once** even if multiple approval prompts stack up (5-second debounce).

## Install

1. Copy the skill to your skills directory:

```bash
mkdir -p ~/.agents/skills
cd ~/.agents/skills
git clone https://github.com/realmwell/approval-chime.git
chmod +x ~/.agents/skills/approval-chime/scripts/chime.sh
```

2. Add the hook to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PermissionRequest": [
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

3. Restart Claude Code.

## Configuration

### Change the sound

Edit `scripts/chime.sh` and swap the sound file. Available macOS system sounds (`/System/Library/Sounds/`):

| Sound | Character |
|-------|-----------|
| `Glass.aiff` | Pleasant chime (default) |
| `Hero.aiff` | Bright, upbeat |
| `Ping.aiff` | Short ping |
| `Pop.aiff` | Soft pop |
| `Purr.aiff` | Gentle purr |
| `Tink.aiff` | Light tink |

### Change the cooldown

Edit `COOLDOWN_SECONDS` in `scripts/chime.sh`. Default is 5 seconds.

## How it works

- `PermissionRequest` fires only when the user is shown a permission dialog
- The script checks a lockfile timestamp to debounce rapid-fire notifications
- Sound plays in the background so it doesn't block Claude

## Requirements

- macOS (uses `afplay` and system sounds)
- Claude Code with hooks support

## Uninstall

1. Remove the `PermissionRequest` hook from `~/.claude/settings.json`
2. Delete `~/.agents/skills/approval-chime/`

## License

MIT
