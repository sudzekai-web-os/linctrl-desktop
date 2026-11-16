param(
    [string]$Directory = "$env:USERPROFILE/Desktop/linctrl/desktop/win-x64"
)

$ErrorActionPreference = 'Stop'
$qt = 'C:/Apps/Qt/6.12.0/mingw_64'
$directory = (Resolve-Path -LiteralPath $Directory).Path
$application = Join-Path $directory 'applinctrl.exe'
$pluginDirectory = Join-Path $directory 'plugins'
$scanArguments = @('--qmldir', (Join-Path $PSScriptRoot 'qml'))

if (Test-Path -LiteralPath $pluginDirectory) {
    foreach ($plugin in Get-ChildItem -LiteralPath $pluginDirectory -Directory -Filter '*.linctrl') {
        $scanArguments += @('--qmldir', $plugin.FullName)
    }
}

$previousPath = $env:PATH
try {
    $env:PATH = "C:/Apps/Qt/Tools/mingw1310_64/bin;$qt/bin;$previousPath"
    & "$qt/bin/windeployqt.exe" --release @scanArguments $application
    if ($LASTEXITCODE -ne 0) { throw 'Qt deployment failed' }
} finally {
    $env:PATH = $previousPath
}
