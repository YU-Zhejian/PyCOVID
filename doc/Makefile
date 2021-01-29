.PHONY : all clean distclean
all: main.pdf

main.pdf:main.tex
	pdflatex -verbose main
	bibtex main
	pdflatex -verbose main
	pdflatex -verbose main

clean:
	rm -f *.bbl *.aux *.dvi *.out *.log *.toc *.blg

distclean: clean
	rm -f *.pdf
