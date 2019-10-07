# Dependencies

make sure to have installed:

- [`pandoc`](https://github.com/jgm/pandoc/blob/master/INSTALL.md)
- [`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref)
- [eisvogel template](https://github.com/Wandmalfarbe/pandoc-latex-template)
- `Make` is recommended to make building easy, but not required.


## Required latex packages
Additional tex packages might be needed depending on your system.

### Arch based systems  (Aur)
Arch based system users may find all necessary packages in `aur`

- texlive-core
- texlive-fontsextra
- texlive-latexextra
- texlive-science

### Ubuntu/debian (apt)
using `apt`, install these packages and you should be good.

- texlive-latex-base
- texlive-latex-extra
- texlive-science
- texlive-fonts-extra

## pandoc-crossref
The `pandoc-crossref` is just for making the document easier to navigate. The document will compile if you remove the `-F pandoc-crossref` part in the `makefile`, but it will leave references looking like "@sec:authencryption:modes" in the document.

To install, go to the link above and download the latest release for your system. This will be either a zip-file or a tarball containing an executable. Unpack it in the same directory as this repo and it should work


# Building
assuming you have followed the instructions of this file and of the links above, building should be simple enough:

```console
$ git clone https://github.com/JoakimOL/Infosec-notes.git
$ cd Infosec-notes
$ make
```

This should produce a pdf called `infosec.pdf`
