# My LaTeX Packages

Custom LaTeX packages and Windows installation utilities maintained by [rafiq1506](https://github.com/rafiq1506).

## Available packages

| Package | Version | Purpose |
| --- | --- | --- |
| [`urlfigure`](#urlfigure-v13) | v1.3 | Insert remote images from public URLs and Google Drive sharing links. |
| [`code`](#code-v11) | v1.1 | Display source code with automatic line numbers and customizable `listings` formatting. |

## Repository files

| File | Purpose |
| --- | --- |
| `README.md` | Package documentation |
| `urlfigure.sty` | Remote-image LaTeX package |
| `urlfigure-fetch-v13.ps1` | PowerShell image downloader and cache manager |
| `code.sty` | Code-listing LaTeX package |
| `latex-install.ps1` | Package installation/update utility (check supported package names) |
| `setup-latex-install.ps1` | One-time setup for the `latex-install` command |

> Add `code.sty` to the repository root before following its GitHub download instructions. The current installer must explicitly support `code` before `latex-install code -Force` can be used.

## Installation

### Requirements

- Windows 10/11 and TeX Live (tested with TeX Live 2026) for the provided PowerShell tooling.
- PDFLaTeX and Windows PowerShell 5.1 or later for `urlfigure`.
- The `code` package requires the standard LaTeX packages `listings` and `xcolor`; it does **not** require PowerShell, an internet connection, or shell escape at compile time.
- `urlfigure` requires internet access for uncached images and **unrestricted `--shell-escape`** when downloading them. Use this only with trusted documents.

### Install `urlfigure` using `latex-install`

If you already configured the command:

```powershell
latex-install urlfigure -Force
latex-install urlfigure -Verify
```

First-time setup: download `setup-latex-install.ps1` and `latex-install.ps1` from this repository into the same folder, review them, then run:

```powershell
.\setup-latex-install.ps1
latex-install urlfigure -Force
```

Open a new PowerShell window after setup if necessary. Avoid changing your system-wide execution policy merely to run an installer.

### Install `code` directly from GitHub (no manual download)

On another Windows PC with TeX Live or MiKTeX installed, open **PowerShell** and run this single command. It downloads `code.sty` directly from this repository and installs it in your personal TeX directory:

```powershell
$dir = "$HOME\texmf\tex\latex\code"; New-Item -ItemType Directory -Force -Path $dir | Out-Null; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rafiq1506/my-latex-packages/main/code.sty" -OutFile "$dir\code.sty"
```

This assumes `code.sty` is present at the **root of the `main` branch**. The PC needs internet access for installation, but not for using the package afterward. The command replaces any existing `code.sty` at that destination.

Verify that LaTeX can find it:

```powershell
kpsewhich code.sty
```

Expected output is a path similar to `C:/Users/YourUsername/texmf/tex/latex/code/code.sty`. If nothing is returned, try refreshing the filename database with `mktexlsr` (TeX Live) or the corresponding MiKTeX refresh command, then verify again.

After installation, add `\usepackage{code}` to your LaTeX document's preamble. You do **not** need to download or copy `code.sty` manually.

### Install `code` manually (works without installer changes)

Download [`code.sty`](https://github.com/rafiq1506/my-latex-packages/blob/main/code.sty) and save it to your Downloads folder. Then run:

```powershell
$texmf = kpsewhich -var-value=TEXMFHOME
$destination = Join-Path $texmf 'tex\latex\code'
New-Item -ItemType Directory -Force -Path $destination | Out-Null
Copy-Item "$HOME\Downloads\code.sty" (Join-Path $destination 'code.sty') -Force
kpsewhich code.sty
```

If `kpsewhich` prints nothing, refresh the filename database (for example, `mktexlsr` with TeX Live) and retry. You can also place `code.sty` beside your `.tex` document for project-local use.

**Future installer integration:** Once `latex-install.ps1` has been updated to recognize `code` and fetch `code.sty`, the intended commands will be:

```powershell
latex-install code -Force
latex-install code -Verify
```

These commands are **not guaranteed to work with the current installer**.

### Verify the installed packages

```powershell
kpsewhich urlfigure.sty
kpsewhich -format=tex urlfigure-fetch-v13.ps1
kpsewhich code.sty
```

Each installed file should resolve to an actual path, typically under `%USERPROFILE%\texmf\tex\latex\`.

---

## `code` v1.1

The `code.sty` package defines a reusable `code` environment using LaTeX's `listings` package. Include it once:

```latex
\usepackage{code}
```

### Features

- Line numbering on the left, starting at 1 for each block.
- Light-gray background and thin frame.
- Monospaced text, preserved indentation, and automatic line wrapping.
- Syntax highlighting for supported `listings` languages.
- Per-block customization through optional `listings` keys.
- Verbatim rendering of LaTeX source without evaluating its commands.

### Complete example

```latex
\documentclass[12pt,a4paper]{article}
\usepackage{code}

\begin{document}

\section{LaTeX Source}
\begin{code}
\[
    \sqrt{\frac{x^2+\sqrt{5}}{2^3}}
\]
\end{code}

\section{Python}
\begin{code}[language=Python]
def square(x):
    return x**2

print(square(5))
\end{code}

\section{C}
\begin{code}[language=C]
#include <stdio.h>

int main() {
    printf("Hello World!");
    return 0;
}
\end{code}

\end{document}
```

### Override formatting for one block

Show line numbers (enabled by default):

```latex
\begin{code}[language=Python,numbers=left]
print("Hello")
\end{code}
```

Hide line numbers or remove the border:

```latex
\begin{code}[numbers=none,frame=none]
Some literal source text
\end{code}
```

Change the starting number:

```latex
\begin{code}[firstnumber=10]
first line
second line
\end{code}
```

> `code` is a verbatim-style environment: put `\begin{code}` and `\end{code}` on their own lines. It displays LaTeX source literally; it does not render the mathematics inside the block. Language names must be recognized by the `listings` package.

---

## `urlfigure` v1.3

Insert online JPEG, PNG, or PDF images into LaTeX, including supported publicly accessible Google Drive sharing links.

### Features

- `\urlimage[WIDTH]{URL}` for images from public URLs.
- JPEG/PNG/PDF detection from downloaded content.
- Cache in `urlfigure-images/` with URL metadata in the hidden `.metadata/` directory.
- Captions, labels, and cross-references with standard LaTeX commands.
- Cleanup of temporary downloader and status files after successful processing.

### Quick start

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

Figure~\ref{fig:kitten} shows the kitten.
\end{document}
```

Compile twice to resolve references:

```powershell
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
pdflatex.exe --shell-escape --interaction=errorstopmode main.tex
```

### Google Drive images

Set the image file's general access to **Anyone with the link → Viewer**, then use its sharing link:

```latex
\urlimage[0.6\textwidth]{https://drive.google.com/file/d/FILE_ID/view?usp=sharing}
```

Google may restrict certain requests, so public sharing does not guarantee every Drive link will work.

### WinEdt: Enable shell escape

In **Options → Execution Modes**, locate the PDFLaTeX compiler's switches/arguments and add `--shell-escape`, retaining existing switches. For example:

```text
--shell-escape --synctex=-1 --interaction=errorstopmode
```

Save and compile using that PDFLaTeX profile. Other profiles (such as PDFTeXify) may require separate configuration.

**Security:** `--shell-escape` allows external commands. Enable it only for trusted documents; the `code` package does not need it.

### Image caching

On first use, the downloader saves the image under `urlfigure-images/`. Later compilations reuse the cache if the URL and cached format still match. A changed remote image at the same URL may not refresh automatically. To refresh, remove the corresponding cached image and `.cache` metadata, or delete the generated `urlfigure-images/` directory.

### Troubleshooting

**`Image download failed for urlimage-N`**: Check public URL access, internet connectivity, `--shell-escape`, and helper discovery:

```powershell
kpsewhich -format=tex urlfigure-fetch-v13.ps1
```

**Hidden `.metadata` folder error**: Reinstall v1.3 with `latex-install urlfigure -Force`; the corrected helper accesses hidden folders with `Get-Item -Force`.

**`I can't find file 'main.tex'`**: Run the compiler from the folder containing your document (`Get-Location` and `dir *.tex` help confirm this).

**Figure references show `??`**: Compile twice.

**Old `.url` files**: Earlier versions used `.url` metadata; v1.3 uses `.cache` files in `.metadata/`.

---

## Troubleshooting `code`

**`LaTeX Error: File 'code.sty' not found`**: Confirm that `kpsewhich code.sty` returns the installed path. Ensure the package file is actually named `code.sty` (not `code.sty.txt`).

**No line numbers**: Check that the installed file is v1.1 and contains `numbers=left`; remove a block-specific `numbers=none` override. Recompile after replacing the installed file.

**No syntax highlighting**: Specify a supported language, such as `[language=Python]` or `[language=C]`. Plain text and LaTeX source can still be displayed without a language.

## Version history

### `code` v1.1 — October 22, 2026

- Enabled automatic left-side line numbering, restarting at 1 for each block.
- Added 7pt line-number separation and gray line-number text.
- Retained a light background, frame, line wrapping, and language overrides.

### `code` v1.0 — Initial release

- Introduced the `code` environment built on `listings`.

### `urlfigure` v1.3 — October 2026

- Added the image cache and hidden `.metadata/` directory.
- Added cached-file reuse and temporary-file cleanup.
- Updated downloader to `urlfigure-fetch-v13.ps1`.
- Fixed hidden-metadata access and expanded Windows/WinEdt instructions.

### `urlfigure` v1.2 — Previous release

- Earlier URL-based image downloading and Google Drive support.

## Maintainer

Maintained by **[rafiq1506](https://github.com/rafiq1506)**.

Repository: <https://github.com/rafiq1506/my-latex-packages>

Contributions, issues, and feedback are welcome.
