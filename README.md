# Dependencies

make sure to have installed:

- [`pandoc`](https://github.com/jgm/pandoc/blob/master/INSTALL.md) 
- [eisvogel template](https://github.com/Wandmalfarbe/pandoc-latex-template).

Additional tex packages might be needed depending on your system. Arch based system users may find all necessary packages in `aur`

- texlive-core 
- texlive-fontsextra
- texlive-latexextra
- texlive-science

- `Make` is also recommended to make building easy, but not required.


# Building

```console
$ git clone https://github.com/JoakimOL/Infosec-notes.git
$ cd Infosec-notes
$ make
```

This should produce a pdf called `infosec.pdf`
