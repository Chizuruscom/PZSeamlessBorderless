$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$mod = Join-Path $root 'Workshop\PZSeamlessBorderless\Contents\mods\PZSeamlessBorderless'
Add-Type -Path (Join-Path $mod 'PZWindow.cs')
$fixture = Join-Path $PSScriptRoot ('fixture ' + [char]0x6D4B + [char]0x8BD5 + ' & spaces')
[void][IO.Directory]::CreateDirectory($fixture)
$stub = Join-Path $fixture 'ProjectZomboid64.exe'
if (-not (Test-Path -LiteralPath $stub)) {
    Add-Type -Path (Join-Path $PSScriptRoot 'GameStub.cs') -OutputAssembly $stub -OutputType ConsoleApplication
}
$expected = @('-debug', '-cachedir=C:\cache path\', 'x&y', 'literal$(text)', 'embedded"quote', '', 'two words')
$arguments = @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $mod 'PZ-Steam.ps1'),$stub) + $expected
$start = New-Object Diagnostics.ProcessStartInfo
$start.FileName = 'powershell.exe'
$start.Arguments = (@($arguments | ForEach-Object { [PZSeamlessWindow]::QuoteArgument($_) })) -join ' '
$start.UseShellExecute = $false
$start.CreateNoWindow = $true
$start.RedirectStandardOutput = $true
$start.RedirectStandardError = $true
$start.EnvironmentVariables['PZ_LAUNCHER_TEST'] = 'inherited'
$process = [Diagnostics.Process]::Start($start)
$output = $process.StandardOutput.ReadToEnd()
$errors = $process.StandardError.ReadToEnd()
$process.WaitForExit()
if ($process.ExitCode -ne 7 -or $errors) { throw "Wrong exit/error: $($process.ExitCode) $errors" }
$actual = @($output -split '\r?\n' | Where-Object { $_.StartsWith('ARG:') } | ForEach-Object { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_.Substring(4))) })
if ($actual.Count -ne $expected.Count) { throw "Argument count changed: $($actual.Count) / $($expected.Count)" }
for ($i=0; $i -lt $expected.Count; $i++) {
    if ($actual[$i] -cne $expected[$i]) { throw "Argument $i changed: [$($actual[$i])]" }
}
$cwdLine = @($output -split '\r?\n' | Where-Object { $_.StartsWith('CWD:') })[0]
$cwd = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($cwdLine.Substring(4)))
if ($cwd -ne $fixture -or $output -notmatch 'ENV:inherited') { throw 'Working directory or environment was not preserved.' }
Write-Output 'PASS: game arguments, Unicode/spaces/ampersand path, working directory, inherited environment, exit code.'
