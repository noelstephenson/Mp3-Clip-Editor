param(
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$publishDir = Join-Path $repoRoot "dist\publish"
$outputDir = Join-Path $repoRoot "dist\installer"
$stageDir = Join-Path $outputDir "stage"
$zipPath = Join-Path $stageDir "app.zip"
$installScriptSource = Join-Path $repoRoot "installer\InstallApp.ps1"
$installScriptStage = Join-Path $stageDir "InstallApp.ps1"
$installerPath = Join-Path $outputDir "Mp3ClipEditor-Setup-$Version.exe"
$sedPath = Join-Path $outputDir "installer.sed"

if (-not (Test-Path $publishDir)) {
    throw "Publish directory not found at $publishDir. Run dotnet publish first."
}

if (-not (Test-Path $installScriptSource)) {
    throw "Installer script not found at $installScriptSource."
}

Remove-Item -Recurse -Force $outputDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $stageDir | Out-Null

Copy-Item $installScriptSource $installScriptStage -Force
Compress-Archive -Path (Join-Path $publishDir "*") -DestinationPath $zipPath -CompressionLevel Optimal

$sed = @"
[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=
DisplayLicense=
FinishMessage=MP3 Clip Editor has been installed.
TargetName=$installerPath
FriendlyName=MP3 Clip Editor Setup
AppLaunched=powershell.exe -ExecutionPolicy Bypass -NoProfile -File InstallApp.ps1
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
SourceFiles=SourceFiles
[Strings]
FILE0=InstallApp.ps1
FILE1=app.zip
[SourceFiles]
SourceFiles0=$stageDir\
[SourceFiles0]
%FILE0%=
%FILE1%=
"@

Set-Content -Path $sedPath -Value $sed -Encoding ASCII

$process = Start-Process -FilePath "iexpress.exe" -ArgumentList "/N", $sedPath -Wait -PassThru -WindowStyle Hidden
if ($process.ExitCode -ne 0) {
    throw "IExpress failed with exit code $($process.ExitCode)."
}

if (-not (Test-Path $installerPath)) {
    throw "Installer was not created."
}

Write-Output $installerPath
