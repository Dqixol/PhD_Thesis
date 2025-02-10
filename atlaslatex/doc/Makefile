# Makefile for creating documentation for ATLAS LaTeX.
# Usually called from a subdirectory.

TWEAKYEAR = 2020
PDFLATEX  = pdflatex
BIBTEX    = biber
BASENAME  = dummy

.PHONY: clean cleanpdf

# Remove -pdf option to run latex instead of pdflatex.
run_latexmk:
	latexmk -pdf $(BASENAME)

run_pdflatex: $(BASENAME).pdf
	@echo "Made $<"

# Change year for tweaks.
tweakyear: $(BASENAME).tex
	if [ $(TWEAKYEAR) -ge 2013 -a $(TWEAKYEAR) -lt 2100 ]; then \
	  echo "Changing tweak year in $<"; \
	  sed -i'.bak' 's/AtlasTweakYear}{20[0-9][0-9]/AtlasTweakYear}{$(TWEAKYEAR)/' $<; \
	else echo "Invalid value for TWEAKYEAR: $(TWEAKYEAR)"; fi;

# Standard LaTeX targets.
$(BASENAME).pdf: $(BASENAME).tex
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	-rm *.toc *.aux *.log *.out *.blg *.bbl *.bcf *-blx.bib \
	 *.run.xml *.synctex.gz *-SAVE-ERROR *.fls *.fdb_latexmk *.listing \
	 .*.lb *~

cleanpdf:
	-rm $(BASENAME).pdf
