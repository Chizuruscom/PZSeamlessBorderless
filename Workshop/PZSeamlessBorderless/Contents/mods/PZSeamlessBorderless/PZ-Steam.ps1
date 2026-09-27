# Steam launch options:
# "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "FULL_PATH\PZ-Steam.ps1" %command%
# No param block: preserve dash-prefixed game arguments as data in $args.
$ErrorActionPreference = 'Stop'
$logDirectory = Join-Path $env:LOCALAPPDATA 'PZSeamlessBorderless'
[void][IO.Directory]::CreateDirectory($logDirectory)
$logPath = Join-Path $logDirectory 'launcher.log'
[IO.File]::WriteAllText($logPath, "PZ Seamless Borderless 0.2.0`r`n")
function Write-LauncherLog([string] $Message) {
    [IO.File]::AppendAllText($logPath, ('{0:O} {1}' -f (Get-Date), $Message) + "`r`n")
}

try {
    if ($args.Count -eq 0) { throw 'Missing Steam game command. Add %command% after the script path in Steam launch options.' }
    $executable = [IO.Path]::GetFullPath([string]$args[0])
    if ([IO.Path]::GetFileName($executable) -ine 'ProjectZomboid64.exe' -or -not [IO.File]::Exists($executable)) {
        throw 'Use the normal 64-bit Project Zomboid launch option. The alternate .bat launcher is not supported.'
    }
    $gameArguments = @($args | Select-Object -Skip 1)
    Add-Type -Path (Join-Path $PSScriptRoot 'PZWindow.cs')
    [PZSeamlessWindow]::Initialize()
    $quoted = @($gameArguments | ForEach-Object { [PZSeamlessWindow]::QuoteArgument([string]$_) })
    $start = New-Object Diagnostics.ProcessStartInfo
    $start.FileName = $executable
    $start.WorkingDirectory = [IO.Path]::GetDirectoryName($executable)
    $start.UseShellExecute = $false
    $start.Arguments = $quoted -join ' '
    $game = [Diagnostics.Process]::Start($start)
    Write-LauncherLog "Game started; pid=$($game.Id)."
} catch {
    Write-LauncherLog $_.Exception.Message
    Add-Type -AssemblyName System.Windows.Forms
    [void][Windows.Forms.MessageBox]::Show($_.Exception.Message, 'PZ Seamless Borderless')
    exit 1
}

try {
    $cacheDirectory = Join-Path $env:USERPROFILE 'Zomboid'
    foreach ($argument in $gameArguments) {
        if ($argument -like '-cachedir=*') { $cacheDirectory = $argument.Substring(10) }
    }
    $optionsPath = Join-Path $cacheDirectory 'options.ini'
    $deadline = (Get-Date).AddMinutes(3)
    $applied = $false
    while (-not $game.HasExited -and (Get-Date) -lt $deadline) {
        $game.Refresh()
        $window = $game.MainWindowHandle
        if ($window -ne [IntPtr]::Zero -and -not [PZSeamlessWindow]::IsIconic($window)) {
            $state = [PZSeamlessWindow]::Read($window)
            $options = if (Test-Path -LiteralPath $optionsPath) { Get-Content -LiteralPath $optionsPath } else { @() }
            $configured = ($options -contains 'borderless=true') -and ($options -contains 'fullScreen=false')
            if ($configured -and ($state.Applied -or $state.FitsScreen)) {
                Write-LauncherLog "Before: $state"
                if (-not $state.Applied) { [PZSeamlessWindow]::Place($window, $state, 1) }
                $after = [PZSeamlessWindow]::Read($window)
                if (-not $after.Applied) { throw 'Windows did not retain the requested window rectangle.' }
                Write-LauncherLog "Applied: $after"
                $applied = $true
                break
            }
        }
        Start-Sleep -Milliseconds 500
    }
    if (-not $applied -and -not $game.HasExited) {
        Write-LauncherLog 'Skipped: select Borderless Windowed at desktop resolution, then restart the game.'
    }
} catch {
    Write-LauncherLog "Window adjustment failed: $($_.Exception.Message)"
}

# Keep Steam's launched process alive until the actual game closes.
# After the one-time adjustment this is an idle wait, not a window watcher.
$game.WaitForExit()
Write-LauncherLog "Game exited; code=$($game.ExitCode)."
exit $game.ExitCode
