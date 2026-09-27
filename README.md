#### Windows / Build 42 version. Fixed the black screen issue when switching with Alt+Tab. After subscribing, you need to configure the Steam launch options once; enabling only the mod without setting the launch options will not work. The settings will automatically revert after exiting the game.

#### Windows / Build 42 版本。修复了使用 Alt+Tab 切换时出现的黑屏问题。订阅后需要进行一次性的 Steam 启动选项设置；仅启用模组（Mod）而不设置启动项时无效。退出游戏后设置会自动恢复

---

## Setup:
1. In game, select Borderless Window and your desktop resolution.
2. Steam Library → Project Zomboid → Right-click → Manage / Browse Local Files → Go up two levels to `steamapps` → `workshop/content/108600/3808982224/mods/PZSeamlessBorderless` → Right-click `PZ-Steam.ps1` Copy file address.
2. Steam Library → Project Zomboid → Set the launch options to the following:
```
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "Paste the address copied in Step 2 here (do not remove the quotation marks on both sides)" %command%
```

## 安装：
1. 游戏内选择无边框窗口、桌面分辨率，退出游戏
2. Steam 库 → Project Zomboid → 右键管理/浏览本地文件 → 向上退两级到 steamapps → 进入 workshop/content/108600/3808982224/mods/PZSeamlessBorderless → 右键 PZ-Steam.ps1 复制文件地址。
2. Steam 库 → project zombiod → 启动项设置为以下内容：
```
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "此处粘贴步骤2复制的地址（不要去掉两侧引号）" %command%
```

---

## Uninstallation:
1. Unsubscribe.
2. Clear the Project Zomboid launch options.

## 卸载：
1. 取消订阅
2. 清除project zombiod启动项

Workshop ID: 3808982224
Mod ID: PZSeamlessBorderless
