# Dank Lyrics Desktop Widget

A real-time synced lyrics **desktop widget** for **DankMaterialShell**. It monitors any MPRIS-compatible music player (Firefox, Chrome, Spotify, etc.) and displays live lyrics fetched from [LRCLIB](https://lrclib.net/).

## Features

- **Real-time sync** — Highlights the current lyric line as the song plays
- **MPRIS native** — Works with any browser or app exposing MPRIS (YouTube Music, Spotify Web, local players)
- **Desktop widget** — Free-floating draggable and resizable widget on your desktop
- **Context lines** — Shows surrounding lyrics above and below the current line
- **LRCLIB powered** — Free, open synced-lyrics database; no API key needed
- **Session caching** — Fetched lyrics are cached in-memory per session
- **Edit mode support** — Right-click to drag, right-click corner to resize

## Installation

Place this folder into your DMS plugins directory:

```bash
cp -r dankLyrics ~/.config/DankMaterialShell/plugins/
```

Then reload DMS and enable the widget in:
- **Settings → Desktop Widgets → Browse Plugins**
- Toggle ON **Dank Lyrics**

The widget will appear on your desktop. Right-click to drag it anywhere, or right-click the bottom-right corner to resize.

## How It Works

1. Detects the active MPRIS player via `MprisController`
2. On track change, queries `lrclib.net/api/get` with track title + artist
3. Parses synced LRC format (`[mm:ss.xx] lyric line`)
4. Polls `player.position` every 200ms to highlight the active line
5. Renders a desktop card with the current line centered and context lines faded

## Requirements

- DankMaterialShell >= 1.4.0
- `curl` (used for LRCLIB API requests)
- An MPRIS-compatible music player

## Troubleshooting

- **Widget not appearing**: Make sure the plugin is enabled in Settings → Desktop Widgets
- **No lyrics found**: LRCLIB may not have the song. Try playing a more popular track.
- **Not detecting player**: Ensure your browser/app supports MPRIS (Firefox and Chromium do by default on Linux)

## License

MIT
