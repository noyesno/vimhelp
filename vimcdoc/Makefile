
epub2mobi html.mobi : html.epub
	- kindlegen -dont_append_source $<
	ls -l html.mobi

html2epub html.epub :
	cd html && zip -r ../html.epub .

vim2html:
	mkdir -p html
	cd html && ../../bin/vim2html.pl ../doc/tags-cn ../doc/*.txt

fixdoc:
	cd doc  && for file in *.cnx ; do mv $$file $${file/.cnx/.txt} ; done
	sed -i 's/.cnx/.txt/' doc/tags-cn
