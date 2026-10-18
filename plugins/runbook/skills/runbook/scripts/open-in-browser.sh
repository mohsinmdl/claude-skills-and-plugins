#!/usr/bin/env bash
# Open a runbook .md in the user's DEFAULT BROWSER (not the default app for .md,
# which is usually an editor). The default browser is whatever handles https —
# a browser picker like Velja then routes it to the right browser/profile.
# Usage: open-in-browser.sh <file.md>   — prints the file:// URL it opened.
set -u
file=${1:?usage: open-in-browser.sh <file.md>}
url=$(python3 -c 'import pathlib,sys; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "$file") || exit 1

if [ "$(uname)" = "Darwin" ]; then
  # Bundle id of the https handler, from LaunchServices.
  bid=$(plutil -convert json -o - "$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist" 2>/dev/null |
    python3 -c 'import json,sys
for h in json.load(sys.stdin).get("LSHandlers", []):
    if h.get("LSHandlerURLScheme") == "https":
        print(h.get("LSHandlerRoleAll", "")); break' 2>/dev/null)
  if [ -n "$bid" ] && open -b "$bid" "$url" 2>/dev/null; then echo "$url"; exit 0; fi
  # No https handler recorded (Safari is the system default then).
  open -a Safari "$url" && { echo "$url"; exit 0; }
elif command -v xdg-settings >/dev/null 2>&1; then
  desktop=$(xdg-settings get default-web-browser 2>/dev/null)
  if [ -n "$desktop" ] && command -v gtk-launch >/dev/null 2>&1 && gtk-launch "$desktop" "$url" >/dev/null 2>&1; then echo "$url"; exit 0; fi
fi
echo "Could not open a browser; open this yourself: $url" >&2
exit 1
