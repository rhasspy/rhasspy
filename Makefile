SHELL := bash
RHASSPY_DIRS = $(shell cat RHASSPY_DIRS)
REQUIREMENTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements.txt)

.PHONY: venv update-bin install-kaldi dist sdist debian pyinstaller docker

version := $(shell cat VERSION)
architecture := $(shell dpkg-architecture | grep DEB_BUILD_ARCH= | sed 's/[^=]\+=//')

debian_package := rhasspy-voltron_$(version)_$(architecture)
debian_dir := debian/$(debian_package)

requirements.txt: $(REQUIREMENTS)
	echo 'hbmqtt==0.9.5' > $@
	cat $^ | grep -v '^rhasspy-' | sort | uniq >> $@

venv: requirements.txt snowboy-1.3.0.tar.gz update-bin
	rm -rf .venv/
	python3 -m venv .venv
	.venv/bin/pip3 install wheel setuptools
	.venv/bin/pip3 install -r requirements.txt
	.venv/bin/pip3 install snowboy-1.3.0.tar.gz
	.venv/bin/pip3 install -r requirements_dev.txt

update-bin:
	$(shell find . -mindepth 3 -maxdepth 3 -type f -name 'rhasspy-*' -path '*/bin/*' -exec cp '{}' bin/ \;)
	chmod +x bin/*

update-web:
	rm -rf web
	cd rhasspy-web-vue && make && mv dist ../web

install-kaldi: rhasspy-asr-kaldi/kaldiroot
	cd rhasspy-asr-kaldi && ../.venv/bin/python3 kaldi_setup.py install

snowboy-1.3.0.tar.gz:
	curl -sSfL -o $@ 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'

dist: sdist debian

sdist:
	python3 setup.py sdist

pyinstaller:
	mkdir -p dist
	pyinstaller -y --workpath pyinstaller/build --distpath pyinstaller/dist rhasspyvoltron.spec
	tar -C pyinstaller/dist -czf dist/rhasspy-voltron_$(version)_$(architecture).tar.gz rhasspyvoltron/

debian: pyinstaller
	mkdir -p dist
	rm -rf "$(debian_dir)"
	mkdir -p "$(debian_dir)/DEBIAN" "$(debian_dir)/usr/bin" "$(debian_dir)/usr/lib"
	cat debian/DEBIAN/control | version=$(version) architecture=$(architecture) envsubst > "$(debian_dir)/DEBIAN/control"
	cp debian/bin/* "$(debian_dir)/usr/bin/"
	cp -R pyinstaller/dist/rhasspyvoltron "$(debian_dir)/usr/lib/"
	cd debian/ && fakeroot dpkg --build "$(debian_package)"
	mv "debian/$(debian_package).deb" dist/

docker:
	docker build . -t "rhasspy/rhasspy-voltron:$(version)"
