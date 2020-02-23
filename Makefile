SHELL := bash
PYTHON_NAME = "rhasspy"
SERVICE_NAME = "rhasspy"
RHASSPY_DIRS = $(shell cat RHASSPY_DIRS)
REQUIREMENTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements.txt)
REQUIREMENTS_DEV = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements_dev.txt)
PYTHON_FILES = **/*.py
PIP_INSTALL ?= install
DOWNLOAD_DIR = download

.PHONY: venv update-bin install-kaldi dist sdist debian pyinstaller docker-alsa docker-pulseaudio docker-downloads docs

version := $(shell cat VERSION)
architecture := $(shell bash architecture.sh)

# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------

reformat:
	scripts/format-code.sh $(PYTHON_FILES)

check:
	scripts/check-code.sh $(PYTHON_FILES)

# Gather non-Rhasspy requirements from all submodules.
# Rhasspy libraries will be used from the submodule source code.
requirements.txt: $(REQUIREMENTS)
	cat $^ | grep -v '^rhasspy' | sort | uniq > $@

# Gather development requirements from all submodules.
requirements_dev.txt: $(REQUIREMENTS_DEV)
	cat $^ | grep -v '^-e' | sort | uniq > $@
	echo 'mkdocs==1.0.4' >> $@

# Create virtual environment and install all (non-Rhasspy) dependencies.
venv: requirements.txt requirements_dev.txt update-bin downloads
	scripts/create-venv.sh

# Copy submodule scripts to shared bin directory.
update-bin:
	$(shell find . -mindepth 3 -maxdepth 3 -type f -name 'rhasspy-*' -path './rhasspy*/bin/*' -exec cp '{}' bin/ \;)
	chmod +x bin/*

# Create source/binary/debian distribution files
dist: sdist debian

# Create source distribution
sdist:
	python3 setup.py sdist

docs:
	scripts/build-docs.sh

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

# Build ALSA Docker image.
docker-alsa: downloads docs
	docker build . -f Dockerfile.source.alsa \
    -t "rhasspy/$(SERVICE_NAME):$(version)" \
    -t "rhasspy/$(SERVICE_NAME):latest"

# Build PulseAudio Docker image.
docker-pulseaudio: downloads docs
	docker build . -f Dockerfile.source.pulseaudio \
    -t "rhasspy/$(SERVICE_NAME):$(version)-pulseaudio" \
    -t "rhasspy/$(SERVICE_NAME):latest-pulseaudio"

# -----------------------------------------------------------------------------
# Debian
# -----------------------------------------------------------------------------

pyinstaller:
	scripts/build-pyinstaller.sh "${architecture}" "${version}"

debian:
	scripts/build-debian.sh "${architecture}" "${version}"

# -----------------------------------------------------------------------------
# Downloads
# -----------------------------------------------------------------------------

downloads: $(DOWNLOAD_DIR)/snowboy-1.3.0.tar.gz $(DOWNLOAD_DIR)/pocketsphinx-python.tar.gz

# Download snowboy.
$(DOWNLOAD_DIR)/snowboy-1.3.0.tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	curl -sSfL -o $@ 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'

# Download Python Pocketsphinx library with no dependency on PulseAudio.
$(DOWNLOAD_DIR)/pocketsphinx-python.tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	curl -sSfL -o $@ 'https://github.com/synesthesiam/pocketsphinx-python/releases/download/v1.0/pocketsphinx-python.tar.gz'
