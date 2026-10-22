# My LaTeX Packages

A collection of custom LaTeX packages and Windows installation utilities maintained by [rafiq1506](https://github.com/rafiq1506).

## Available package: `urlfigure` (v1.2)

`urlfigure` lets you insert images from public web URLs and publicly accessible Google Drive sharing links directly into a LaTeX document. The package downloads the image during compilation, detects whether it is JPEG, PNG, or PDF, and includes it as a numbered figure with a caption and label.

### Features

- Include a remote image with `\urlimage[<width>]{<URL>}`.
- Use ordinary Google Drive file-sharing links, such as `https://drive.google.com/file/d/FILE_ID/view?usp=sharing`, for publicly accessible images.
- Detect JPEG, PNG, and PDF files from their contents rather than assuming a filename extension.
- Use `\caption`, `\label`, and `\ref` for figure captions and cross-references.
- Remove generated `urlimage-*.tex` metadata files after successful inclusion.
- Use a PowerShell helper to download images on Windows.

> **Platform note:** The current downloader uses Windows PowerShell 5.1 and is intended for Windows 10/11. It has not been validated on macOS or Linux.

## Requirements

- A working LaTeX installation (tested with **TeX Live 2026** and **PDFLaTeX**).
- Windows PowerShell 5.1 (`powershell.exe`).
- Internet access to the image URLs.
- Compilation with **`--shell-escape`** enabled.
- Publicly accessible image links; Google Drive links requiring sign-in may not work.

## Installation

### Option A: Use the repository installer

If you already installed the repository's `latex-install` command, open PowerShell and run:

```powershell
latex-install urlfigure -Force
latex-install urlfigure -Verify
```

The installer should place `urlfigure.sty` in your personal TeX tree. Confirm which file TeX finds:

```powershell
kpsewhich urlfigure.sty
```

For first-time installer setup, consult `setup-latex-install.ps1` and `latex-install.ps1` in this repository. Review scripts before executing them.

### Option B: Manual installation

Copy `urlfigure.sty` to your personal TeX directory:

```text
%USERPROFILE%\texmf\tex\latex\urlfigure\urlfigure.sty
```

For example:

```text
C:\Users\SAHIL\texmf\tex\latex\urlfigure\urlfigure.sty
```

Then run:

```powershell
kpsewhich urlfigure.sty
```

The package contains the PowerShell helper script and can create `urlfigure-fetch-v12.ps1` in the document's working directory when it is missing. A standalone copy of the helper is also provided in the repository for inspection and maintenance.

## Quick start

Create `main.tex`:

```latex
\documentclass[12pt,a4paper]{article}

\usepackage{urlfigure}

\begin{document}

\section{Images from URLs}

\begin{urlfigure}
    \caption{A Beautiful Kitten}
    \label{fig:kitten}
    \urlimage[0.6\textwidth]{https://raw.githubusercontent.com/appbrewery/webdev/main/kitten.jpeg}
\end{urlfigure}

\begin{urlfigure}
    \caption{Tracking Journey}
    \label{fig:track}
    \urlimage[0.6\textwidth]{https://drive.google.com/file/d/1mklHGFX0EypgrwZWOJt_hAjtBvLdUbxI/view?usp=sharing}
\end{urlfigure}

Figure~\ref{fig:kitten} shows a beautiful kitten.
Figure~\ref{fig:track} shows the tracking journey.

\end{document}
```

Compile **twice** so that cross-references are resolved:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

In **WinEdt**, configure the PDFLaTeX command to include `--shell-escape`.

## Command reference

```latex
\begin{urlfigure}
    \caption{Caption text}
    \label{fig:example}
    \urlimage[0.6\textwidth]{https://example.com/image.jpg}
\end{urlfigure}
```

| Command | Description |
| --- | --- |
| `\begin{urlfigure} ... \end{urlfigure}` | Creates a figure at the current location using the `float` package. |
| `\urlimage{URL}` | Downloads and includes an image at the default width (`0.5\textwidth`). |
| `\urlimage[WIDTH]{URL}` | Downloads and includes an image at the specified width. |
| `\caption{TEXT}` | Sets the figure caption. |
| `\label{KEY}` | Defines a figure reference key. |
| `\ref{KEY}` | Refers to a numbered figure in the document. |

Write `\urlimage` **once**, not nested inside another `\urlimage` command.

## Google Drive images

For a public image shared from Google Drive, you can paste the normal sharing link:

```latex
\urlimage[0.6\textwidth]{https://drive.google.com/file/d/FILE_ID/view?usp=sharing}
```

The downloader recognizes supported Google Drive sharing-link formats and attempts an image-serving endpoint first. If needed, it attempts an alternative download endpoint. It validates the returned file before including it, so an HTML preview or sign-in page will not be mistaken for a JPEG.

For the example image, the image-serving URL also works directly:

```latex
\urlimage[0.6\textwidth]{https://lh3.googleusercontent.com/d/1mklHGFX0EypgrwZWOJt_hAjtBvLdUbxI}
```

**Important:** A file must be accessible to the downloader without signing in. Some Google Drive files may still fail because of access restrictions or Google's download behavior.

## Generated files

Depending on your document, compilation can generate:

| File | Purpose |
| --- | --- |
| `urlimage-1.jpg`, `urlimage-2.png`, etc. | Downloaded images used in the PDF. |
| `urlimage-1.tex`, etc. | Temporary metadata containing the detected image filename; normally removed after successful inclusion. |
| `urlfigure-fetch-v12.ps1` | PowerShell helper generated when missing. |
| `main.aux`, `main.log`, `main.pdf` | Standard LaTeX output files. |

Do not manually edit generated `urlimage-*.tex` files. The numbered image files can be regenerated by recompiling while the source URLs remain available.

## Troubleshooting

### `Image download failed for urlimage-N`

- Confirm that the image URL works without authentication.
- Check that your internet connection is working.
- Ensure PDFLaTeX is invoked with `--shell-escape`.
- Read the PowerShell error immediately above the LaTeX package error in the compilation log.
- If the source is Google Drive, check its sharing settings and try its `https://lh3.googleusercontent.com/d/FILE_ID` URL.

### `Cannot create a file when that file already exists`

An older downloader or leftover generated files may conflict with the new download. Update **both** the embedded helper in `urlfigure.sty` and the standalone PowerShell helper, then delete generated `urlimage-*` files in the document directory **only if they are disposable** and compile again.

### Package changes are not reflected

Check the loaded package:

```powershell
kpsewhich urlfigure.sty
```

Reinstall the updated package:

```powershell
latex-install urlfigure -Force
```

If a stale `urlfigure-fetch-v12.ps1` exists in your document folder, remove that generated helper so the updated package can recreate it.

### Figure references show `??`

Compile twice to refresh LaTeX cross-references.

### Unsupported image format / HTML preview

The URL returned a page or an unsupported file instead of JPEG, PNG, or PDF data. Use a direct, publicly accessible image link.

## Updating this repository

From a local clone:

```powershell
cd "D:\Coding\my-latex-packages"
git status
git add .
git commit -m "Update urlfigure package and documentation"
git push origin main
```

If your working tree is clean, there is nothing new to commit. Do not run these commands from a directory outside the cloned repository.

## Security notes

`--shell-escape` permits LaTeX to run external commands. **Compile only documents and use URLs that you trust.** The current command-line URL interface may not handle every possible special character safely. Do not compile untrusted `.tex` files with unrestricted shell escape.

## Project status

`urlfigure` v1.2 has been tested by the maintainer with PDFLaTeX on Windows using a GitHub-hosted JPEG and a public Google Drive image. Broader testing across image hosts, TeX distributions, and operating systems is welcome.

## Repository

- GitHub: https://github.com/rafiq1506/my-latex-packages
- Maintainer: [rafiq1506](https://github.com/rafiq1506)
