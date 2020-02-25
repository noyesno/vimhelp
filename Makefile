
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

vimhelp.epub: txt2html vimhelp.opf
	cd vimhelp && zip -r ../vimhelp.epub .

vimhelp.mobi: vimhelp.epub
	kindlegen -dont_append_source $<

txt2html:
	mkdir -p vimhelp
	cd vimhelp && $(vim2html) $(vimdoc)/tags $(vimdoc)/*.txt

vimhelp.opf:
	sed 's/["#]/\n/g' ./vimhelp/help.html \
	   | awk '/\.html$$/ {if(!($$1 in lut)) print $$1; lut[$$1]++}' > help.list
	cat help.list \
	   | awk 'BEGIN {print "<manifest>"} END {print "</manifest>"} {printf "<item id=\"%s\" href=\"%s\" media-type=\"application/xhtml+xml\"/>\n",$$1,$$1}' \
	     > vimhelp.manifest
	cat help.list \
	   | awk 'BEGIN {print "<spine toc=\"ncx\">"} END {print "</spine>"}{printf "<itemref idref=\"%s\"/>\n",$$1}' \
	     > vimhelp.spine
	sed -e '/<manifest/,/<\/manifest/ d' \
	    -e '/<spine/,/<\/spine/ d' \
	    -e '/include vimhelp.manifest/ r vimhelp.manifest' \
	    -e '/include vimhelp.spine/ r vimhelp.spine' \
	    ../vimhelp.epub/vimhelp.opf \
	    > vimhelp/vimhelp.opf


clean:
	rm -rf build 


