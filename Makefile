SHELL := bash
RHASSPY_DIRS = $(shell cat RHASSPY_DIRS)
REQUIREMENTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements.txt)

.PHONY: venv update-bin install-kaldi

requirements.txt: $(REQUIREMENTS)
	echo 'hbmqtt==0.9.5' > $@
	cat $^ | grep -v '^rhasspy-' | sort | uniq >> $@

venv: requirements.txt snowboy-1.3.0.tar.gz
	rm -rf .venv/
	python3 -m venv .venv
	.venv/bin/pip3 install wheel setuptools
	.venv/bin/pip3 install -r requirements.txt
	.venv/bin/pip3 install snowboy-1.3.0.tar.gz
	.venv/bin/pip3 install -r requirements_dev.txt

update-bin:
	$(shell find . -mindepth 3 -maxdepth 3 -type f -name 'rhasspy-*' -path '*/bin/*' -exec cp '{}' bin/ \;)
	chmod +x bin/*

install-kaldi: rhasspy-asr-kaldi/kaldiroot
	cd rhasspy-asr-kaldi && ../.venv/bin/python3 kaldi_setup.py install

snowboy-1.3.0.tar.gz:
	curl -sSfL -o $@ 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'
