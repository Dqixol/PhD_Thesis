#------------------------------------------------------------------------------
# Makefile to make atlas_physics documentation
#------------------------------------------------------------------------------

BASENAME1 = atlas_physics
BASENAME2 = atlas_hepphysics

.PHONY: clean cleanpdf

atlas_physics:
	make -f ../Makefile run_latexmk BASENAME=$(BASENAME1)

atlas_hepphysics:
	make -f ../Makefile run_latexmk BASENAME=$(BASENAME2)

clean:
	make -f ../Makefile clean

cleanpdf:
	-rm $(BASENAME1).pdf
	-rm $(BASENAME2).pdf

cleanall: clean cleanpdf
