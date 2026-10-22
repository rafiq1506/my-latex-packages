# One-time setup for the latex-install PowerShell command (Windows PowerShell 5.1+).
$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'latex-install.ps1'
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw 'Place latex-install.ps1 in the same folder as setup-latex-install.ps1.'
}

# Install the command script in a persistent location, not the extracted ZIP folder.
$installDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\LatexInstaller'
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
$installedScript = Join-Path $installDir 'latex-install.ps1'
Copy-Item -LiteralPath $source -Destination $installedScript -Force

# Use the profile for the currently running PowerShell host.
$profilePath = [string]$PROFILE.CurrentUserCurrentHost
if ([string]::IsNullOrWhiteSpace($profilePath)) { throw 'Cannot determine the PowerShell profile path.' }
New-Item -ItemType Directory -Path (Split-Path -Parent $profilePath) -Force | Out-Null
if (-not (Test-Path -LiteralPath $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# Remove the installer entry from earlier versions, then add exactly one current entry.
$profileContent = [string](Get-Content -LiteralPath $profilePath -Raw -ErrorAction Stop)
$profileLine = ". '$($installedScript.Replace("'", "''"))'"
if (-not ([string]$profileContent).Contains($profileLine)) {
    Add-Content -LiteralPath $profilePath -Value "`r`n# Custom LaTeX package installer`r`n$profileLine" -ErrorAction Stop
}

# Make the command available immediately in this setup process.
. $installedScript
Write-Host 'Setup completed successfully.' -ForegroundColor Green
Write-Host "Profile: $profilePath"
Write-Host "Installer: $installedScript"
Write-Host 'Open a NEW PowerShell window, then run: latex-install urlfigure'
Write-Host 'To verify: latex-install urlfigure -Verify'

