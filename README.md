#### Windows / Build 42 version. Fixed the black screen issue when switching with Alt+Tab. Download the ZIP from Releases and extract it into the game folder, then configure the Steam launch options once. Extracting the files alone will not enable the fix. The window adjustment ends when the game exits; your Steam launch options remain configured.

#### Windows / Build 42 版本。修复了使用 Alt+Tab 切换时出现的黑屏问题。从 Releases 下载 ZIP 并解压至游戏文件夹后，需要进行一次性的 Steam 启动选项设置；仅解压文件而不设置启动项时无效。退出游戏后窗口调整自动结束，Steam 启动项会保留

---

## Setup:

1. In game, select Borderless Window and your desktop resolution, then exit the game.
2. Download `PZ-Seamless-Borderless-0.2.0.zip` from [Releases](https://github.com/Chizuruscom/PZSeamlessBorderless/releases/latest), not the automatically generated Source code archive.
3. Steam Library → Project Zomboid → Right-click → Manage / Browse Local Files. Extract the ZIP here, so `PZSeamlessBorderless` is next to `ProjectZomboid64.exe`.
4. Open `PZSeamlessBorderless`, right-click `PZ-Steam.ps1` and select Copy as path.
5. Steam Library → Project Zomboid → Properties → General → Set the launch options to the following. Keep exactly one pair of quotation marks around the script path; Copy as path already includes them.

```
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "Paste the full path copied in Step 4 here" %command%
```

## 安装：

1. 游戏内选择无边框窗口、桌面分辨率，退出游戏
2. 从 [Releases](https://github.com/Chizuruscom/PZSeamlessBorderless/releases/latest) 下载 `PZ-Seamless-Borderless-0.2.0.zip`，不要下载自动生成的 Source code 源码压缩包。
3. Steam 库 → Project Zomboid → 右键管理/浏览本地文件，将 ZIP 解压到这里，使 `PZSeamlessBorderless` 文件夹与 `ProjectZomboid64.exe` 位于同一级。
4. 进入 `PZSeamlessBorderless` 文件夹，右键 `PZ-Steam.ps1` → 复制文件地址。
5. Steam 库 → Project Zomboid → 属性 → 通用 → 启动项设置为以下内容。脚本路径两侧只保留一对引号；“复制文件地址”已包含引号，不要重复添加。

```
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "此处粘贴步骤4复制的完整路径" %command%
```

---

## Uninstallation:

1. Exit the game and remove this helper's command from the Project Zomboid launch options.
2. Delete the `PZSeamlessBorderless` folder from the game folder.

## 卸载：

1. 退出游戏，并从 Project Zomboid 启动项中移除本工具的启动命令。
2. 删除游戏目录中的 `PZSeamlessBorderless` 文件夹。

## Mod ID

The GitHub Release does not require a Workshop subscription or enabling a mod in game. / GitHub Release 版本无需订阅创意工坊，也无需在游戏内启用 Mod。

Workshop ID: 3808982224  
Mod ID: PZSeamlessBorderless
