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

## Interface

* [rhasspy-server-hermes](https://github.com/rhasspy/rhasspy-server-hermes)
    * Built on [rhasspy-web-vue](https://github.com/rhasspy/rhasspy-web-vue)


## Getting Started

Clone the repo and submodules:

```bash
git clone https://github.com/rhasspy/rhasspy-voltron
cd rhasspy-voltron/
git submodule update --init --recursive
```

Create a virtual environment and install Python dependencies.
You will need some support packages:

* `build-essential` (compiler)
* `libatlas-base-dev` (snowboy)
* `swig` (snowboy/pocketsphinx)
* `portaudio19-dev` (pocketsphinx)

```bash
sudo apt-get update
sudo apt-get install build-essential libatlas-base-dev swig portaudio19-dev
make venv
```

Install runtime dependencies:

  * `supervisord` (process management)
  * `mosquitto` (MQTT broker)
  * `sox` (WAV conversion)
  * `alsa-utils` (record/play audio)
  * `libgfortran3` (training)

```bash
sudo apt-get update
sudo apt-get install supervisor mosquitto sox alsa-utils libgfortran3
```

If you plan to use [Pocketsphinx](https://github.com/cmusphinx/pocketsphinx) for speech recognition (the default), do:

```bash
cd rhasspy-asr-pocketsphinx && make venv
```

To use [Kaldi](https://kaldi-asr.org) instead for speech recognition (the default), do:

```bash
cd rhasspy-asr-kaldi && make venv
```

## Running

Run the `bin/rhasspy-voltron` script with a `--profile <LANGUAGE>` argument.
