param(
    [string]$InstallRoot = "$env:LOCALAPPDATA\Programs\MP3 Clip Editor"
)

$ErrorActionPreference = "Stop"

$sourceRoot = $PSScriptRoot
$zipPath = Join-Path $sourceRoot "app.zip"
$appFolder = Join-Path $InstallRoot "app"
$exePath = Join-Path $appFolder "Mp3ClipEditorTagger.exe"
$startMenuFolder = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\MP3 Clip Editor"
$desktopShortcutPath = Join-Path ([Environment]::GetFolderPath("Desktop")) "MP3 Clip Editor.lnk"
$startMenuShortcutPath = Join-Path $startMenuFolder "MP3 Clip Editor.lnk"

if (-not (Test-Path $zipPath)) {
    throw "Installer payload app.zip was not found."
}

New-Item -ItemType Directory -Force -Path $appFolder | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $appFolder -Force

if (-not (Test-Path $exePath)) {
    throw "Installed application executable was not created."
}

New-Item -ItemType Directory -Force -Path $startMenuFolder | Out-Null

$shell = New-Object -ComObject WScript.Shell

$desktopShortcut = $shell.CreateShortcut($desktopShortcutPath)
$desktopShortcut.TargetPath = $exePath
$desktopShortcut.WorkingDirectory = $appFolder
$desktopShortcut.IconLocation = "$exePath,0"
$desktopShortcut.Save()

$startMenuShortcut = $shell.CreateShortcut($startMenuShortcutPath)
$startMenuShortcut.TargetPath = $exePath
$startMenuShortcut.WorkingDirectory = $appFolder
$startMenuShortcut.IconLocation = "$exePath,0"
$startMenuShortcut.Save()

Start-Process -FilePath $exePath
