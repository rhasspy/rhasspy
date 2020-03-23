# Rhasspy Voltron

Runs Rhasspy services using [supervisord](http://supervisord.org/). Service configuration is automatically generated using [rhasspy-supervisor](https://github.com/rhasspy/rhasspy-supervisor).

## Available Services

* Audio Recording
    * [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)
    * [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)
* Audio Playback
    * [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)
* Wake Word Detection
    * [rhasspy-wake-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes)
    * [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes)
    * [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes)
* Speech to Text (ASR)
    * [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes) built on [rhasspy-asr-kaldi](https://github.com/rhasspy/rhasspy-asr-kaldi)
    * [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes) built on [rhasspy-asr-pocketsphinx](https://github.com/rhasspy/rhasspy-asr-pocketsphinx)
    * Built on [rhasspy-asr](https://github.com/rhasspy/rhasspy-asr) library ([pypi](https://pypi.org/project/rhasspy-asr/))
    * Uses [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library ([pypi](https://pypi.org/project/rhasspy-silence/))
* Intent Recognition (NLU)
    * [rhasspy-fuzzywuzzy-hermes](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes) built on ([rhasspy-fuzzywuzzy](https://github.com/rhasspy/rhasspy-fuzzywuzzy))
    * [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes) built on ([rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu))
* Text to Speech (TTS)
    * [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)
* Dialogue Management
    * [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes)
* Remote/Command
    * [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)
    * [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)

## Interface

* [rhasspy-server-hermes](https://github.com/rhasspy/rhasspy-server-hermes)


## Getting Started

Before building Rhasspy, you will need some support packages:

* `python3*` (Python)
* `git` (clone repo)
* `build-essential` (compiler)
* `libatlas-base-dev` (snowboy)
* `swig` (snowboy/pocketsphinx)
* `portaudio19-dev` (pocketsphinx)

```bash
sudo apt-get update
sudo apt-get install \
     python3 python3-dev python3-setuptools python3-pip python3-venv \
     git build-essential libatlas-base-dev swig portaudio19-dev
```

Install runtime dependencies:

* `supervisord` (process management)
* `mosquitto` (MQTT broker)
* `sox` (WAV conversion)
* `alsa-utils` (record/play audio)
* `libgfortran4` (Kaldi)
* Text to speech
    * `espeak`
    * `flite`
    * `libttspico-utils`
* Miscellaneous
    * `perl`
    * `curl`
    * `patchelf`
    * `ca-certificates`

```bash
sudo apt-get update
sudo apt-get install \
     supervisor mosquitto sox alsa-utils libgfortran4 \
     libfst-tools libngram-tools \
     espeak flite libttspico-utils \
     perl curl patchelf ca-certificates
```

If you can an error regarding `libttspico-utils`, you can skip installing it.
The necessary `.deb` files can be manually downloaded and installed from [http://archive.raspberrypi.org/debian/pool/main/s/svox/](http://archive.raspberrypi.org/debian/pool/main/s/svox/). You will need `libttspico-utils` and `libttspico0` packages with matching versions.

Clone the repo and build:

```bash
git clone --recurse-submodules https://github.com/rhasspy/rhasspy-voltron
cd rhasspy-voltron/
make
```

## Running

Run the `bin/rhasspy-voltron` script with a `--profile <LANGUAGE>` argument.
