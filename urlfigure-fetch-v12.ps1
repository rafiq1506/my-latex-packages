param(
    [Parameter(Mandatory=$true)][string]$Url,
    [Parameter(Mandatory=$true)][string]$Stem
)
$ErrorActionPreference = 'Stop'
if ($Stem -notmatch '^urlimage-[0-9]+$') { throw 'Invalid output stem.' }
$cwd = (Get-Location).Path
$status = Join-Path $cwd ($Stem + '.tex')
$temporary = Join-Path $cwd ($Stem + '.download')
Remove-Item -LiteralPath $status,$temporary -Force -ErrorAction SilentlyContinue
foreach ($ext in @('jpg','png','pdf')) {
    Remove-Item -LiteralPath (Join-Path $cwd ($Stem + '.' + $ext)) -Force -ErrorAction SilentlyContinue
}
function Get-ImageExtension([string]$Path) {
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 255 -and $bytes[1] -eq 216 -and $bytes[2] -eq 255) { return 'jpg' }
    if ($bytes.Length -ge 8 -and $bytes[0] -eq 137 -and $bytes[1] -eq 80 -and $bytes[2] -eq 78 -and $bytes[3] -eq 71 -and $bytes[4] -eq 13 -and $bytes[5] -eq 10 -and $bytes[6] -eq 26 -and $bytes[7] -eq 10) { return 'png' }
    if ($bytes.Length -ge 5 -and $bytes[0] -eq 37 -and $bytes[1] -eq 80 -and $bytes[2] -eq 68 -and $bytes[3] -eq 70 -and $bytes[4] -eq 45) { return 'pdf' }
    return $null
}
try {
    $candidates = @($Url)
    $id = $null
    if ($Url -match '^https://drive\.google\.com/file/d/([A-Za-z0-9_-]+)') {
        $id = $Matches[1]
    } elseif ($Url -match '^https://drive\.google\.com/(?:open|uc)\?') {
        $uri = [Uri]$Url
        foreach ($part in $uri.Query.TrimStart('?').Split('&')) {
            if ($part -match '^id=([A-Za-z0-9_-]+)$') { $id = $Matches[1]; break }
        }
    }
    if ($id) {
        $candidates = @(
            ('https://lh3.googleusercontent.com/d/' + $id),
            ('https://drive.usercontent.google.com/download?id=' + $id + '&export=download&confirm=t')
        )
    }
    $ext = $null
    $lastError = ''
    foreach ($candidate in $candidates) {
        try {
            Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
            Invoke-WebRequest -Uri $candidate -OutFile $temporary -UseBasicParsing -MaximumRedirection 10 -ErrorAction Stop
            $ext = Get-ImageExtension $temporary
            if ($ext) { break }
            $lastError = 'Endpoint returned HTML or another unsupported format.'
        } catch {
            $lastError = $_.Exception.Message
        }
    }
    if (-not $ext) { throw ('No endpoint returned a valid JPEG, PNG, or PDF. ' + $lastError) }
    $filename = $Stem + '.' + $ext
    Move-Item -LiteralPath $temporary -Destination (Join-Path $cwd $filename) -Force
    [System.IO.File]::WriteAllText($status, ('\gdef\urlfigimagefile{' + $filename + '}'), [System.Text.Encoding]::ASCII)
    Write-Host ('Downloaded: ' + $filename)
} catch {
    Remove-Item -LiteralPath $temporary,$status -Force -ErrorAction SilentlyContinue
    Write-Error ('urlfigure download failed: ' + $_.Exception.Message)
    exit 1
}
