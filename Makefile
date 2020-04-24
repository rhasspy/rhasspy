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

.PHONY: venv update-bin dist sdist debian pyinstaller docker-alsa docker-deploy docs clean check-dirs

version := $(shell cat VERSION)
architecture := $(shell bash architecture.sh)

version_tag := "rhasspy/$(PACKAGE_NAME):$(version)"

ifneq (,$(findstring -dev,$(version)))
	DOCKER_TAGS = -t "rhasspy/$(PACKAGE_NAME):$(version)"
else
	DOCKER_TAGS = -t "rhasspy/$(PACKAGE_NAME):$(version)" -t "rhasspy/$(PACKAGE_NAME):latest"
endif

DOCKER_PLATFORMS = linux/amd64,linux/arm64,linux/arm/v7

# -----------------------------------------------------------------------------

all: venv docs

check-dirs:
	scripts/ensure-checkout.sh

# Gather non-Rhasspy requirements from all submodules.
# Rhasspy libraries will be used from the submodule source code.
requirements.txt: $(REQUIREMENTS)
	cat $^ | grep -v '^rhasspy' | grep -v '^snips' | sort | uniq > $@

# Gather development requirements from all submodules.
requirements_dev.txt: $(REQUIREMENTS_DEV)
	cat $^ | grep -v '^-e' | sort | uniq > $@
	echo 'mkdocs==1.0.4' >> $@

# Create virtual environment and install all dependencies.
venv: check-dirs requirements.txt requirements_dev.txt update-bin downloads
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

deploy: downloads
	docker login --username rhasspy --password "$$DOCKER_PASSWORD"
	docker buildx build . -f Dockerfile.source.alsa --platform $(DOCKER_PLATFORMS) --push $(DOCKER_TAGS)

deploy-satellite: downloads
	docker login --username rhasspy --password "$$DOCKER_PASSWORD"
	docker buildx build . -f Dockerfile.source.alsa.pizero --platform linux/arm/v6 --push "rhasspy/rhasspy:$(version)-arm32v6"

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

downloads:
	scripts/download-deps.sh
