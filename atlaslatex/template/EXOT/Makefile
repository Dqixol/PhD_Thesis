#------------------------------------------------------------------------------
# Makefile to make EXOT templates document
#------------------------------------------------------------------------------

BASENAME = EXOT_template

.PHONY: clean cleanpdf

EXOT_template:
	make -f ../../doc/Makefile run_latexmk BASENAME=$(BASENAME)

clean:
	make -f ../../doc/Makefile clean
	
cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
	