FROM ubuntu:eoan as build-amd64

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
        python3 python3-dev python3-setuptools python3-pip python3-venv \
        build-essential swig libatlas-base-dev portaudio19-dev \
        curl

# -----------------------------------------------------------------------------

FROM ubuntu:eoan as build-armv7

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
        python3 python3-dev python3-setuptools python3-pip python3-venv \
        build-essential swig libatlas-base-dev portaudio19-dev \
        curl

# -----------------------------------------------------------------------------

FROM ubuntu:eoan as build-arm64

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
        python3 python3-dev python3-setuptools python3-pip python3-venv \
        build-essential swig libatlas-base-dev portaudio19-dev \
        curl

# -----------------------------------------------------------------------------

FROM balenalib/raspberry-pi-debian-python:3.7-buster-build as build-armv6

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${PROXY}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

RUN install_packages \
        swig libatlas-base-dev portaudio19-dev \
        curl

# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM build-$TARGETARCH$TARGETVARIANT as build

ENV APP_DIR=/usr/lib/rhasspy
ENV BUILD_DIR=/build

# Directory of prebuilt tools
COPY download/ ${BUILD_DIR}/download/

# Copy Rhasspy source
COPY rhasspy/ ${BUILD_DIR}/rhasspy/
COPY rhasspy-server-hermes/ ${BUILD_DIR}/rhasspy-server-hermes/
COPY rhasspy-wake-snowboy-hermes/ ${BUILD_DIR}/rhasspy-wake-snowboy-hermes/
COPY rhasspy-wake-porcupine-hermes/ ${BUILD_DIR}/rhasspy-wake-porcupine-hermes/
COPY rhasspy-wake-precise-hermes/ ${BUILD_DIR}/rhasspy-wake-precise-hermes/
COPY rhasspy-profile/ ${BUILD_DIR}/rhasspy-profile/
COPY rhasspy-asr/ ${BUILD_DIR}/rhasspy-asr/
COPY rhasspy-asr-deepspeech/ ${BUILD_DIR}/rhasspy-asr-deepspeech/
COPY rhasspy-asr-deepspeech-hermes/ ${BUILD_DIR}/rhasspy-asr-deepspeech-hermes/
COPY rhasspy-asr-pocketsphinx/ ${BUILD_DIR}/rhasspy-asr-pocketsphinx/
COPY rhasspy-asr-pocketsphinx-hermes/ ${BUILD_DIR}/rhasspy-asr-pocketsphinx-hermes/
COPY rhasspy-asr-kaldi/ ${BUILD_DIR}/rhasspy-asr-kaldi/
COPY rhasspy-asr-kaldi-hermes/ ${BUILD_DIR}/rhasspy-asr-kaldi-hermes/
COPY rhasspy-dialogue-hermes/ ${BUILD_DIR}/rhasspy-dialogue-hermes/
COPY rhasspy-fuzzywuzzy/ ${BUILD_DIR}/rhasspy-fuzzywuzzy/
COPY rhasspy-fuzzywuzzy-hermes/ ${BUILD_DIR}/rhasspy-fuzzywuzzy-hermes/
COPY rhasspy-hermes/ ${BUILD_DIR}/rhasspy-hermes/
COPY rhasspy-homeassistant-hermes/ ${BUILD_DIR}/rhasspy-homeassistant-hermes/
COPY rhasspy-microphone-cli-hermes/ ${BUILD_DIR}/rhasspy-microphone-cli-hermes/
COPY rhasspy-microphone-pyaudio-hermes/ ${BUILD_DIR}/rhasspy-microphone-pyaudio-hermes/
COPY rhasspy-nlu/ ${BUILD_DIR}/rhasspy-nlu/
COPY rhasspy-nlu-hermes/ ${BUILD_DIR}/rhasspy-nlu-hermes/
COPY rhasspy-rasa-nlu-hermes/ ${BUILD_DIR}/rhasspy-rasa-nlu-hermes/
COPY rhasspy-remote-http-hermes/ ${BUILD_DIR}/rhasspy-remote-http-hermes/
COPY rhasspy-silence/ ${BUILD_DIR}/rhasspy-silence/
COPY rhasspy-speakers-cli-hermes/ ${BUILD_DIR}/rhasspy-speakers-cli-hermes/
COPY rhasspy-supervisor/ ${BUILD_DIR}/rhasspy-supervisor/
COPY rhasspy-tts-cli-hermes/ ${BUILD_DIR}/rhasspy-tts-cli-hermes/
COPY rhasspy-wake-pocketsphinx-hermes/ ${BUILD_DIR}/rhasspy-wake-pocketsphinx-hermes/

# Create Rhasspy distribution packages from source
COPY RHASSPY_DIRS ${BUILD_DIR}/
COPY scripts/build-dists.sh ${BUILD_DIR}/scripts/
RUN cd ${BUILD_DIR} && \
    scripts/build-dists.sh

# Autoconf
COPY m4/ ${BUILD_DIR}/m4/
COPY configure config.sub config.guess \
     install-sh missing aclocal.m4 \
     Makefile.in setup.py.in rhasspy.sh.in rhasspy.spec.in \
     ${BUILD_DIR}/

RUN cd ${BUILD_DIR} && \
    ./configure --prefix=${APP_DIR}

COPY scripts/install/ ${BUILD_DIR}/scripts/install/

COPY etc/shflags ${BUILD_DIR}/etc/
COPY etc/wav/ ${BUILD_DIR}/etc/wav/
COPY bin/rhasspy-voltron bin/voltron-run ${BUILD_DIR}/bin/
COPY VERSION README.md LICENSE ${BUILD_DIR}/

# IFDEF PYPI
#! ENV PIP_INDEX_URL=http://${PYPI}/simple/
#! ENV PIP_TRUSTED_HOST=${PYPI_HOST}
# ENDIF

RUN cd ${BUILD_DIR} && \
    export PIP_INSTALL_ARGS="-f ${BUILD_DIR}/dist" \
    make && \
    make install

# Strip binaries and shared libraries
RUN (find ${APP_DIR} -type f \\( -name '*.so*' -or -executable \\) -print0 | xargs -0 strip --strip-unneeded -- 2>/dev/null) || true

# -----------------------------------------------------------------------------

FROM ubuntu:eoan as run

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 libpython3.7 python3-pip \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        supervisor mosquitto \
        perl curl sox alsa-utils jq \
        espeak flite \
        gstreamer1.0-tools gstreamer1.0-plugins-good

# -----------------------------------------------------------------------------

FROM run as run-amd64

RUN apt-get install --yes --no-install-recommends \
    libttspico-utils

# -----------------------------------------------------------------------------

FROM run as run-armv7

RUN apt-get install --yes --no-install-recommends \
    libttspico-utils

# -----------------------------------------------------------------------------

FROM run as run-arm64

RUN apt-get install --yes --no-install-recommends \
    libttspico-utils

# -----------------------------------------------------------------------------

FROM balenalib/raspberry-pi-debian-python:3.7-buster-run as run-armv6

ENV LANG C.UTF-8

RUN install_packages \
        python3 libpython3.7 python3-pip \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        supervisor mosquitto \
        perl curl sox alsa-utils jq \
        espeak flite \
        gstreamer1.0-tools gstreamer1.0-plugins-good

# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM run-$TARGETARCH$TARGETVARIANT

ENV APP_DIR=/usr/lib/rhasspy
COPY --from=build ${APP_DIR}/ ${APP_DIR}/

RUN cp ${APP_DIR}/bin/rhasspy /usr/bin/

EXPOSE 12101

ENTRYPOINT ["bash", "/usr/bin/rhasspy"]
