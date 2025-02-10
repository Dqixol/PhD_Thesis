#------------------------------------------------------------------------------
# Makefile to make EXOT templates document
#------------------------------------------------------------------------------

BASENAME = SUSY_template

.PHONY: clean cleanpdf

SUSY_template:
	make -f ../../doc/Makefile run_latexmk BASENAME=$(BASENAME)

clean:
	make -f ../../doc/Makefile clean
	
cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
	