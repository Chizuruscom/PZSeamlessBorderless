$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$item = Join-Path $root 'Workshop\PZSeamlessBorderless'
Add-Type -AssemblyName System.Drawing
$bitmap = New-Object Drawing.Bitmap(256,256)
$g = [Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([Drawing.ColorTranslator]::FromHtml('#152329'))
$pen = New-Object Drawing.Pen([Drawing.ColorTranslator]::FromHtml('#83d5be'),5)
$brush = New-Object Drawing.SolidBrush([Drawing.ColorTranslator]::FromHtml('#e6f3ed'))
$font = New-Object Drawing.Font('Segoe UI',25,[Drawing.FontStyle]::Bold)
$small = New-Object Drawing.Font('Segoe UI',12)
$g.DrawRectangle($pen,30,35,196,127)
$g.DrawLine($pen,98,179,158,179)
$g.DrawString('ALT + TAB',$font,$brush,27,76)
$g.DrawString('SEAMLESS BORDERLESS',$small,$brush,25,204)
$bitmap.Save((Join-Path $item 'preview.png'),[Drawing.Imaging.ImageFormat]::Png)
Copy-Item -LiteralPath (Join-Path $item 'preview.png') -Destination (Join-Path $item 'Contents\mods\PZSeamlessBorderless\42\poster.png')
$g.Dispose(); $bitmap.Dispose(); $pen.Dispose(); $brush.Dispose(); $font.Dispose(); $small.Dispose()
$output = Join-Path $root 'PZ-Seamless-Borderless-Workshop-0.2.0.zip'
Compress-Archive -LiteralPath $item -DestinationPath $output -Force
Write-Output $output

# Standalone Release: extract this folder alongside ProjectZomboid64.exe.
$releaseFolder = Join-Path $root 'dist\PZSeamlessBorderless'
[void][IO.Directory]::CreateDirectory($releaseFolder)
$mod = Join-Path $item 'Contents\mods\PZSeamlessBorderless'
Copy-Item -LiteralPath (Join-Path $mod 'PZ-Steam.ps1'), (Join-Path $mod 'PZWindow.cs'), (Join-Path $root 'README.md') -Destination $releaseFolder -Force
$releaseZip = Join-Path $root 'dist\PZ-Seamless-Borderless-0.2.0.zip'
Compress-Archive -LiteralPath $releaseFolder -DestinationPath $releaseZip -Force
Write-Output $releaseZip
