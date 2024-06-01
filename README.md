# skippy-mpv 🦘

An [mpv](https://github.com/mpv-player/mpv) script to skip the unwanted portions of your media.

## Description

During audio or video playback, skippy-mpv looks for an .edl (edit decision list) file with the same name and location of your media file. If that EDL file exists, consists of (start timestamp, end timestamp, flag int) lines like

```
01:20:33.213 01:23:14.000 0
```

and the flag is 0, then the period between the two timestamps is skipped.

This partially replicates behavior seen in [Kodi](https://github.com/xbmc/xbmc).

## Installation

Place `skippy.lua` in your mpv installation's `scripts` folder, or launch mpv with `--scripts skippy.lua`.

## To do

- Implement creation of EDL files.
- Implement millisecond precision.
- Display the skips as Matroska chapters, if possible.
- Modify the reported runtime in mpv, if possible.
- Implement the commercial-skipping behavior from Kodi, i.e., skip upon natural encounter but allow rewinding.
- Optimization: rather than observe the time-pos property for the entire duration, register a timer that checks the time-pos and skips, and re-evaluate those timers upon file-load and seek events.

## License

Copyright 2024 Ryan Plant (ryan@ryanplant.net)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The Software is provided “as is”, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
