param(
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug'
)

$ErrorActionPreference = 'Stop'
$cmake = 'C:/Apps/Qt/Tools/CMake_64/bin/cmake.exe'
$preset = 'qt-mingw-' + $Configuration.ToLowerInvariant()
$previousPath = $env:PATH
$source = $PSScriptRoot

Push-Location $source
try {
    $env:PATH = "C:/Apps/Qt/Tools/mingw1310_64/bin;C:/Apps/Qt/6.12.0/mingw_64/bin;C:/Apps/Qt/Tools/Ninja;$previousPath"

    & $cmake --preset $preset -S $source
    if ($LASTEXITCODE -ne 0) { throw 'CMake configuration failed' }

    & $cmake --build --preset $preset
    if ($LASTEXITCODE -ne 0) { throw 'Build failed' }

    & "$source/build/windows-$($Configuration.ToLowerInvariant())/applinctrl.exe"
    if ($LASTEXITCODE -ne 0) { throw "Application exited with code $LASTEXITCODE" }
} finally {
    $env:PATH = $previousPath
    Pop-Location
}
