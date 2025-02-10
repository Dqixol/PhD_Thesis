#------------------------------------------------------------------------------
# Makefile to make atlas_latex documentation
#------------------------------------------------------------------------------

BASENAME = atlas_latex
TWEAKYEAR = 2020

.PHONY: clean cleanpdf

atlas_latex:
	make -f ../Makefile run_latexmk BASENAME=$(BASENAME)

tweakyear:
	make -f ../Makefile tweakyear BASENAME=$(BASENAME) TWEAKYEAR=$(TWEAKYEAR)

clean:
	make -f ../Makefile clean
	
cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
