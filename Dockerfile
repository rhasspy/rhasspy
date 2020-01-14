ARG BUILD_ARCH=amd64
FROM ${BUILD_ARCH}/debian:buster-slim

RUN apt-get update
RUN apt-get install --no-install-recommends --yes \
        libatlas3-base \
        supervisor mosquitto sox alsa-utils

ENV RHASSPY_DIR=/usr/lib/rhasspy-voltron

#COPY rhasspy-asr-kaldi-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-asr-pocketsphinx-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-dialogue-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-microphone-cli-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-microphone-pyaudio-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-nlu-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
#COPY rhasspy-remote-http-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-server-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-speakers-cli-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-supervisor/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-tts-cli-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-wake-porcupine-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/
COPY rhasspy-wake-snowboy-hermes/pyinstaller/dist/ ${RHASSPY_DIR}/

COPY etc/ ${RHASSPY_DIR}/etc/
COPY RHASSPY_DIRS ${RHASSPY_DIR}/
COPY RHASSPY_SERVICES ${RHASSPY_DIR}/
COPY rhasspy-server-hermes/profiles/ ${RHASSPY_DIR}/rhasspy-server-hermes/profiles/
COPY web/ ${RHASSPY_DIR}/web/
COPY VERSION ${RHASSPY_DIR}/
COPY docker/bin/run.sh ${RHASSPY_DIR}/bin/rhasspy-voltron

WORKDIR ${RHASSPY_DIR}

ENTRYPOINT ["bin/rhasspy-voltron"]
