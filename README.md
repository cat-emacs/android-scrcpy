# android-scrcpy

Standalone scrcpy Transient interface for Emacs 28.1+. Requires Transient 0.3.0,
android-adb 0.1.0, and installed scrcpy/adb executables. No Android project or
android-mode is required.

## Installation

```elisp
(use-package android-adb
  :vc (:url "https://github.com/cat-emacs/android-adb"))
(use-package android-scrcpy
  :vc (:url "https://github.com/cat-emacs/android-scrcpy")
  :commands (android-scrcpy android-scrcpy-start))
```

Run `M-x android-scrcpy` to select a device and configure video, window, input,
audio, and recording options. RET starts scrcpy. The menu also stops/restarts
sessions, shows output, copies commands, and inspects displays/encoders/cameras.
Multiple devices can have independent sessions.

Set `android-scrcpy-program` for an explicit scrcpy executable and
`android-scrcpy-extra-arguments` for options absent from the menu. Device
completion uses android-adb. Scrcpy subprocesses receive the same adb executable
through their ADB environment variable without changing Emacs's environment.
All existing `android-scrcpy-*` command and option names are preserved.

## Development

Run `make install-deps`, then `make lint build test`. For a sibling local
checkout, pass `ANDROID_ADB_DIR=/path/to/android-adb`.
Licensed under GPL-3.0-or-later. Extracted from cat-emacs/android-mode.
