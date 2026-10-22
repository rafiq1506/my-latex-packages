# My LaTeX Packages

Custom LaTeX packages and installation utilities for Windows, maintained by [rafiq1506](https://github.com/rafiq1506).

This repository currently provides **`urlfigure` v1.3**, a LaTeX package that downloads and inserts images from online URLs, including publicly accessible Google Drive links.

## ✨ Features

- Insert online images with `\urlimage[WIDTH]{URL}`.
- Support for publicly accessible Google Drive image links.
- Automatic JPEG, PNG, and PDF format detection.
- Cache downloaded images to avoid repeated downloads when the URL is unchanged.
- Store images in a `urlfigure-images/` folder and URL metadata in its hidden `.metadata/` subfolder.
- Clean up temporary downloader files after successful processing.
- Use ordinary LaTeX captions, labels, and cross-references.
- Install and update the package using the PowerShell-based `latex-install` utility.

## 🖥️ Requirements

- Windows 10 or Windows 11.
- TeX Live (tested with TeX Live 2026).
- PDFLaTeX.
- Windows PowerShell 5.1 or later.
- Internet access when downloading new images.
- **Unrestricted `--shell-escape` enabled for trusted documents.**

The LaTeX package may require common packages such as `graphicx`, `float`, `shellesc`, and `environ`, depending on the installed `urlfigure.sty` version. TeX Live typically provides these.

> **Platform note:** This version uses a Windows PowerShell downloader. macOS and Linux support is not currently established.

## 📁 Repository files

| File | Purpose |
| --- | --- |
| `README.md` | Documentation |
| `latex-install.ps1` | Package installation/update utility |
| `setup-latex-install.ps1` | One-time setup of the `latex-install` command |
| `urlfigure.sty` | LaTeX package |
| `urlfigure-fetch-v13.ps1` | Image downloader and cache manager |
| `main.tex` *(optional)* | Example document, if retained in the repository |

The older `urlfigure-fetch-v12.ps1` is not required by the v1.3 package.

## 🚀 Installation

### Option A: Install using `latex-install` (recommended)

If the `latex-install` command is already configured, open **Windows PowerShell** and run:

```powershell
latex-install urlfigure -Force
```

To check the installation, locate the installed files:

```powershell
kpsewhich urlfigure.sty
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

Both commands should return a valid file path.

### Option B: First-time setup

1. Download [`setup-latex-install.ps1`](https://github.com/rafiq1506/my-latex-packages/blob/main/setup-latex-install.ps1) and [`latex-install.ps1`](https://github.com/rafiq1506/my-latex-packages/blob/main/latex-install.ps1).
2. Save both files in the same folder.
3. Open **Windows PowerShell** in that folder.
4. Review the scripts, then run:

   ```powershell
   .\setup-latex-install.ps1
   ```

5. Follow the setup script's prompts, if any. Open a new PowerShell session if instructed.
6. Install the package:

   ```powershell
   latex-install urlfigure -Force
   ```

If PowerShell blocks script execution, review your organization's execution policy before making any changes. Avoid disabling script security globally merely to install this package.

### Option C: Manual installation

Download these two files:

- [`urlfigure.sty`](https://github.com/rafiq1506/my-latex-packages/blob/main/urlfigure.sty)
- [`urlfigure-fetch-v13.ps1`](https://github.com/rafiq1506/my-latex-packages/blob/main/urlfigure-fetch-v13.ps1)

Place them in the same directory under your personal TeX tree, for example:

```text
C:\Users\YOUR_USERNAME\texmf\tex\latex\urlfigure\
├── urlfigure.sty
└── urlfigure-fetch-v13.ps1
```

Find your actual personal TeX directory with:

```powershell
kpsewhich -var-value=TEXMFHOME
```

Verify that TeX Live can find both files:

```powershell
kpsewhich urlfigure.sty
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

## 📖 Quick start

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

Figure~\ref{fig:kitten} shows the kitten.
Figure~\ref{fig:track} shows the tracking journey.

\end{document}
```

Open PowerShell in the folder containing `main.tex`, then run:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

The second compilation resolves cross-references.

## 🛠️ WinEdt: Enable `--shell-escape` for PDFLaTeX

**This setting is required** when compiling a `urlfigure` document through WinEdt. The package calls `urlfigure-fetch-v13.ps1` to download and cache images. Without unrestricted shell escape, that external command cannot run as intended.

### Step 1 — Open Execution Modes

1. Launch **WinEdt**.
2. Open **Options → Execution Modes**.
3. Find the **PDFLaTeX** (or **PDF TeX**) compiler settings. Names and tab placement can vary between WinEdt versions.

### Step 2 — Add the compiler switch

1. Find the **Switches**, **Command Line**, or equivalent arguments field for **PDFLaTeX**.
2. Add the following option, separated from any existing options by a space:

   ```text
   --shell-escape
   ```

3. **Keep your existing options** such as `--synctex=-1` and `--interaction=errorstopmode`.

For example, if your existing switches are:

```text
--synctex=-1 --interaction=errorstopmode
```

change them to:

```text
--shell-escape --synctex=-1 --interaction=errorstopmode
```

The resulting PDFLaTeX invocation may resemble:

```powershell
pdflatex.exe --shell-escape --synctex=-1 --interaction=errorstopmode main.tex
```

> **Important:** Enter only the additional switch in the compiler's switches/arguments field; do not replace the executable path or the whole WinEdt command definition. Configure the tool you actually use to compile (PDFLaTeX rather than a different build profile).

### Step 3 — Save and compile

1. Click **OK**, **Apply**, or **Save**, as appropriate for your WinEdt version.
2. Open your LaTeX document.
3. Compile with the configured **PDFLaTeX** command.

### Step 4 — Verify that shell escape is enabled

Create `shell-escape-test.tex`:

```latex
\documentclass{article}
\begin{document}

\ifnum\pdfshellescape=1
    Shell escape is fully enabled.
\else
    Shell escape is NOT fully enabled.
\fi

\end{document}
```

Compile it with **PDFLaTeX in WinEdt**. The PDF should display:

```text
Shell escape is fully enabled.
```

If it says shell escape is not fully enabled, check the WinEdt switches again and confirm that you are using the PDFLaTeX profile you edited.

### Alternative: Compile outside WinEdt

You can compile directly in PowerShell without changing WinEdt settings:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

> **Security:** `--shell-escape` permits LaTeX to execute external commands. Use it only for trusted `.tex` files and packages; disable it for untrusted documents. The shell-escape option does not itself make arbitrary downloaded content safe.

## 📝 Usage reference

```latex
\urlimage{https://example.com/image.jpg}
\urlimage[0.6\textwidth]{https://example.com/image.jpg}
```

A complete numbered figure:

```latex
\begin{urlfigure}
    \caption{Example Image}
    \label{fig:example}
    \urlimage[0.6\textwidth]{https://example.com/image.jpg}
\end{urlfigure}

Figure~\ref{fig:example} shows the example.
```

Use the optional width argument to control image size, for example `0.3\textwidth`, `0.5\textwidth`, or `\textwidth`.

## ☁️ Google Drive images

The downloader recognizes supported public Google Drive sharing URLs, for example:

```latex
\urlimage[0.6\textwidth]{https://drive.google.com/file/d/FILE_ID/view?usp=sharing}
```

To prepare a file:

1. Upload an image to Google Drive.
2. Select **Share**.
3. Set **General access** to **Anyone with the link** and permission to **Viewer**.
4. Copy the link and use it in `\urlimage`.

The downloader tries alternative Google Drive image-serving/download endpoints. Google may restrict some files or requests; public access does not guarantee that every Drive link will work.

## ⚡ Image caching

When the package first encounters an image URL, the PowerShell helper downloads it, checks its signature to identify JPEG, PNG, or PDF, and saves the result in `urlfigure-images/`.

On later compilations, it reuses the cached file if the stored source URL matches and the cached file has the expected format. This means **a remote image changed without a URL change will not necessarily refresh automatically**.

To refresh a specific image, remove its cached image and matching `.cache` metadata file. To refresh everything, delete the generated `urlfigure-images/` directory and compile again.

Example generated files:

```text
My-LaTeX-Project/
├── main.tex
├── main.pdf
├── main.aux
├── main.log
└── urlfigure-images/
    ├── urlimage-1.jpg
    ├── urlimage-2.png
    └── .metadata/              (hidden on Windows)
        ├── urlimage-1.cache
        └── urlimage-2.cache
```

The helper also creates short-lived `urlimage-N.tex` status files that tell LaTeX which image to include. The updated package removes these after successful inclusion; temporary `.download` files are also cleaned up. If compilation is interrupted, temporary files may remain.

## 🔍 Troubleshooting

### `Image download failed for urlimage-N`

- Check that the URL points to a supported, publicly accessible JPEG, PNG, or PDF image.
- Ensure the internet connection works.
- Confirm PDFLaTeX was started with `--shell-escape`.
- Confirm TeX Live can locate the helper:

  ```powershell
  kpsewhich -format=tex urlfigure-fetch-v13.ps1
  ```

- Review the PDFLaTeX log and any PowerShell error output.

### `Get-Item : Could not find item ...\.metadata`

Older installed copies of the downloader could fail when accessing the hidden metadata folder. The corrected helper includes:

```powershell
$folder = Get-Item -LiteralPath $metadataDir -Force -ErrorAction Stop
```

Reinstall the updated helper:

```powershell
latex-install urlfigure -Force
```

Check the installed file:

```powershell
$helper = kpsewhich -format=tex urlfigure-fetch-v13.ps1
Select-String -Path $helper -Pattern 'Get-Item -LiteralPath'
```

### `I can't find file 'main.tex'`

Make sure PowerShell is in the directory containing the document:

```powershell
Get-Location
dir *.tex
```

Then compile again from the correct directory.

### Figure references show `??`

Compile twice so LaTeX can resolve labels:

```powershell
pdflatex.exe --shell-escape main.tex
pdflatex.exe --shell-escape main.tex
```

### Images do not update

Remove the affected cached image and its corresponding `.cache` file, or delete the entire `urlfigure-images/` directory to rebuild the cache.

### WinEdt still does not download images

Confirm that **the exact build command you are running** has `--shell-escape` enabled. Test using `shell-escape-test.tex` from the WinEdt section. A setting applied to PDFLaTeX may not affect a separate PDFTeXify or other build profile.

### Old `.url` Internet Shortcut files appear

Older helper versions stored cache information in `.url` files. The v1.3 helper uses `.cache` files in a hidden `.metadata/` folder. After confirming that v1.3 works, obsolete `.url` files can be removed.

## 🔐 Security and limitations

- Compile **only trusted documents** with unrestricted `--shell-escape`.
- Review installer scripts before running them, especially scripts fetched from the internet.
- Use trusted image sources; image signature checks are not a security scanner.
- Remote URLs can fail because of access controls, rate limits, redirects, or network problems.
- The current downloader recognizes JPEG, PNG, and PDF signatures; formats such as SVG and WebP are not supported by this implementation.
- The package uses PowerShell and is intended for Windows. Other operating systems are not tested.

## 🆕 Version history

### v1.3 — October 2026

- Added a dedicated `urlfigure-images/` image cache.
- Added a hidden `.metadata/` directory with `.cache` URL metadata.
- Added cache reuse when the source URL is unchanged and the cached format is valid.
- Added cleanup of temporary download and LaTeX status files.
- Updated the external PowerShell downloader to `urlfigure-fetch-v13.ps1`.
- Fixed access to hidden metadata using `Get-Item -Force`.
- Expanded installation and WinEdt troubleshooting documentation.

### v1.2 — Previous version

- Earlier implementation of URL-based image downloading and Google Drive link support.
- Replaced by v1.3 for current installations.

## 👨‍💻 Maintainer

Maintained by **[rafiq1506](https://github.com/rafiq1506)**.

Repository: <https://github.com/rafiq1506/my-latex-packages>

If this package is useful, consider starring the repository or opening an issue with feedback.
