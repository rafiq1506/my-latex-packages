# My LaTeX Packages

A collection of custom LaTeX packages with a PowerShell-based installer for Windows and TeX Live.

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or later
- TeX Live installed and available in PATH
- Internet connection

## One-Command Installation

Open Windows PowerShell and run:

```powershell
$d=Join-Path $env:TEMP 'latex-installer-setup'; New-Item -ItemType Directory -Force -Path $d | Out-Null; $b='https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main'; foreach($f in @('setup-latex-install.ps1','latex-install.ps1')){ Invoke-WebRequest -Uri "$b/$f" -OutFile (Join-Path $d $f) -UseBasicParsing -ErrorAction Stop }; & (Join-Path $d 'setup-latex-install.ps1')
```

This downloads both installer scripts from GitHub and runs the setup.

**Security:** Review the scripts before running them. If Windows blocks the downloaded scripts under the `RemoteSigned` policy, inspect and unblock them using:

```powershell
Get-Content "$env:TEMP\latex-installer-setup\setup-latex-install.ps1"
Get-Content "$env:TEMP\latex-installer-setup\latex-install.ps1"
Get-ChildItem "$env:TEMP\latex-installer-setup\*.ps1" | Unblock-File
& "$env:TEMP\latex-installer-setup\setup-latex-install.ps1"
```

## Install a LaTeX Package

Restart PowerShell after completing setup.

```powershell
latex-install urlfigure
```

## Verify Installation

```powershell
latex-install urlfigure -Verify
```

Or check directly with TeX Live:

```powershell
kpsewhich urlfigure.sty
```

## Update a Package

```powershell
latex-install urlfigure -Force
```

## Use in LaTeX

```latex
\documentclass[12pt,a4paper]{article}
\usepackage{urlfigure}

\begin{document}

\begin{urlfigure}
    \caption{A Beautiful Kitten}
    \label{fig:kitten}
    \urlimage[0.6\textwidth]{https://raw.githubusercontent.com/appbrewery/webdev/main/kitten.jpeg}
\end{urlfigure}

Figure~\ref{fig:kitten} shows a kitten.

\end{document}
```

Compile using PDFLaTeX with `--shell-escape` enabled. Compile twice to resolve cross-references.

## Repository

https://github.com/rafiq1506/my-latex-packages

## Notes

The installer uses the personal TeX Live directory, typically:

`C:\Users\USERNAME\texmf\tex\latex\`

Packages installed there can be used in LaTeX documents without copying the `.sty` file into each project.

Only install packages from repositories you trust.
