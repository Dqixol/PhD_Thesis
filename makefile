DOCKER := $(shell command -v docker)
ifndef DOCKER
LATEXMK := latexmk
else
LATEXMK := docker run -it --rm -v $(PWD):/workdir texlive/texlive latexmk
endif

all: 
	@$(LATEXMK) -cd -pdf src/thesis.tex -jobname=thesis -auxdir=.aux -outdir=../
	@make wordcount

open: 
	# open src/thesis.pdf
	# osascript -e 'tell application "Preview" to activate'
	# osascript -e 'tell application "Preview" to set bounds of (every window whose name is "thesis.pdf") to {0, 0, 1200, 1000}'

close:
	osascript -e 'tell application "Preview" to close (every window whose name is "thesis.pdf")'

clean:
	@rm -rf src/.aux
	@find src -type d -exec mkdir -p .aux/{} \;
	@cp -r .aux/src/ src/.aux
	@rm -rf .aux

wordcount:
	@echo "Word count: "
	@cd src; texcount -1 -sum -merge thesis.tex; cd ..