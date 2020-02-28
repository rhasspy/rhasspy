SHELL := bash
PACKAGE_NAME = $(shell basename "$$PWD")
PYTHON_NAME = $(shell echo "$(PACKAGE_NAME)" | sed -e 's/-//' | sed -e 's/-/_/g')
SOURCE = $(PYTHON_NAME)
PYTHON_FILES = $(SOURCE)/*.py *.py
SHELL_FILES = bin/* debian/bin/* *.sh
PIP_INSTALL ?= install
DOWNLOAD_DIR = download

.PHONY: reformat check dist venv pyinstaller debian docker deploy docker-multiarch docker-multiarch-deploy docker-multiarch-manifest docker-multiarch-manifest-init downloads

version := $(shell cat VERSION)
architecture := $(shell bash architecture.sh)

version_tag := "rhasspy/$(PACKAGE_NAME):$(version)"

DOCKER_PLATFORMS = linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6

ifneq (,$(findstring -dev,$(version)))
	DOCKER_TAGS = -t "$(version_tag)"
else
	DOCKER_TAGS = -t "$(version_tag)" -t "rhasspy/$(PACKAGE_NAME):latest"
endif

# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------

reformat:
	scripts/format-code.sh $(PYTHON_FILES)

check:
	scripts/check-code.sh $(PYTHON_FILES)

venv: downloads
	scripts/create-venv.sh

dist: sdist

sdist:
	python3 setup.py sdist

test:
	scripts/run-tests.sh

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------


docker:
	docker build . -t "rhasspy/$(PACKAGE_NAME):$(version)" -t "rhasspy/$(PACKAGE_NAME):latest"

docker-multiarch:
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
      "$(version_tag)-aarch64" \
      "$(version_tag)-arm32v6"
	docker manifest annotate "$(version_tag)" "$(version_tag)-armhf" --os linux --arch arm
	docker manifest annotate "$(version_tag)" "$(version_tag)-aarch64" --os linux --arch arm64
	docker manifest annotate "$(version_tag)" "$(version_tag)-arm32v6" --os linux --arch arm32v6
	docker manifest push "$(version_tag)"

docker-multiarch-manifest-init:
	docker manifest create "$(version_tag)" \
      "$(version_tag)-amd64" \
      "$(version_tag)-armhf" \
      "$(version_tag)-aarch64" \
      "$(version_tag)-arm32v6"
	docker manifest annotate "$(version_tag)" "$(version_tag)-armhf" --os linux --arch arm
	docker manifest annotate "$(version_tag)" "$(version_tag)-aarch64" --os linux --arch arm64
	docker manifest annotate "$(version_tag)" "$(version_tag)-arm32v6" --os linux --arch arm32v6
	docker manifest push "$(version_tag)"

docker-pyinstaller: pyinstaller
	docker build . -f Dockerfile.pyinstaller -t "rhasspy/$(PACKAGE_NAME):$(version)" -t "rhasspy/$(PACKAGE_NAME):latest"

deploy:
	docker login --username rhasspy --password "$$DOCKER_PASSWORD"
	docker buildx build . --platform $(DOCKER_PLATFORMS) --push $(DOCKER_TAGS)

# -----------------------------------------------------------------------------
# Debian
# -----------------------------------------------------------------------------

pyinstaller:
	scripts/build-pyinstaller.sh "${architecture}" "${version}"

debian:
	scripts/build-debian.sh "$(architecture)" "$(version)"

# -----------------------------------------------------------------------------
# Downloads
# -----------------------------------------------------------------------------

# Rhasspy development dependencies
RHASSPY_DEPS := $(shell grep '^rhasspy-' requirements.txt | sort | comm -3 - rhasspy_wheels.txt | sed -e 's|^|$(DOWNLOAD_DIR)/|' -e 's/==/-/' -e 's/$$/.tar.gz/')

$(DOWNLOAD_DIR)/%.tar.gz:
	mkdir -p "$(DOWNLOAD_DIR)"
	scripts/download-dep.sh "$@"

downloads: $(RHASSPY_DEPS)
