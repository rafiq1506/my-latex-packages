
$script:LatexPackageBaseUrl = 'https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main'

function global:latex-install {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9_-]*$')]
        [string]$Name,
        [switch]$Force,
        [switch]$Verify
    )

    $kpse = Get-Command kpsewhich -ErrorAction SilentlyContinue
    if (-not $kpse) {
        throw 'TeX Live kpsewhich was not found on PATH.'
    }

    if ($Verify) {
        $found = & kpsewhich "$Name.sty" 2>$null

        if ($found) {
            Write-Host "Found: $found" -ForegroundColor Green
        }
        else {
            Write-Warning "$Name.sty not found."
        }

        if ($Name -eq 'urlfigure') {
            $helper = & kpsewhich -format=tex urlfigure-fetch-v13.ps1
            if ($helper) {
                Write-Host "Helper: $helper" -ForegroundColor Green
            }
            else {
                Write-Warning 'urlfigure helper not found.'
            }
        }
        return
    }

    $texmf = (& kpsewhich -var-value=TEXMFHOME |
        Select-Object -First 1).Trim()

    if (-not $texmf) {
        throw 'Cannot determine TEXMFHOME.'
    }

    $destination = Join-Path $texmf "tex\latex\$Name"
    $target = Join-Path $destination "$Name.sty"

    if ((Test-Path $target) -and -not $Force) {
        Write-Host "Already installed. Use -Force to update."
        return
    }

    $files = @("$Name.sty")

    if ($Name -eq 'urlfigure') {
        $files += 'urlfigure-fetch-v13.ps1'
    }

    $staging = Join-Path ([IO.Path]::GetTempPath()) (
        'latex-install-' + [Guid]::NewGuid().ToString('N')
    )

    New-Item -ItemType Directory -Path $staging -Force |
        Out-Null

    try {
        foreach ($file in $files) {
            $url = "$($script:LatexPackageBaseUrl)/$file"
            $tempFile = Join-Path $staging $file

            Invoke-WebRequest -Uri $url `
                -OutFile $tempFile `
                -UseBasicParsing `
                -ErrorAction Stop
        }

        $sty = Get-Content `
            -LiteralPath (Join-Path $staging "$Name.sty") `
            -Raw

        if (-not $sty.Contains("\ProvidesPackage{$Name}")) {
            throw 'Invalid LaTeX package declaration.'
        }

        New-Item -ItemType Directory `
            -Path $destination -Force | Out-Null

        foreach ($file in $files) {
            Copy-Item -LiteralPath (Join-Path $staging $file) `
                -Destination (Join-Path $destination $file) `
                -Force
        }

        Write-Host "Installed: $Name" -ForegroundColor Green
        Write-Host "Location: $destination"
    }
    finally {
        Remove-Item -LiteralPath $staging `
            -Recurse -Force -ErrorAction SilentlyContinue
    }
}
