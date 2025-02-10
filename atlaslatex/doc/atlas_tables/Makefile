#------------------------------------------------------------------------------
# Makefile to make atlas_tables documentation
#------------------------------------------------------------------------------

BASENAME = atlas_tables

.PHONY: clean cleanpdf

atlas_tables:
	make -f ../Makefile run_latexmk BASENAME=$(BASENAME); \

clean:
	make -f ../Makefile clean
	
cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
	