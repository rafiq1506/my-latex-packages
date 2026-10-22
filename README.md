# My LaTeX Packages

A collection of custom LaTeX packages and Windows installation utilities maintained by [rafiq1506](https://github.com/rafiq1506).

## Available Package: `urlfigure` (v1.3)

**`urlfigure`** is a custom LaTeX package that allows users to insert images from publicly accessible web URLs and Google Drive sharing links directly into LaTeX documents.

The package automatically downloads supported images during PDFLaTeX compilation, identifies their actual file formats, and includes them in numbered figures with captions and cross-references.

Version 1.3 introduces **image caching, automatic temporary-file cleanup, and a separately installed PowerShell downloader**, improving upon the previous v1.2 implementation.

### Features

- **Insert images from URLs:** Use `\urlimage[WIDTH]{URL}` without manually downloading image files.
- **Google Drive support:** Accept publicly accessible Google Drive sharing links.
- **Automatic format detection:** Identify JPEG, PNG, and PDF files from their contents rather than filename extensions.
- **Image caching:** Reuse previously downloaded images when their source URLs remain unchanged.
- **Organized image storage:** Store downloaded images in a dedicated `urlfigure-images` directory.
- **Figure captions:** Use standard LaTeX `\caption` commands.
- **Cross-references:** Use `\label` and `\ref` to reference numbered figures.
- **Automatic temporary-file cleanup:** Remove temporary download files after execution.
- **External PowerShell helper:** Use a separately installed downloader instead of generating a PowerShell script during compilation.
- **Windows compatibility:** Designed for PDFLaTeX and TeX Live 2026 on Windows.

> **Platform note:** The downloader is designed for Windows PowerShell 5.1 and Windows 10/11. macOS and Linux are not currently supported by the provided PowerShell integration.

---

## Requirements

Before installing `urlfigure`, ensure that your system meets the following requirements:

- A working LaTeX distribution, preferably **TeX Live 2026**.
- PDFLaTeX compiler.
- Windows 10 or Windows 11.
- Windows PowerShell 5.1 or later.
- Internet connectivity for downloading remote images.
- Compilation with `--shell-escape` enabled.
- Publicly accessible image URLs.

The package uses the following LaTeX dependencies:

- `graphicx`
- `float`
- `shellesc`
- `environ`

These packages must be available in your TeX installation.

---

## Installation

There are two installation methods.

### Option A: Install Using `latex-install` (Recommended)

If you have already configured the repository's custom `latex-install` command, open Windows PowerShell and run:

```powershell
latex-install urlfigure -Force
```

This installs or updates the package.

To verify the installation:

```powershell
latex-install urlfigure -Verify
```

The installer should install both:

```text
urlfigure.sty
urlfigure-fetch-v13.ps1
```

into the appropriate personal TeX directory.

You can verify that TeX Live recognizes the package:

```powershell
kpsewhich urlfigure.sty
```

Verify the downloader:

```powershell
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Both commands should return file paths.

#### Updating an Existing Installer

If your installed `latex-install` command is still using an older version, load the latest installer from GitHub in your current PowerShell session:

```powershell
$script = Invoke-RestMethod "https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main/latex-install.ps1"
Invoke-Expression $script
```

Then run:

```powershell
latex-install urlfigure -Force
latex-install urlfigure -Verify
```

> **Security note:** Review the repository's PowerShell scripts before executing downloaded code.

### Option B: Manual Installation

If you prefer manual installation, download these two files from the repository:

1. `urlfigure.sty`
2. `urlfigure-fetch-v13.ps1`

Place both files in the same directory under your personal TeX tree.

Example:

```text
C:\Users\YOUR_USERNAME\texmf\tex\latex\urlfigure\
    urlfigure.sty
    urlfigure-fetch-v13.ps1
```

Your actual personal TeX directory can be determined using:

```powershell
kpsewhich -var-value=TEXMFHOME
```

After copying the files, verify:

```powershell
kpsewhich urlfigure.sty
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Both files must be discoverable.

**Important:** Version 1.3 no longer generates the PowerShell helper inside your LaTeX document directory. The helper must be installed alongside the package.

---

## Quick Start

Create a file named `main.tex` and paste the following LaTeX code:

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

### Compile the Document

Open PowerShell or Command Prompt in the folder containing `main.tex`.

Run:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

Compile again to resolve cross-references:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

The resulting PDF should contain both figures, provided that the image URLs are accessible.

### Using WinEdt

If you use WinEdt, configure its PDFLaTeX execution command to include:

```text
--shell-escape
```

Make sure the compilation runs in the directory containing your `.tex` document.

---

## Command Reference

### Basic Syntax

```latex
\urlimage[WIDTH]{URL}
```

Example:

```latex
\begin{urlfigure}
    \caption{Example Image}
    \label{fig:example}
    \urlimage[0.6\textwidth]{https://example.com/image.jpg}
\end{urlfigure}
```

| Command | Description |
|---|---|
| `\begin{urlfigure}` | Starts a figure environment. |
| `\end{urlfigure}` | Ends the figure environment. |
| `\urlimage{URL}` | Includes an image using the default width of `0.5\textwidth`. |
| `\urlimage[WIDTH]{URL}` | Includes an image at a specified width. |
| `\caption{TEXT}` | Defines the figure caption. |
| `\label{KEY}` | Assigns a reference key. |
| `\ref{KEY}` | Displays the figure reference number. |

### Image Width Examples

```latex
\urlimage[0.3\textwidth]{URL}
```

```latex
\urlimage[0.5\textwidth]{URL}
```

```latex
\urlimage[0.8\textwidth]{URL}
```

```latex
\urlimage[\textwidth]{URL}
```

**Important:** Write `\urlimage` only once for each image. Do not nest it inside another `\urlimage` command.

---

## Google Drive Image Support

Version 1.3 supports publicly accessible Google Drive image-sharing links.

### Standard Sharing Link

```latex
\urlimage[0.6\textwidth]{https://drive.google.com/file/d/FILE_ID/view?usp=sharing}
```

The downloader extracts the Google Drive file ID and attempts to retrieve the image using supported Google endpoints.

### Direct Image-Serving Link

You may also use:

```latex
\urlimage[0.6\textwidth]{https://lh3.googleusercontent.com/d/FILE_ID}
```

### Important Google Drive Settings

Before using a Google Drive image:

1. Open the image in Google Drive.
2. Select **Share**.
3. Under **General access**, select **Anyone with the link**.
4. Set the appropriate viewing permission.
5. Copy the sharing link.
6. Paste the link into `\urlimage`.

Some Google Drive images may still fail because of download restrictions, authentication requirements, or changes to Google's image-serving endpoints.

---

## Image Caching (New in v1.3)

Version 1.3 introduces automatic image caching.

Previously, images could be downloaded repeatedly during LaTeX compilation.

The updated downloader stores downloaded images locally and reuses them when the source URL remains unchanged.

### First Compilation

When you compile a document containing:

```latex
\urlimage[0.6\textwidth]{https://example.com/image.jpg}
```

the downloader attempts to retrieve the image and stores it in:

```text
urlfigure-images/
```

Example:

```text
urlfigure-images/urlimage-1.jpg
```

### Subsequent Compilations

When you compile the document again, the downloader checks:

- Whether the cached image exists.
- Whether its recorded source URL matches the current URL.
- Whether the cached file has a supported image format.

If the checks succeed, the existing image is reused without downloading it again.

### When the Image URL Changes

If the source URL changes, the downloader attempts to download the new image and update its cached copy.

### Force a Fresh Download

If an online image changes but its URL remains the same, the cached image may become outdated.

To refresh it, delete the corresponding cached image and its `.url` metadata file, or remove the entire `urlfigure-images` directory if you want to refresh every image.

The package will download the required images again during the next compilation.

---

## Generated Files

The updated package keeps downloaded images in a dedicated folder.

A typical project directory may look like:

```text
My-LaTeX-Project/
│
├── main.tex
├── main.pdf
├── main.aux
├── main.log
│
├── urlimage-1.tex
├── urlimage-2.tex
│
└── urlfigure-images/
    ├── urlimage-1.jpg
    ├── urlimage-1.url
    ├── urlimage-2.jpg
    └── urlimage-2.url
```

### File Descriptions

| File | Purpose |
|---|---|
| `main.tex` | Main LaTeX source document. |
| `main.pdf` | Compiled PDF document. |
| `main.aux` | LaTeX auxiliary file for references. |
| `main.log` | Compilation log. |
| `urlimage-N.tex` | Generated metadata containing the image filename. |
| `urlfigure-images/urlimage-N.jpg` | Cached JPEG image. |
| `urlfigure-images/urlimage-N.png` | Cached PNG image. |
| `urlfigure-images/urlimage-N.pdf` | Cached PDF image. |
| `urlfigure-images/urlimage-N.url` | Metadata recording the image source URL. |

### Important Changes from v1.2

Version 1.2 could create:

```text
urlfigure-fetch-v12.ps1
```

inside the document directory.

Version 1.3 instead uses an installed helper:

```text
urlfigure-fetch-v13.ps1
```

The helper remains in the TeX package installation directory and is not generated during each compilation.

**Note:** The current v1.3 implementation still creates `urlimage-N.tex` metadata files in the working directory. It does not automatically remove those metadata files after successful inclusion.

---

## Troubleshooting

### 1. `I can't find file 'main.tex'`

This error occurs when PDFLaTeX cannot find the requested source file.

Check the current directory:

```powershell
Get-Location
```

List matching files:

```powershell
dir main*
```

Ensure that `main.tex` exists in the current folder.

If necessary, navigate to the correct directory:

```powershell
cd "D:\YourFolder"
```

Then compile:

```powershell
pdflatex.exe --shell-escape main.tex
```

If using Windows File Explorer, enable **View → Show → File name extensions** to distinguish `main.tex` from `main.txt`.

### 2. `Image download failed for urlimage-N`

Possible causes include:

- Invalid image URL.
- No internet connection.
- Google Drive authentication restrictions.
- Unsupported image format.
- PowerShell execution failure.
- Missing downloader.
- Shell escape not enabled.

Check that both package files are installed:

```powershell
kpsewhich urlfigure.sty
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Compile with:

```powershell
pdflatex.exe --shell-escape main.tex
```

Review the compilation log for additional information.

### 3. PowerShell Downloader Not Found

If the helper cannot be located, reinstall the package:

```powershell
latex-install urlfigure -Force
```

Then verify:

```powershell
latex-install urlfigure -Verify
```

For manual installations, ensure that `urlfigure-fetch-v13.ps1` is located alongside `urlfigure.sty` in the personal TeX directory.

### 4. Images Are Not Updating

Version 1.3 uses image caching.

If an image changes on the server without its URL changing, the local cached image will still be used.

Delete the relevant image and `.url` metadata file from:

```text
urlfigure-images/
```

Compile again to download a fresh copy.

### 5. Figure References Display `??`

Compile the document twice:

```powershell
pdflatex.exe --shell-escape main.tex
pdflatex.exe --shell-escape main.tex
```

LaTeX needs an additional compilation to resolve cross-references.

### 6. Unsupported Image Format

The downloader supports:

- JPEG
- PNG
- PDF

If the URL returns an HTML webpage, authentication page, or unsupported file format, the download will fail.

Use a direct image URL or a supported public Google Drive sharing link.

### 7. Package Changes Are Not Reflected

Determine which package TeX Live loads:

```powershell
kpsewhich urlfigure.sty
```

If the result points to an older installation, update that installation.

Reinstall the package using:

```powershell
latex-install urlfigure -Force
```

Then verify the installed files.

### 8. Old `urlfigure-fetch-v12.ps1` Still Appears

If the old helper is still being generated, an older version of `urlfigure.sty` may be loaded.

Run:

```powershell
kpsewhich urlfigure.sty
```

Check the package version in that file.

Version 1.3 should no longer contain the embedded `filecontents*` block that generates `urlfigure-fetch-v12.ps1`.

Previously generated copies of the old helper may be deleted manually after confirming that they are no longer required.

### 9. `Cannot create a file when that file already exists`

This may occur because of a file conflict or a previous incomplete download.

Close any application that may be locking the affected files, inspect the compilation log, and remove disposable temporary files if necessary.

Then compile again.

---

## Updating the Package

When a new version is available in the GitHub repository, update the installed package using:

```powershell
latex-install urlfigure -Force
```

Verify:

```powershell
latex-install urlfigure -Verify
```

If the installer itself has changed, load the updated installer script before reinstalling the package.

### Updating Repository Files Through GitHub

You can maintain the repository directly through the GitHub website.

1. Open [my-latex-packages](https://github.com/rafiq1506/my-latex-packages).
2. Select the file you want to modify.
3. Click the **Edit** (pencil) icon.
4. Replace or update the file contents.
5. Select **Commit changes**.
6. Confirm the changes.

To add a new file, select **Add file → Create new file**, enter the filename, and paste its contents.

No local Git commands are required for this workflow.

---

## Security Notes

The package requires `--shell-escape`, which allows LaTeX to execute external commands.

Use the package only with trusted LaTeX documents and trusted image URLs.

The PowerShell downloader performs HTTP requests to retrieve remote content. Downloaded files are checked for supported image signatures before inclusion.

However, file signature validation is not a complete security guarantee.

The current shell-command interface also has limitations when handling special characters in URLs. Avoid untrusted or dynamically supplied URLs, especially those containing shell-sensitive characters.

Do not compile untrusted `.tex` files with unrestricted shell escape.

---

## Version History

### v1.3 — October 22, 2026

- Introduced image caching.
- Added a dedicated `urlfigure-images` directory.
- Added source URL metadata for cache validation.
- Separated the PowerShell downloader from the LaTeX package.
- Removed automatic generation of `urlfigure-fetch-v12.ps1`.
- Introduced `urlfigure-fetch-v13.ps1`.
- Improved temporary download cleanup.
- Updated the installer to install both required files.
- Expanded documentation and troubleshooting guidance.

### v1.2

- Supported image downloads from ordinary web URLs.
- Added support for publicly accessible Google Drive sharing links.
- Implemented JPEG, PNG, and PDF format detection.
- Used an embedded PowerShell helper generated during compilation.
- Supported figure captions, labels, and references.

---

## Project Status

**Current version:** v1.3 (proposed implementation)

**Target environment:** Windows 10/11, TeX Live 2026, PDFLaTeX, Windows PowerShell 5.1.

Version 1.2 was tested by the maintainer using a GitHub-hosted JPEG and a public Google Drive image.

Version 1.3 introduces architectural improvements but requires validation on a Windows installation before it should be considered fully tested.

Contributions, bug reports, and compatibility testing are welcome.

---

## Repository

**GitHub:** https://github.com/rafiq1506/my-latex-packages

**Maintainer:** [rafiq1506](https://github.com/rafiq1506)

**Package:** `urlfigure`

**Version:** 1.3

**Supported image formats:** JPEG, PNG, PDF

**Primary compiler:** PDFLaTeX

**Platform:** Windows

---

*Developed and maintained by [rafiq1506](https://github.com/rafiq1506).*
