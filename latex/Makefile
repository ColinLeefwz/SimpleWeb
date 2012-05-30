FileName=design

$(FileName).pdf : $(FileName).tex
	pdflatex --file-line-error --shell-escape --synctex=1 $(FileName).tex
	pdflatex --file-line-error --shell-escape --synctex=1 $(FileName).tex

all:	$(FileName).pdf	

clear :
	-rm *.dvi
	-rm *.aux
	-rm *.log
	-rm *.toc
	-rm *.idx
	-rm *.ind
	-rm *.out
	-rm *.bbl
	-rm *.lof
	-rm *.lot
	-rm *.ilg
	-rm *.blg
	-rm *.synctex.gz

