# Public GitHub repository containing packages named <package>.sty at its root.
$script:LatexPackageBaseUrl = 'https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main'

function global:latex-install {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9_-]*$')]
        [string]$Name,
        [switch]$Force,
        [switch]$Verify
    )

    $kpse = Get-Command kpsewhich -ErrorAction SilentlyContinue
    if (-not $kpse) { throw 'TeX Live kpsewhich was not found on PATH.' }

    if ($Verify) {
        $found = & kpsewhich "$Name.sty" 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace([string]$found)) {
            Write-Host "Found: $found" -ForegroundColor Green
        } else {
            Write-Warning "$Name.sty was not found by TeX Live."
        }
        return
    }

    $texmfOutput = & kpsewhich -var-value=TEXMFHOME
    if ($LASTEXITCODE -ne 0 -or -not $texmfOutput) { throw 'Could not determine TEXMFHOME.' }
    $texmf = ([string]($texmfOutput | Select-Object -First 1)).Trim()
    if ([string]::IsNullOrWhiteSpace($texmf)) { throw 'TEXMFHOME is empty.' }

    $destination = Join-Path $texmf "tex\latex\$Name"
    $target = Join-Path $destination "$Name.sty"
    if ((Test-Path -LiteralPath $target) -and -not $Force) {
        Write-Host "Already installed: $target (use -Force to update)" -ForegroundColor Yellow
        return
    }

    $url = "$($script:LatexPackageBaseUrl.TrimEnd('/'))/$Name.sty"
    $temp = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.sty')
    try {
        Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing -ErrorAction Stop
        $content = [string](Get-Content -LiteralPath $temp -Raw -ErrorAction Stop)
        $declaration = "\ProvidesPackage{$Name}"
        if (-not $content.Contains($declaration)) {
            throw "Downloaded file does not contain $declaration. Check the repository URL and package contents."
        }
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        Copy-Item -LiteralPath $temp -Destination $target -Force -ErrorAction Stop
        Write-Host "Installed: $target" -ForegroundColor Green
        Write-Host "Verify with: latex-install $Name -Verify"
    }
    finally {
        Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
    }
}
