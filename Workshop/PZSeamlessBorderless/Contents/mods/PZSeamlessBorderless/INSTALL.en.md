# PZ Seamless Borderless

Subscribe, wait for the download, and configure Steam launch options once. Then use the usual Steam Play button or Steam desktop shortcut.

## Locate the files

Steam Library > right-click Project Zomboid > Manage > Browse Local Files.
Go up twice from `steamapps/common/ProjectZomboid` to `steamapps`, then open:

`workshop/content/108600/THIS_ITEM_ID/mods/PZSeamlessBorderless`

THIS_ITEM_ID is the number after `?id=` in this Workshop item's URL. If Workshop content is stored in another Steam library, use that library's steamapps folder. Right-click `PZ-Steam.ps1` and choose Copy as path (Shift + right-click on older Windows versions).

## Steam launch options

Library > Project Zomboid > Properties > General > Launch Options:

```text
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "FULL_PATH_TO_PZ-Steam.ps1" %command%
```

Keep exactly one pair of quotes around the path, and keep the trailing `%command%`. Keep existing game arguments such as `-debug` after `%command%`. Use normal 64-bit launch, Borderless Windowed, and desktop resolution. Enabling the metadata-only mod entry is optional.

The script starts the exact game command supplied by Steam, adjusts that process's window once, and waits idle until the game exits. No recursive Steam launch URI is used. It changes the current window and writes `%LOCALAPPDATA%/PZSeamlessBorderless/launcher.log`; it does not edit the registry, game files, options.ini, saves, or Steam settings. `Applied:` in the log confirms the resulting rectangle. `Skipped:` means no eligible window was found and the game continued unchanged.

## Uninstall

Remove this wrapper from Steam launch options before unsubscribing; retain your own game arguments. Close the game to remove the temporary window adjustment.

## Limitations

Windows 64-bit / normal ProjectZomboid64.exe launch only. The alternate batch launcher and standalone servers are unsupported. Tested on one 4K NVIDIA system with PZ 42.20.4. The two-pixel client-size difference may affect edge pixels or UI alignment on other systems. Changing display modes after startup requires restarting the game. Direct executable shortcuts bypass Steam launch options. Other launch wrappers need a deliberately tested combination. Remote Workshop upload/subscription validation remains pending.

Related prior work: https://github.com/watskybelfort/pz-true-borderless . This helper was independently implemented and includes no source code or artwork from that project.
