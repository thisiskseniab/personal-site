SHELL := bash

BASEDIR=$(CURDIR)
OUTPUTDIR=$(BASEDIR)/public

S3_BUCKET=ksenia.dev

FILES := $(shell find $(OUTPUTDIR) -name '*.html')

help:
	@echo "Makefile for generating ksenia's website                           "
	@echo "                                                                   "
	@echo "Usage:                                                             "
	@echo "   make serve                       start server                   "
	@echo "   make publish                     generate website for publishing"
	@echo "   make s3_upload                   upload the web site via S3     "
	@echo "                                                                   "

serve:
	hugo server -D

publish:
	hugo

remove_dates:
	for FILE in $(FILES); do sed -i -e 's/<span class="date">.*<\/span>//g' $$FILE ; done

remove_full_story:
	sed -i -e 's|<li><a href="https://www.ksenia.dev/post/about-me.html" class="button big">Full Story</a></li>||g' $(OUTPUTDIR)/index.html

s3_upload: publish remove_dates remove_full_story
	aws s3 sync --delete $(OUTPUTDIR)/ s3://$(S3_BUCKET) --acl public-read

.PHONY: publish s3_upload
