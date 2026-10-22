# My LaTeX Packages

A collection of custom LaTeX packages and installation utilities developed and maintained by [rafiq1506](https://github.com/rafiq1506).

This repository provides tools for extending LaTeX functionality and simplifying the installation of custom packages on Windows.

## 📦 Available Package: `urlfigure` v1.3

**`urlfigure`** is a custom LaTeX package that allows users to insert images directly from online URLs and publicly accessible Google Drive sharing links without manually downloading and managing image files.

The package automatically downloads supported images during compilation, identifies their formats, caches downloaded images for future use, and integrates them into numbered LaTeX figures.

### ✨ Key Features

- **Direct URL images:** Insert online images using `\urlimage[WIDTH]{URL}`.
- **Google Drive integration:** Supports publicly accessible Google Drive image-sharing links.
- **Automatic image downloading:** Retrieves images during LaTeX compilation.
- **Format detection:** Supports JPEG, PNG, and PDF images.
- **Smart image caching:** Avoids downloading unchanged images repeatedly.
- **Organized storage:** Stores images in a dedicated `urlfigure-images` directory.
- **Hidden metadata:** Keeps caching information inside a hidden `.metadata` folder.
- **Automatic cleanup:** Removes temporary image metadata files after successful inclusion.
- **Captions and references:** Supports `\caption`, `\label`, and `\ref`.
- **Easy installation:** Install or update the package using the `latex-install` PowerShell command.
- **Windows compatibility:** Designed for TeX Live 2026 and PDFLaTeX on Windows 10/11.

---

## 🖥️ System Requirements

| Requirement | Details |
|---|---|
| Operating system | Windows 10 / Windows 11 |
| LaTeX distribution | TeX Live 2026 |
| Compiler | PDFLaTeX |
| PowerShell | Windows PowerShell 5.1 or later |
| Internet connection | Required for first-time image downloads |
| Shell escape | Must be enabled |
| Image formats | JPEG, PNG, PDF |

### Required LaTeX Packages

The following packages must be installed:

- `graphicx`
- `float`
- `shellesc`
- `environ`

These packages are commonly available in TeX Live.

> **Note:** The current implementation is designed for Windows. macOS and Linux compatibility has not been established.

---

## 🚀 Installation

### Method 1: Using the Custom Installer (Recommended)

If you have already configured the `latex-install` command, open Windows PowerShell and run:

```powershell
latex-install urlfigure -Force
```

This installs the latest package files from the repository.

Verify the installation:

```powershell
latex-install urlfigure -Verify
```

### First-Time Installer Setup

For first-time installation, download these two files from the repository:

- [latex-install.ps1](https://github.com/rafiq1506/my-latex-packages/blob/main/latex-install.ps1)
- [setup-latex-install.ps1](https://github.com/rafiq1506/my-latex-packages/blob/main/setup-latex-install.ps1)

Place both files in the same folder.

Open Windows PowerShell in that folder and execute:

```powershell
.\setup-latex-install.ps1
```

If script execution is restricted, review the scripts and your PowerShell execution policy before proceeding.

After successful setup, close PowerShell and open a new PowerShell window.

Now install the package:

```powershell
latex-install urlfigure
```

To update an existing installation:

```powershell
latex-install urlfigure -Force
```

To verify:

```powershell
latex-install urlfigure -Verify
```

### Refreshing the Installer

If your installed `latex-install` command is outdated, you can load the latest installer from GitHub into the current PowerShell session:

```powershell
$script = Invoke-RestMethod "https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main/latex-install.ps1"
Invoke-Expression $script
```

Then run:

```powershell
latex-install urlfigure -Force
```

**Security:** Review remote scripts before executing them.

---

## 🔧 Manual Installation

If you prefer to install the package manually, download:

1. `urlfigure.sty`
2. `urlfigure-fetch-v13.ps1`

Place both files inside your personal TeX directory.

Example:

```text
C:\Users\YOUR_USERNAME\texmf\tex\latex\urlfigure\
│
├── urlfigure.sty
└── urlfigure-fetch-v13.ps1
```

To find your actual personal TeX directory:

```powershell
kpsewhich -var-value=TEXMFHOME
```

Verify that LaTeX can locate the package:

```powershell
kpsewhich urlfigure.sty
```

Verify the downloader:

```powershell
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Both commands should return valid file paths.

---

## 📖 Quick Start

Create a file named `main.tex` and insert the following code:

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

Open PowerShell in the folder containing `main.tex`.

Run:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

Compile a second time to resolve cross-references:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

Your generated PDF should contain the downloaded images with their captions and figure numbers.

### Using WinEdt

When compiling through WinEdt, ensure that the PDFLaTeX command includes:

```text
--shell-escape
```

For example:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode --synctex=-1 main.tex
```

---

## 📝 Command Reference

### Basic Syntax

```latex
\urlimage[WIDTH]{URL}
```

### Complete Figure Example

```latex
\begin{urlfigure}
    \caption{Example Image}
    \label{fig:example}
    \urlimage[0.6\textwidth]{https://example.com/image.jpg}
\end{urlfigure}
```

### Available Commands

| Command | Description |
|---|---|
| `\begin{urlfigure}` | Begins a figure environment. |
| `\end{urlfigure}` | Ends a figure environment. |
| `\urlimage{URL}` | Includes an image at the default width of `0.5\textwidth`. |
| `\urlimage[WIDTH]{URL}` | Includes an image at the specified width. |
| `\caption{TEXT}` | Adds a figure caption. |
| `\label{KEY}` | Defines a reference label. |
| `\ref{KEY}` | References a numbered figure. |

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

---

## ☁️ Google Drive Image Support

The package supports publicly accessible Google Drive images.

### Standard Google Drive Sharing Link

```latex
\urlimage[0.6\textwidth]{https://drive.google.com/file/d/FILE_ID/view?usp=sharing}
```

### Direct Image-Serving Link

```latex
\urlimage[0.6\textwidth]{https://lh3.googleusercontent.com/d/FILE_ID}
```

### How to Share a Google Drive Image

1. Upload the image to Google Drive.
2. Right-click the image and select **Share**.
3. Under **General access**, choose **Anyone with the link**.
4. Select **Viewer** permission.
5. Copy the sharing link.
6. Paste the URL inside `\urlimage`.

The downloader attempts to retrieve the image using supported Google Drive endpoints.

**Important:** Google Drive files requiring authentication may not work. Public sharing does not guarantee successful downloading in every case.

---

## ⚡ Smart Image Caching

Starting with v1.3, `urlfigure` supports automatic image caching.

### First Compilation

When an image URL is encountered for the first time:

1. The downloader retrieves the image.
2. Its actual file format is detected.
3. The image is saved inside `urlfigure-images`.
4. The source URL is recorded in cache metadata.
5. The image is included in the LaTeX document.

### Subsequent Compilations

During subsequent compilations:

1. The downloader checks whether the image exists.
2. It compares the stored URL with the current URL.
3. It validates the cached image format.
4. If the checks succeed, the cached image is reused.

This reduces unnecessary downloads and improves compilation efficiency.

### Refreshing Cached Images

If an image changes online but its URL remains unchanged, the cached copy may become outdated.

To force a new download, delete the relevant cached image and its associated `.cache` file.

Alternatively, delete the entire `urlfigure-images` folder to refresh all images during the next compilation.

---

## 📂 Generated Folder Structure

When you compile a LaTeX document containing two remote images, the project directory may look like:

```text
My-LaTeX-Project/
│
├── main.tex
├── main.pdf
├── main.aux
├── main.log
├── main.synctex
│
└── urlfigure-images/
    │
    ├── urlimage-1.jpg
    ├── urlimage-2.jpg
    │
    └── .metadata/              [Hidden Folder]
        ├── urlimage-1.cache
        └── urlimage-2.cache
```

### File Descriptions

| File | Purpose |
|---|---|
| `main.tex` | Main LaTeX source file |
| `main.pdf` | Compiled PDF |
| `main.aux` | LaTeX cross-reference information |
| `main.log` | Compilation log |
| `urlimage-1.jpg` | Downloaded image |
| `urlimage-2.jpg` | Downloaded image |
| `.metadata/` | Hidden folder containing cache metadata |
| `urlimage-1.cache` | Stores the original URL of the first image |
| `urlimage-2.cache` | Stores the original URL of the second image |

The `.metadata` folder is automatically marked as hidden on Windows.

**Note:** The actual image extensions depend on the detected formats. Downloaded files may be JPEG, PNG, or PDF.

---

## 🧹 Automatic Cleanup

Version 1.3 improves temporary-file management.

The package uses temporary metadata files such as:

```text
urlimage-1.tex
urlimage-2.tex
```

These files communicate the downloaded image filenames to LaTeX.

With the updated `urlfigure.sty`, the temporary `.tex` metadata files are deleted after successful image inclusion.

The PowerShell downloader also removes temporary `.download` files after execution.

The cached images and their `.cache` metadata are preserved for future compilations.

---

## 🔍 Troubleshooting

### 1. `I can't find file 'main.tex'`

This error indicates that PDFLaTeX cannot locate the requested source file.

Check your current directory:

```powershell
Get-Location
```

List available TeX files:

```powershell
dir *.tex
```

Navigate to the correct directory:

```powershell
cd "D:\YourFolder"
```

Then compile:

```powershell
pdflatex.exe --shell-escape main.tex
```

Make sure the file is actually named `main.tex`, not `main.txt`.

### 2. `Image download failed for urlimage-N`

Possible causes include:

- Invalid image URL.
- Internet connectivity problems.
- Google Drive access restrictions.
- Unsupported image format.
- Missing PowerShell helper.
- Disabled shell escape.
- PowerShell execution errors.

Verify the package:

```powershell
kpsewhich urlfigure.sty
```

Verify the downloader:

```powershell
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Ensure that both files are installed correctly.

### 3. PowerShell Cannot Find `.metadata`

If the downloader reports:

```text
Get-Item : Could not find item ...\.metadata
```

ensure that the installed `urlfigure-fetch-v13.ps1` uses:

```powershell
$folder = Get-Item -LiteralPath $metadataDir -Force -ErrorAction Stop
```

The `-Force` parameter allows PowerShell to access the hidden metadata folder.

Reinstall the latest package:

```powershell
latex-install urlfigure -Force
```

### 4. Images Are Not Updating

The package caches downloaded images.

If an image changes at the same URL, delete its cached image and associated `.cache` file.

Compile again to download the updated image.

### 5. Figure References Display `??`

Compile twice:

```powershell
pdflatex.exe --shell-escape main.tex
pdflatex.exe --shell-escape main.tex
```

LaTeX requires another compilation to resolve cross-references.

### 6. Package Updates Are Not Reflected

Check which package file TeX Live is using:

```powershell
kpsewhich urlfigure.sty
```

Check the installed PowerShell helper:

```powershell
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Update the installation:

```powershell
latex-install urlfigure -Force
```

If necessary, refresh the installer from GitHub before reinstalling.

### 7. Internet Shortcut Files Appear in the Image Folder

Older versions of the downloader stored source URLs using `.url` files.

Windows identifies these as Internet Shortcuts.

The updated downloader uses `.cache` files stored inside a hidden `.metadata` folder.

After confirming that the updated package works, obsolete `.url` files from the older implementation may be removed.

### 8. Unsupported Image Format

The downloader currently supports:

- JPEG
- PNG
- PDF

HTML webpages, authentication pages, and unsupported image formats are rejected.

For best results, use publicly accessible direct image URLs.

---

## 🔐 Security Notes

The package requires `--shell-escape` to execute the PowerShell downloader.

Shell escape allows LaTeX to run external commands, so it should only be enabled when compiling trusted documents.

Additional precautions:

- Review PowerShell installation scripts before executing them.
- Use trusted image URLs.
- Avoid compiling untrusted LaTeX documents with unrestricted shell escape.
- Be aware that URLs containing special shell characters may not be handled safely by the current command interface.
- Downloaded image signature validation does not guarantee that a file is harmless.

---

## 📁 Repository Structure

The recommended repository structure is:

```text
my-latex-packages/
│
├── README.md
│
├── latex-install.ps1
│
├── setup-latex-install.ps1
│
├── urlfigure.sty
│
├── urlfigure-fetch-v13.ps1
│
└── main.tex                 [Optional Example]
```

### Repository Files

| File | Description |
|---|---|
| `README.md` | Package documentation |
| `latex-install.ps1` | Installs and updates custom LaTeX packages |
| `setup-latex-install.ps1` | Configures the custom installer command |
| `urlfigure.sty` | Main LaTeX package |
| `urlfigure-fetch-v13.ps1` | PowerShell image downloader and cache manager |
| `main.tex` | Optional demonstration document |

The obsolete `urlfigure-fetch-v12.ps1` is not required for v1.3.

---

## 🆕 Version History

### v1.3 — October 2026

- Added automatic image caching.
- Introduced a dedicated image storage directory.
- Added hidden `.metadata` folder for caching information.
- Replaced `.url` metadata with `.cache` files.
- Separated the PowerShell downloader from the LaTeX package.
- Removed automatic generation of the old PowerShell helper.
- Improved temporary-file cleanup.
- Added installation and verification support for the external downloader.
- Improved Windows PowerShell compatibility.
- Updated documentation and troubleshooting instructions.

### v1.2

- Added support for ordinary web image URLs.
- Added publicly accessible Google Drive sharing-link support.
- Implemented JPEG, PNG, and PDF detection.
- Supported numbered figures, captions, labels, and references.
- Used an embedded PowerShell downloader.

---

## 📌 Project Status

**Current version:** `urlfigure` v1.3

**Platform:** Windows 10/11

**LaTeX distribution:** TeX Live 2026

**Compiler:** PDFLaTeX

**PowerShell:** Windows PowerShell 5.1+

**Supported formats:** JPEG, PNG, PDF

**Status:** Successfully tested by the maintainer on Windows with online images, Google Drive images, caching, and automatic cleanup.

Broader compatibility testing and contributions are welcome.

---

## 👨‍💻 Maintainer

Developed and maintained by **[rafiq1506](https://github.com/rafiq1506)**.

**Repository:** [my-latex-packages](https://github.com/rafiq1506/my-latex-packages)

---

## ⭐ Support the Project

If you find this package useful, consider starring the repository on GitHub.

Feedback, suggestions, bug reports, and contributions are welcome.

**GitHub:** https://github.com/rafiq1506/my-latex-packages

---

*Making LaTeX image management simpler, faster, and more convenient.*
