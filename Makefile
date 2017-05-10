# Makefile

all:
	mkdocs build
	
run:
	mkdocs serve

publish: all
	git add .
	git commit -m "update website" .
