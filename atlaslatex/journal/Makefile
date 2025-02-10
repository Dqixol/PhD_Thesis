# Makefile for creating an ATLAS paper draft using journal classes

PDFLATEX = pdflatex
BIBTEX   = bibtex
OPEN     = open

TEXFILES = $(wildcard *.tex)

.PHONY: clean

all: atlas-elsevier atlas-jhep atlas-jinst atlas-revtex

atlas-elsevier: atlas-elsevier.pdf
	@echo "Made $<"
	# $(OPEN) $<

atlas-jhep: atlas-jhep.pdf
	@echo "Made $<"
	# $(OPEN) $<

atlas-jinst: atlas-jinst.pdf
	@echo "Made $<"
	# $(OPEN) $<

atlas-revtex: atlas-revtex.pdf
	@echo "Made $<"
	# $(OPEN) $<

# Standard LaTeX targets
%.pdf: %.tex *.bib
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	-rm *.toc *.aux *.log *.out *.blg *.bbl *.bcf \
	 *.fdb_latexmk *.spl *-revtexNotes.bib *.run.xml *.synctex.gz *-SAVE-ERROR *~

cleanall: clean
	-rm *.pdf
