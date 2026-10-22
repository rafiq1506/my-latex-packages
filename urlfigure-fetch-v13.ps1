
param(
    [Parameter(Mandatory=$true)][string]$Url,
    [Parameter(Mandatory=$true)][string]$Stem
)

$ErrorActionPreference = 'Stop'

if ($Stem -notmatch '^urlimage-[0-9]+$') {
    throw 'Invalid output stem.'
}

$cwd = (Get-Location).Path
$cacheDir = Join-Path $cwd 'urlfigure-images'
New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null

$status = Join-Path $cwd ($Stem + '.tex')
$metadata = Join-Path $cacheDir ($Stem + '.url')
$temporary = Join-Path $cacheDir ($Stem + '.download')

function Get-ImageExtension([string]$Path) {
    $bytes = [System.IO.File]::ReadAllBytes($Path)

    if ($bytes.Length -ge 3 -and
        $bytes[0] -eq 255 -and
        $bytes[1] -eq 216 -and
        $bytes[2] -eq 255) {
        return 'jpg'
    }

    if ($bytes.Length -ge 8 -and
        $bytes[0] -eq 137 -and
        $bytes[1] -eq 80 -and
        $bytes[2] -eq 78 -and
        $bytes[3] -eq 71 -and
        $bytes[4] -eq 13 -and
        $bytes[5] -eq 10 -and
        $bytes[6] -eq 26 -and
        $bytes[7] -eq 10) {
        return 'png'
    }

    if ($bytes.Length -ge 5 -and
        $bytes[0] -eq 37 -and
        $bytes[1] -eq 80 -and
        $bytes[2] -eq 68 -and
        $bytes[3] -eq 70 -and
        $bytes[4] -eq 45) {
        return 'pdf'
    }

    return $null
}

function Write-ImageStatus([string]$Filename) {
    $tex = '\gdef\urlfigimagefile{' + $Filename + '}'
    [System.IO.File]::WriteAllText(
        $status,
        $tex,
        [System.Text.Encoding]::ASCII
    )
}

try {
    Remove-Item -LiteralPath $status -Force `
        -ErrorAction SilentlyContinue

    # Reuse the image only if the source URL matches.
    if (Test-Path -LiteralPath $metadata) {
        $previousUrl = [System.IO.File]::ReadAllText($metadata)

        if ($previousUrl -ceq $Url) {
            foreach ($extension in @('jpg','png','pdf')) {
                $name = $Stem + '.' + $extension
                $path = Join-Path $cacheDir $name

                if (Test-Path -LiteralPath $path) {
                    if ((Get-ImageExtension $path) -eq $extension) {
                        Write-ImageStatus ('urlfigure-images/' + $name)
                        Write-Host ('Using cached image: ' + $name)
                        exit 0
                    }
                }
            }
        }
    }

    $candidates = @($Url)
    $id = $null

    if ($Url -match '^https://drive\.google\.com/file/d/([A-Za-z0-9_-]+)') {
        $id = $Matches[1]
    }
    elseif ($Url -match '^https://drive\.google\.com/(?:open|uc)\?') {
        $uri = [Uri]$Url
        foreach ($part in $uri.Query.TrimStart('?').Split('&')) {
            if ($part -match '^id=([A-Za-z0-9_-]+)$') {
                $id = $Matches[1]
                break
            }
        }
    }

    if ($id) {
        $candidates = @(
            'https://lh3.googleusercontent.com/d/' + $id
            'https://drive.usercontent.google.com/download?id=' +
                $id + '&export=download&confirm=t'
        )
    }

    $extension = $null
    $lastError = ''

    foreach ($candidate in $candidates) {
        try {
            Remove-Item -LiteralPath $temporary -Force `
                -ErrorAction SilentlyContinue

            Invoke-WebRequest -Uri $candidate `
                -OutFile $temporary `
                -UseBasicParsing `
                -MaximumRedirection 10 `
                -ErrorAction Stop

            $extension = Get-ImageExtension $temporary

            if ($extension) {
                break
            }

            $lastError = 'Unsupported image format or HTML response.'
        }
        catch {
            $lastError = $_.Exception.Message
        }
    }

    if (-not $extension) {
        throw ('Unable to download a supported image. ' + $lastError)
    }

    $filename = $Stem + '.' + $extension
    $destination = Join-Path $cacheDir $filename

    foreach ($oldExt in @('jpg','png','pdf')) {
        $oldPath = Join-Path $cacheDir ($Stem + '.' + $oldExt)
        Remove-Item -LiteralPath $oldPath -Force `
            -ErrorAction SilentlyContinue
    }

    Move-Item -LiteralPath $temporary `
        -Destination $destination -Force

    [System.IO.File]::WriteAllText($metadata, $Url)

    Write-ImageStatus ('urlfigure-images/' + $filename)

    Write-Host ('Downloaded: ' + $filename)
}
catch {
    Remove-Item -LiteralPath $status -Force `
        -ErrorAction SilentlyContinue

    Write-Error ('urlfigure: ' + $_.Exception.Message)
    exit 1
}
finally {
    Remove-Item -LiteralPath $temporary -Force `
        -ErrorAction SilentlyContinue
}
