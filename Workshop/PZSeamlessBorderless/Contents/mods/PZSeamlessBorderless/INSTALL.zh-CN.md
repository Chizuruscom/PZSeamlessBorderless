# PZ 无黑屏切屏辅助启动器

订阅本作品后，在 Steam 设置一次启动选项。以后照常使用 Steam 库的“开始游戏”或原来的 Steam 桌面快捷方式。

## 找到下载的文件

1. 等 Steam 完成创意工坊下载。
2. Steam 库 → 右键 Project Zomboid → 管理 → 浏览本地文件。
3. 资源管理器此时位于 `steamapps\common\ProjectZomboid`。向上两级，回到 `steamapps`。
4. 进入 `workshop\content\108600\本作品数字ID\mods\PZSeamlessBorderless`。
5. 右键 **PZ-Steam.ps1** → **复制文件地址 / 复制为路径**。旧版 Windows 可以按住 Shift 再右键。

“本作品数字ID”是创意工坊页面网址中 `?id=` 后的数字。未发布的本地开发包没有作品 ID。如果此 Steam 库没有 workshop 文件夹，检查 Steam“设置 → 存储空间”中的其他库，在对应库的 steamapps/workshop/content/108600 下寻找。

## 设置启动选项

Steam 库 → 右键 Project Zomboid → 属性 → 通用 → 启动选项。填写：

```text
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "PZ-Steam.ps1的完整路径" %command%
```

将右键复制的路径放在 `-File` 后面，路径两侧只保留一对英文双引号，最后保留一个空格和 `%command%`。

例如：

```text
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "D:\SteamLibrary\steamapps\workshop\content\108600\作品ID\mods\PZSeamlessBorderless\PZ-Steam.ps1" %command%
```

游戏显示设置选择“无边框窗口”，分辨率与桌面一致。Steam 弹出启动选择时选正常的 64 位启动。运行之后可以连续 Alt+Tab 测试。游戏 mod 列表中的本作品只是说明入口，是否勾选不影响启动器。

已有 `-debug` 等游戏参数时，放在 `%command%` 后面。已有其他包裹 `%command%` 的启动器时，需要先决定组合顺序，不能直接拼接两条完整命令。

## 工作方式

脚本运行 Steam 提供的原始游戏程序，等待这个进程的无边框窗口出现，将窗口四边各扩出 1 像素。窗口调整只进行一次，此后启动器空闲等待游戏退出，使 Steam 启动的父进程保持存活。游戏退出后启动器也退出。

脚本只修改本次游戏窗口，并在 `%LOCALAPPDATA%\PZSeamlessBorderless\launcher.log` 写入诊断结果。它不修改注册表、游戏程序、游戏配置、存档或账号信息；它不会自动填写 Steam 启动选项。

日志出现 `Applied:` 表示已读回并确认窗口位置。`Skipped:` 表示没有找到符合条件的无边框窗口，游戏继续正常运行。脚本与 `PZWindow.cs` 需要保存在同一目录。

## 卸载

先从 Steam 启动选项中移除本启动器命令，保留自己原有的游戏参数，然后取消订阅。关闭游戏即可撤销窗口调整。

## 限制

- 支持 Windows 64 位、正常的 `ProjectZomboid64.exe` 启动方式。备用 `.bat` 启动、Linux、macOS、独立服务器未支持。
- 本机 42.20.4、3840×2160、NVIDIA 显卡已验证消除 Alt+Tab 黑屏；其他硬件需自行验证。
- 这是窗口尺寸绕行方案。客户区比初始渲染尺寸大 2 像素，其他配置可能出现边缘像素、鼠标或 UI 对齐差异。
- 启动三分钟内等待符合条件的窗口；游戏内再次切换显示模式后，请重新启动游戏。
- 直接运行游戏 exe 的快捷方式会绕过 Steam 启动选项。原来的 Steam 游戏快捷方式（steam://rungameid/108600）会使用它。
- 此发行包仅完成本地校验与测试；创意工坊远端接收和订阅下载流程需在实际上传后验证。

相关先行项目：[True Borderless](https://github.com/watskybelfort/pz-true-borderless)。本工具独立编写，未复制该项目的源码或图片。
