FileName=design

$(FileName).pdf : $(FileName).tex
	pdflatex --file-line-error --shell-escape --synctex=1 $(FileName).tex
	pdflatex --file-line-error --shell-escape --synctex=1 $(FileName).tex

all:	$(FileName).pdf	

clear :
	-rm $(FileName).dvi
	-rm $(FileName).aux
	-rm $(FileName).log
	-rm $(FileName).pdf
	-rm $(FileName).toc
	-rm $(FileName).idx
	-rm $(FileName).ind
	-rm $(FileName).out
	-rm $(FileName).bbl
	-rm $(FileName).lof
	-rm $(FileName).lot
	-rm $(FileName).ilg
	-rm $(FileName).blg
	-rm $(FileName).synctex.gz

