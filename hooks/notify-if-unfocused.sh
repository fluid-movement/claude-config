#!/bin/bash
# Sends a terminal-notifier notification only if the given app is not frontmost.
# Usage: notify-if-unfocused.sh <AppName> <message> <title> <sound>

APP="${1:-Ghostty}"
MESSAGE="${2:-Claude has finished}"
TITLE="${3:-Claude Code}"
SOUND="${4:-Glass}"

FOCUSED=$(osascript -e "tell application \"System Events\" to get frontmost of process \"$APP\"" 2>/dev/null)

if [ "$FOCUSED" != "true" ]; then
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"default\""
fi
