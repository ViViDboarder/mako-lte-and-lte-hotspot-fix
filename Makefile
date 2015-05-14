.PHONY: zip

version=$(shell git describe --tags --dirty --always)
filename=nexus-4-lte-enabler-v$(version).zip

zip:
	zip -r $(filename) . -x \*.git\* -x Makefile
	md5sum $(filename) > $(filename).md5

clean:
	rm -f $(filename)
	rm -f $(filename).md5
