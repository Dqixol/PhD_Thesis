# Makefile for creating ATLAS Acknowledegments

PDFLATEX = pdflatex
BIBTEX   = biber

BASENAME = Acknowledgements-main

.PHONY: clean cleanpdf

run_pdflatex: $(BASENAME).pdf
	@echo "Made $<"

# Change biblatex backend
bibtex: $(BASENAME).tex
	if [ $(BIBTEX) = 'biber' -o $(BIBTEX) = 'bibtex' ]; then \
	  echo "Changing biblatex backend in $<"; \
	  sed -i'.bak' -e 's/backend=biber/backend=$(BIBTEX)/' -e 's/backend=bibtex/backend=$(BIBTEX)/' $<; \
	else echo "Invalid value for BIBTEX: $(BIBTEX)"; fi; \

# Standard LaTeX targets
$(BASENAME).pdf: $(BASENAME).tex
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

%.bbl: %.tex *.bib
	$(PDFLATEX) $*
	$(BIBTEX) $*

clean:
	-rm *.toc *.aux *.log *.out *.blg *.bbl *.bcf *-blx.bib \
	 *.run.xml *.synctex.gz *-SAVE-ERROR *~ *.fls *.fdb_latexmk .*.lb spellTmp 

cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
