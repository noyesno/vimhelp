
basedir  = $(abspath $(dir $(MAKEFILE_LIST)))

vim2html = $(basedir)/bin/vim2html.pl
vimdoc   = $(basedir)/vim/runtime/doc

help:
	@echo $(basedir)

#-------------------------------------------------------
# Usage: 
#
#    mkdir build 
#    make -C build ../Makefile vimhelp.epub 
#-------------------------------------------------------

build:
	mkdir build
	$(MAKE) -C build ../Makefile vimhelp.epub 

vimhelp.vfs:
	cp -r ../$@ $@
	cp -r vimhelp vimhelp.vfs
	$(basedir)/bin/epub.tcl vimhelp.vfs/content.opf.tclexp > vimhelp.vfs/content.opf
	$(basedir)/bin/epub.tcl vimhelp.vfs/toc.ncx.tclexp     > vimhelp.vfs/toc.ncx

vimhelp.epub: vimhelp vimhelp.list vimhelp.vfs
	cd vimhelp.vfs && zip -r ../$@ .

vimhelp.mobi: vimhelp.epub
	kindlegen -dont_append_source $<

vimhelp:
	mkdir -p vimhelp
	cd vimhelp && $(vim2html) $(vimdoc)/tags $(vimdoc)/*.txt

vimhelp.list:
	sed 's/["#]/\n/g' ./vimhelp/help.html \
	   | awk '/\.html$$/ {if(!($$1 in lut)) printf "vimhelp/%s\n", $$1; lut[$$1]++}' > vimhelp.list


clean:
	rm -rf build 


