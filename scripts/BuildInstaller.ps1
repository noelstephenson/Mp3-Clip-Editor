param(
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$publishDir = Join-Path $repoRoot "dist\publish"
$outputDir = Join-Path $repoRoot "dist\installer"
$issPath = Join-Path $repoRoot "installer\Mp3ClipEditor.iss"
$isccFromPath = $null
try {
    $isccFromPath = (Get-Command iscc -ErrorAction Stop).Source
}
catch {
}

$isccCandidates = @(
    $isccFromPath,
    "C:\Users\Noel\AppData\Local\Programs\Inno Setup 6\ISCC.exe",
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe"
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and (Test-Path $_) }

if (-not (Test-Path $publishDir)) {
    throw "Publish directory not found at $publishDir. Run dotnet publish first."
}

if (-not (Test-Path $issPath)) {
    throw "Inno Setup script not found at $issPath."
}

if ($isccCandidates.Count -eq 0) {
    throw "ISCC.exe was not found. Install Inno Setup or add ISCC to PATH."
}

$isccPath = [string]($isccCandidates | Select-Object -First 1)

Remove-Item -Recurse -Force $outputDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$arguments = @(
    "/DMyAppVersion=$Version",
    "/DPublishDir=$publishDir",
    "/DOutputDir=$outputDir",
    "/DRepoRoot=$repoRoot",
    $issPath
)

& $isccPath @arguments
if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup failed with exit code $LASTEXITCODE."
}

$installerPath = Join-Path $outputDir "Mp3ClipEditor-Setup-$Version.exe"
if (-not (Test-Path $installerPath)) {
    throw "Installer was not created."
}

Write-Output $installerPath
