# -----------------------------------------------------------------------------
# Dockerfile for Rhasspy (https://github.com/rhasspy/rhasspy)
# Requires Docker buildx: https://docs.docker.com/buildx/working-with-buildx/
# See scripts/build-docker.sh
#
# Builds a multi-arch image for amd64/armv6/armv7/arm64.
# The virtual environment from the build stage is copied over to the run stage.
# The Rhasspy source code is then copied into the run stage and executed within
# that virtual environment.
#
# Build stages are named build-$TARGETARCH$TARGETVARIANT, so build-amd64,
# build-armv6, etc. Run stages are named similarly.
#
# armv6 images (Raspberry Pi 0/1) are derived from balena base images:
# https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images
#
# The IFDEF statements are handled by docker/preprocess.sh. These are just
# comments that are uncommented if the environment variable after the IFDEF is
# not empty.
#
# The build-docker.sh script will optionally add apt/pypi proxies running locally:
# * apt - https://docs.docker.com/engine/examples/apt-cacher-ng/ 
# * pypi - https://github.com/jayfk/docker-pypi-cache
# -----------------------------------------------------------------------------

# Build stage for amd64/armv7/arm64
FROM ubuntu:eoan as build-ubuntu

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
        python3 python3-dev python3-setuptools python3-pip python3-venv \
        build-essential swig libatlas-base-dev portaudio19-dev \
        curl ca-certificates

FROM build-ubuntu as build-amd64

FROM build-ubuntu as build-armv7

FROM build-ubuntu as build-arm64

# -----------------------------------------------------------------------------

# Build stage for armv6
FROM balenalib/raspberry-pi-debian-python:3.7-buster-build-20200604 as build-armv6

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN install_packages \
        swig libatlas-base-dev portaudio19-dev \
        curl ca-certificates

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM build-$TARGETARCH$TARGETVARIANT as build

ENV APP_DIR=/usr/lib/rhasspy
ENV BUILD_DIR=/build

# Directory of prebuilt tools
COPY download/ ${BUILD_DIR}/download/

# Copy Rhasspy module requirements
COPY rhasspy-server-hermes/requirements.txt ${BUILD_DIR}/rhasspy-server-hermes/
COPY rhasspy-wake-snowboy-hermes/requirements.txt ${BUILD_DIR}/rhasspy-wake-snowboy-hermes/
COPY rhasspy-wake-porcupine-hermes/requirements.txt ${BUILD_DIR}/rhasspy-wake-porcupine-hermes/
COPY rhasspy-wake-precise-hermes/requirements.txt ${BUILD_DIR}/rhasspy-wake-precise-hermes/
COPY rhasspy-profile/requirements.txt ${BUILD_DIR}/rhasspy-profile/
COPY rhasspy-asr/requirements.txt ${BUILD_DIR}/rhasspy-asr/
COPY rhasspy-asr-deepspeech/requirements.txt ${BUILD_DIR}/rhasspy-asr-deepspeech/
COPY rhasspy-asr-deepspeech-hermes/requirements.txt ${BUILD_DIR}/rhasspy-asr-deepspeech-hermes/
COPY rhasspy-asr-pocketsphinx/requirements.txt ${BUILD_DIR}/rhasspy-asr-pocketsphinx/
COPY rhasspy-asr-pocketsphinx-hermes/requirements.txt ${BUILD_DIR}/rhasspy-asr-pocketsphinx-hermes/
COPY rhasspy-asr-kaldi/requirements.txt ${BUILD_DIR}/rhasspy-asr-kaldi/
COPY rhasspy-asr-kaldi-hermes/requirements.txt ${BUILD_DIR}/rhasspy-asr-kaldi-hermes/
COPY rhasspy-dialogue-hermes/requirements.txt ${BUILD_DIR}/rhasspy-dialogue-hermes/
COPY rhasspy-fuzzywuzzy/requirements.txt ${BUILD_DIR}/rhasspy-fuzzywuzzy/
COPY rhasspy-fuzzywuzzy-hermes/requirements.txt ${BUILD_DIR}/rhasspy-fuzzywuzzy-hermes/
COPY rhasspy-hermes/requirements.txt ${BUILD_DIR}/rhasspy-hermes/
COPY rhasspy-homeassistant-hermes/requirements.txt ${BUILD_DIR}/rhasspy-homeassistant-hermes/
COPY rhasspy-microphone-cli-hermes/requirements.txt ${BUILD_DIR}/rhasspy-microphone-cli-hermes/
COPY rhasspy-microphone-pyaudio-hermes/requirements.txt ${BUILD_DIR}/rhasspy-microphone-pyaudio-hermes/
COPY rhasspy-nlu/requirements.txt ${BUILD_DIR}/rhasspy-nlu/
COPY rhasspy-nlu-hermes/requirements.txt ${BUILD_DIR}/rhasspy-nlu-hermes/
COPY rhasspy-rasa-nlu-hermes/requirements.txt ${BUILD_DIR}/rhasspy-rasa-nlu-hermes/
COPY rhasspy-remote-http-hermes/requirements.txt ${BUILD_DIR}/rhasspy-remote-http-hermes/
COPY rhasspy-silence/requirements.txt ${BUILD_DIR}/rhasspy-silence/
COPY rhasspy-speakers-cli-hermes/requirements.txt ${BUILD_DIR}/rhasspy-speakers-cli-hermes/
COPY rhasspy-supervisor/requirements.txt ${BUILD_DIR}/rhasspy-supervisor/
COPY rhasspy-tts-cli-hermes/requirements.txt ${BUILD_DIR}/rhasspy-tts-cli-hermes/
COPY rhasspy-tts-wavenet-hermes/requirements.txt ${BUILD_DIR}/rhasspy-tts-wavenet-hermes/
COPY rhasspy-wake-pocketsphinx-hermes/requirements.txt ${BUILD_DIR}/rhasspy-wake-pocketsphinx-hermes/

# Autoconf
COPY m4/ ${BUILD_DIR}/m4/
COPY configure config.sub config.guess \
     install-sh missing aclocal.m4 \
     Makefile.in setup.py.in rhasspy.sh.in rhasspy.spec.in \
     ${BUILD_DIR}/

RUN cd ${BUILD_DIR} && \
    ./configure --enable-in-place --prefix=${APP_DIR}/.venv

COPY scripts/install/ ${BUILD_DIR}/scripts/install/

COPY RHASSPY_DIRS ${BUILD_DIR}/

# IFDEF PYPI
#! ENV PIP_INDEX_URL=http://${PYPI}/simple/
#! ENV PIP_TRUSTED_HOST=${PYPI_HOST}
# ENDIF

RUN cd ${BUILD_DIR} && \
    make && \
    make install

# Strip binaries and shared libraries
RUN (find ${APP_DIR} -type f -name '*.so*' -print0 | xargs -0 strip --strip-unneeded -- 2>/dev/null) || true
RUN (find ${APP_DIR} -type f -executable -print0 | xargs -0 strip --strip-unneeded -- 2>/dev/null) || true

# -----------------------------------------------------------------------------

# Run stage for amd64/armv7/arm64
FROM ubuntu:eoan as run-ubuntu

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 libpython3.7 python3-pip python3-setuptools \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        supervisor mosquitto \
        perl curl sox alsa-utils libasound2-plugins jq \
        espeak flite \
        gstreamer1.0-tools gstreamer1.0-plugins-good \
        libttspico-utils

FROM run-ubuntu as run-amd64

FROM run-ubuntu as run-armv7

FROM run-ubuntu as run-arm64

# -----------------------------------------------------------------------------

# Run stage for armv6
FROM balenalib/raspberry-pi-debian-python:3.7-buster-run-20200604 as run-armv6

ENV LANG C.UTF-8

RUN install_packages \
        python3 libpython3.7 python3-pip python3-setuptools \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        supervisor mosquitto \
        perl curl sox alsa-utils libasound2-plugins jq \
        espeak flite \
        gstreamer1.0-tools gstreamer1.0-plugins-good

# -----------------------------------------------------------------------------
# Run
# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM run-$TARGETARCH$TARGETVARIANT

ENV APP_DIR=/usr/lib/rhasspy
COPY --from=build ${APP_DIR}/ ${APP_DIR}/

COPY etc/shflags ${APP_DIR}/etc/
COPY etc/wav/ ${APP_DIR}/etc/wav/
COPY bin/rhasspy-voltron bin/voltron-run ${APP_DIR}/bin/
COPY VERSION RHASSPY_DIRS ${APP_DIR}/

# Copy Rhasspy source
COPY rhasspy/ ${APP_DIR}/rhasspy/
COPY rhasspy-server-hermes/ ${APP_DIR}/rhasspy-server-hermes/
COPY rhasspy-wake-snowboy-hermes/ ${APP_DIR}/rhasspy-wake-snowboy-hermes/
COPY rhasspy-wake-porcupine-hermes/ ${APP_DIR}/rhasspy-wake-porcupine-hermes/
COPY rhasspy-wake-precise-hermes/ ${APP_DIR}/rhasspy-wake-precise-hermes/
COPY rhasspy-profile/ ${APP_DIR}/rhasspy-profile/
COPY rhasspy-asr/ ${APP_DIR}/rhasspy-asr/
COPY rhasspy-asr-deepspeech/ ${APP_DIR}/rhasspy-asr-deepspeech/
COPY rhasspy-asr-deepspeech-hermes/ ${APP_DIR}/rhasspy-asr-deepspeech-hermes/
COPY rhasspy-asr-pocketsphinx/ ${APP_DIR}/rhasspy-asr-pocketsphinx/
COPY rhasspy-asr-pocketsphinx-hermes/ ${APP_DIR}/rhasspy-asr-pocketsphinx-hermes/
COPY rhasspy-asr-kaldi/ ${APP_DIR}/rhasspy-asr-kaldi/
COPY rhasspy-asr-kaldi-hermes/ ${APP_DIR}/rhasspy-asr-kaldi-hermes/
COPY rhasspy-dialogue-hermes/ ${APP_DIR}/rhasspy-dialogue-hermes/
COPY rhasspy-fuzzywuzzy/ ${APP_DIR}/rhasspy-fuzzywuzzy/
COPY rhasspy-fuzzywuzzy-hermes/ ${APP_DIR}/rhasspy-fuzzywuzzy-hermes/
COPY rhasspy-hermes/ ${APP_DIR}/rhasspy-hermes/
COPY rhasspy-homeassistant-hermes/ ${APP_DIR}/rhasspy-homeassistant-hermes/
COPY rhasspy-microphone-cli-hermes/ ${APP_DIR}/rhasspy-microphone-cli-hermes/
COPY rhasspy-microphone-pyaudio-hermes/ ${APP_DIR}/rhasspy-microphone-pyaudio-hermes/
COPY rhasspy-nlu/ ${APP_DIR}/rhasspy-nlu/
COPY rhasspy-nlu-hermes/ ${APP_DIR}/rhasspy-nlu-hermes/
COPY rhasspy-rasa-nlu-hermes/ ${APP_DIR}/rhasspy-rasa-nlu-hermes/
COPY rhasspy-remote-http-hermes/ ${APP_DIR}/rhasspy-remote-http-hermes/
COPY rhasspy-silence/ ${APP_DIR}/rhasspy-silence/
COPY rhasspy-snips-nlu/ ${BUILD_DIR}/rhasspy-snips-nlu/
COPY rhasspy-snips-nlu-hermes/ ${BUILD_DIR}/rhasspy-snips-nlu-hermes/
COPY rhasspy-speakers-cli-hermes/ ${APP_DIR}/rhasspy-speakers-cli-hermes/
COPY rhasspy-supervisor/ ${APP_DIR}/rhasspy-supervisor/
COPY rhasspy-tts-cli-hermes/ ${APP_DIR}/rhasspy-tts-cli-hermes/
COPY rhasspy-tts-wavenet-hermes/ ${APP_DIR}/rhasspy-tts-wavenet-hermes/
COPY rhasspy-wake-pocketsphinx-hermes/ ${APP_DIR}/rhasspy-wake-pocketsphinx-hermes/

EXPOSE 12101

ENTRYPOINT ["bash", "/usr/lib/rhasspy/bin/rhasspy-voltron"]
