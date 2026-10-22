# My LaTeX Packages

A collection of custom LaTeX packages and PowerShell utilities for simplifying document preparation on Windows. The repository includes the **`urlfigure`** package, which downloads publicly accessible images from URLs and inserts them into LaTeX figures.

> **Platform:** The `urlfigure` downloader currently targets Windows with PowerShell 5.1 and PDFLaTeX. It has been used with TeX Live 2026. Other operating systems and LaTeX engines are not yet verified.

## Features

- Use `\urlimage` to include an image from a web URL.
- Support for JPEG, PNG, and PDF downloads (identified by file signatures).
- Support for public Google Drive file-sharing links, with image-serving and download endpoint attempts.
- Figure captions, labels, and cross-references through the `urlfigure` environment.
- Automatic removal of per-image `.tex` metadata files after successful inclusion.
- PowerShell-based installation/update workflow for custom packages.

## Requirements

- Windows 10 or 11 with **Windows PowerShell 5.1**.
- A working **TeX Live** installation with `pdflatex` available in `PATH`.
- LaTeX dependencies: `float`, `graphicx`, `shellesc`, and `environ`.
- Internet access for remote images.
- **`--shell-escape`** enabled when compiling documents that use `\urlimage`.

Only download images from URLs and compile LaTeX documents that you trust. Enabling shell escape permits LaTeX to execute external commands.

## Installation

### Option A: Use the repository's installer

Clone the repository:

```powershell
git clone https://github.com/rafiq1506/my-latex-packages.git
cd my-latex-packages
```

The repository provides `setup-latex-install.ps1` and `latex-install.ps1` for its Windows installation workflow. After setting up the `latex-install` command using the included setup script, install or update `urlfigure`:

```powershell
latex-install urlfigure -Force
latex-install urlfigure -Verify
```

If `latex-install` is not recognized, run or inspect `setup-latex-install.ps1` according to your PowerShell execution policy, then open a new PowerShell session.

### Option B: Install `urlfigure.sty` manually

Copy `urlfigure.sty` into your personal TeX tree:

```text
%USERPROFILE%\texmf\tex\latex\urlfigure\urlfigure.sty
```

Alternatively, place `urlfigure.sty` next to your `.tex` document for a project-local installation.

Confirm the file that TeX will load:

```powershell
kpsewhich urlfigure.sty
```

The v1.2 package generates `urlfigure-fetch-v12.ps1` in the compilation directory if it does not already exist. A standalone copy of this helper may also be kept in the repository for maintenance.

## Quick start

Create `main.tex`:

```latex
\documentclass[12pt,a4paper]{article}
\usepackage{urlfigure}

\begin{document}

\section{Remote Images}

\begin{urlfigure}
    \caption{Tracking Journey}
    \label{fig:track}
    \urlimage[0.6\textwidth]{https://drive.google.com/file/d/1mklHGFX0EypgrwZWOJt_hAjtBvLdUbxI/view?usp=sharing}
\end{urlfigure}

Figure~\ref{fig:track} shows the tracking journey.

\end{document}
```

Compile twice to resolve cross-references:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

### Commands

| Command | Purpose |
| --- | --- |
| `\usepackage{urlfigure}` | Load the package. |
| `\begin{urlfigure} ... \end{urlfigure}` | Create a figure using the `[H]` placement option. |
| `\urlimage{URL}` | Download and insert an image at the default width (`0.5\textwidth`). |
| `\urlimage[0.6\textwidth]{URL}` | Insert an image at a specified width. |
| `\caption{...}` | Set the figure caption. |
| `\label{fig:...}` | Set a reference label; refer to it with `\ref{fig:...}`. |

Write `\urlimage` **only once** per image; do not nest it inside another `\urlimage` call.

## Google Drive images

Use a public file-sharing URL such as:

```text
https://drive.google.com/file/d/FILE_ID/view?usp=sharing
```

The downloader attempts a Google image-serving URL and a download fallback, then checks whether the response is a supported image or PDF. The file must be accessible without authentication. Some Drive links may still return an HTML preview, confirmation page, or access-denied response; support is therefore **best effort**, not guaranteed for every Drive file.

For a public image, a direct URL may also work:

```text
https://lh3.googleusercontent.com/d/FILE_ID
```

## Generated files

During compilation, the package may create:

```text
urlfigure-fetch-v12.ps1   PowerShell download helper
urlimage-1.jpg            Downloaded image (extension may be png or pdf)
urlimage-2.png            Another downloaded image
urlimage-1.tex            Temporary metadata, normally deleted after inclusion
```

Downloaded image files are retained in the project folder. Temporary `urlimage-*.tex` metadata files are normally removed after successful inclusion. LaTeX also creates its usual `.aux`, `.log`, `.pdf`, and other build files.

## Troubleshooting

**`File 'urlfigure.sty' not found`**

Check the installed location with `kpsewhich urlfigure.sty`; reinstall the package or put the `.sty` file beside `main.tex`.

**`Image download failed` or `unsupported file`**

Confirm the URL is publicly accessible and returns actual JPEG, PNG, or PDF bytes rather than an HTML page. For Google Drive images, verify sharing permissions and try the direct `lh3.googleusercontent.com/d/FILE_ID` URL.

**`Cannot create a file when that file already exists`**

A previous generated image or temporary download may be conflicting with a new download. Close applications using the image, remove only generated `urlimage-*` files in the project directory, and retry. If the error persists, inspect the downloader's destination-file handling.

**An older downloader keeps running**

Check the installed package version, then delete the generated `urlfigure-fetch-v12.ps1` from the *project folder* so the installed package can recreate it on the next compilation.

**PDF generated but compilation reports an error**

Treat the compilation as failed. The PDF may omit one or more figures; inspect the log and resolve the error before using the output.

## Updating the repository

From the local clone:

```powershell
cd "D:\Coding\my-latex-packages"
git status
git add .
git commit -m "Update LaTeX packages and documentation"
git push origin main
```

To reinstall the latest version of `urlfigure` using the configured installer:

```powershell
latex-install urlfigure -Force
```

## Project status

`urlfigure` v1.2 is a Windows-focused custom package. Image hosting services can change their download behavior, and the downloader may need maintenance. Contributions, reproducible bug reports, and suggestions are welcome through GitHub issues and pull requests.

## Repository

https://github.com/rafiq1506/my-latex-packages

**License:** See the repository's `LICENSE` file if one is provided. No license is implied by this README alone.
