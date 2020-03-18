SHELL := bash
PYTHON_NAME = "rhasspy"
SERVICE_NAME = "rhasspy"
PACKAGE_NAME = "rhasspy"
RHASSPY_DIRS = $(shell cat RHASSPY_DIRS)
REQUIREMENTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements.txt)
REQUIREMENTS_DEV = $(shell find . -mindepth 2 -maxdepth 2 -type f -name requirements_dev.txt)
PYTHON_FILES = **/*.py
PIP_INSTALL ?= install
DOWNLOAD_DIR = download

.PHONY: venv update-bin dist sdist debian pyinstaller docker-alsa docker-pulseaudio docker-deploy docs clean

version := $(shell cat VERSION)
architecture := $(shell bash architecture.sh)

version_tag := "rhasspy/$(PACKAGE_NAME):$(version)"

ifneq (,$(findstring -dev,$(version)))
	DOCKER_TAGS = -t "rhasspy/$(PACKAGE_NAME):$(version)"
else
	DOCKER_TAGS = -t "rhasspy/$(PACKAGE_NAME):$(version)" -t "rhasspy/$(PACKAGE_NAME):latest"
endif

DOCKER_PLATFORMS = linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6

# -----------------------------------------------------------------------------

all: venv docs

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

docs:
	scripts/build-docs.sh

clean:
	rm -rf .venv/

# -----------------------------------------------------------------------------
# Testing
# -----------------------------------------------------------------------------

reformat:
	scripts/format-code.sh

check:
	scripts/check-code.sh

test:
	scripts/run-tests.sh

# -----------------------------------------------------------------------------
# Distribution
# -----------------------------------------------------------------------------

# Create source/binary/debian distribution files
dist: sdist debian

# Create source distribution
sdist:
	python3 setup.py sdist

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

# Build ALSA Docker image.
docker-alsa: requirements.txt requirements_dev.txt update-bin downloads docs
	docker build . -f Dockerfile.source.alsa \
    -t "rhasspy/$(SERVICE_NAME):$(version)" \
    -t "rhasspy/$(SERVICE_NAME):latest"

# Build PulseAudio Docker image.
docker-pulseaudio: requirements.txt requirements_dev.txt update-bin downloads docs
	docker build . -f Dockerfile.source.pulseaudio \
    -t "rhasspy/$(SERVICE_NAME):$(version)-pulseaudio" \
    -t "rhasspy/$(SERVICE_NAME):latest-pulseaudio"

docker-multiarch: docs
	scripts/build-with-docker.sh

docker-multiarch-deploy:
	docker push "$(version_tag)-amd64"
	docker push "$(version_tag)-armhf"
	docker push "$(version_tag)-aarch64"
	docker push "$(version_tag)-arm32v6"

docker-multiarch-manifest:
	docker manifest push --purge "$(version_tag)"
	docker manifest create --amend "$(version_tag)" \
      "$(version_tag)-amd64" \
      "$(version_tag)-armhf" \
      "$(version_tag)-aarch64"
	docker manifest annotate "$(version_tag)" "$(version_tag)-armhf" --os linux --arch arm
	docker manifest annotate "$(version_tag)" "$(version_tag)-aarch64" --os linux --arch arm64
	docker manifest push "$(version_tag)"

docker-multiarch-manifest-init:
	docker manifest create "$(version_tag)" \
      "$(version_tag)-amd64" \
      "$(version_tag)-armhf" \
      "$(version_tag)-aarch64"
	docker manifest annotate "$(version_tag)" "$(version_tag)-armhf" --os linux --arch arm
	docker manifest annotate "$(version_tag)" "$(version_tag)-aarch64" --os linux --arch arm64
	docker manifest push "$(version_tag)"

docker-deploy:
	docker login --username rhasspy --password "$$DOCKER_PASSWORD"
	docker buildx build . -f Dockerfile.source.alsa --platform $(DOCKER_PLATFORMS) --push $(DOCKER_TAGS)

# -----------------------------------------------------------------------------
# Debian
# -----------------------------------------------------------------------------

pyinstaller:
	scripts/build-pyinstaller.sh "${architecture}" "${version}"

debian:
	scripts/build-debian.sh "${architecture}" "${version}"

debian-satellite:
	scripts/build-debian-satellite.sh "${architecture}" "${version}"

# -----------------------------------------------------------------------------
# Downloads
# -----------------------------------------------------------------------------

downloads: $(DOWNLOAD_DIR)/snowboy-1.3.0.tar.gz $(DOWNLOAD_DIR)/pocketsphinx-python.tar.gz $(DOWNLOAD_DIR)/phonetisaurus-2019-$(architecture).tar.gz

# Download snowboy.
$(DOWNLOAD_DIR)/snowboy-1.3.0.tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	curl -sSfL -o $@ 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'

# Download Python Pocketsphinx library with no dependency on PulseAudio.
$(DOWNLOAD_DIR)/pocketsphinx-python.tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	curl -sSfL -o $@ 'https://github.com/synesthesiam/pocketsphinx-python/releases/download/v1.0/pocketsphinx-python.tar.gz'

# Download pre-built Phonetisaurus binaries.
$(DOWNLOAD_DIR)/phonetisaurus-2019-$(architecture).tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	curl -sSfL -o $@ "https://github.com/synesthesiam/docker-phonetisaurus/releases/download/v2019.1/phonetisaurus-2019-$(architecture).tar.gz"
