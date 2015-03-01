
.PHONY: vimhelp.epub

vimhelp.mobi: vimhelp.epub
	kindlegen -dont_append_source $<

vimhelp.epub:
	cd vimhelp.epub.src && zip -r ../vimhelp.epub .


txt2html:
	/usr/share/vim/vim73/doc/vim2html.pl /usr/share/vim/vim73/doc/tags /usr/share/vim/vim73/doc/*.txt

opf:
	mkdir -p tmp
	sed 's/["#]/\n/g' help.html | awk '/\.html$$/ {if(!($$1 in lut)) print $$1; lut[$$1]++}' > tmp/help.list
	ls -1 *.html | sort > tmp/html.list
	sort tmp/help.list  > tmp/help.sort.list
	-@ diff tmp/html.list tmp/help.sort.list
	cat tmp/help.list | awk '{printf "<item id=\"%s\" href=\"%s\" media-type=\"application/xhtml+xml\"/>\n",$$1,$$1}' > tmp/opf.manifest
	cat tmp/help.list | awk '{printf "<itemref idref=\"%s\"/>\n",$$1}' > tmp/opf.spine

clean:
	rm -rf tmp


