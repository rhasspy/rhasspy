# Rhasspy Voltron

Runs Rhasspy services using [supervisord](http://supervisord.org/).

## Available Services

* Audio Recording
    * [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)
    * [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)
* Audio Playback
    * [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)
* Wake Word Detection
    * [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes)
    * [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes)
* Speech to Text (ASR)
    * [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes) built on [rhasspy-asr-kaldi](https://github.com/rhasspy/rhasspy-asr-kaldi)
    * [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes) built on [rhasspy-asr-pocketsphinx](https://github.com/rhasspy/rhasspy-asr-pocketsphinx)
    * Built on [rhasspy-asr](https://github.com/rhasspy/rhasspy-asr) library ([pypi](https://pypi.org/project/rhasspy-asr/))
    * Uses [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library ([pypi](https://pypi.org/project/rhasspy-silence/))
* Intent Recognition (NLU)
    * [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes) built on ([rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu))
* Text to Speech (TTS)
    * [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)
* Dialogue Management
    * [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes)
* Vocabulary
    * [rhasspy-g2p-hermes](https://github.com/rhasspy/rhasspy-g2p-hermes)
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

## Running

Run the `bin/rhasspy-voltron` script with a `--profile <LANGUAGE>` argument.

For now, you **must** have an existing Rhasspy profile (training/downloading coming soon).

## Building From Source

Rhasspy depends on the following programs that must be compiled:

* [Kaldi](http://kaldi-asr.org)
    * Speech to text engine
* [MITLM](https://github.com/mitlm/mitlm)
    * Language model from ngrams
* [Phonetisaurus](https://github.com/AdolfVonKleist/Phonetisaurus)
    * Guesses pronunciations for unknown words
    
### Kaldi

Make sure you have the necessary dependencies installed:

```bash
sudo apt-get install \
    build-essential \
    libatlas-base-dev libatlas3-base gfortran \
    automake autoconf unzip sox libtool subversion \
    python3 python \
    git zlib1g-dev
```

Download Kaldi and extract it:

```bash
wget -O kaldi-master.tar.gz \
    'https://github.com/kaldi-asr/kaldi/archive/master.tar.gz'
tar -xvf kaldi-master.tar.gz
```

First, build Kaldi's tools:

```bash
cd kaldi-master/tools
make
```

Use `make -j 4` if you have multiple CPU cores. This will take a **long** time.

Next, build Kaldi itself:

```bash
cd kaldi-master
./configure --shared --mathlib=ATLAS
make depend
make
```

Use `make depend -j 4` and `make -j 4` if you have multiple CPU cores. This will take a **long** time.

There is no installation step. The `kaldi-master` directory contains all the libraries and programs that Rhasspy will need to access.

See [docker-kaldi](https://github.com/synesthesiam/docker-kaldi) for a Docker build script.

### MITLM

Download [mitlm 0.4.2](https://github.com/mitlm/mitlm/releases) from Github and extract it:

```bash
wget 'https://github.com/mitlm/mitlm/releases/download/v0.4.2/mitlm-0.4.2.tar.xz'
tar -xvf mitlm-0.4.2.tar.xz
```

Make sure you have the necessary dependencies installed:

```bash
sudo apt-get install \
    build-essential \
    automake autoconf-archive libtool \
    gfortran
```

Build and install:

```bash
cd mitlm-0.4.2
./autogen.sh
make
make install
```

Use `make -j 4` if you have multiple CPU cores.

You should now be able to run the `estimate-ngram` program.

See [docker-mitlm](https://github.com/synesthesiam/docker-mitlm) for a Docker build script.

### Phonetisaurus

Make sure you have the necessary dependencies installed:

```bash
sudo apt-get install build-essential
```

First, download and build [OpenFST 1.6.2](http://www.openfst.org/)

```bash
wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.2.tar.gz
tar -xvf openfst-1.6.2.tar.gz
cd openfst-1.6.2
./configure \
    "--prefix=$(pwd)/build" \
    --enable-static --enable-shared \
    --enable-far --enable-ngram-fsts
make
make install
```

Use `make -j 4` if you have multiple CPU cores. This will take a **long** time.

Next, download and extract Phonetisaurus:

```bash
wget -O phonetisaurus-master.tar.gz \
    'https://github.com/AdolfVonKleist/Phonetisaurus/archive/master.tar.gz'
tar -xvf phonetisaurus-master.tar.gz
```

Finally, build Phonetisaurus (where `/path/to/openfst` is the `openfst-1.6.2` directory from above):

```
cd Phonetisaurus-master
./configure \
    --with-openfst-includes=/path/to/openfst/build/include \
    --with-openfst-libs=/path/to/openfst/build/lib
make
make install
```

Use `make -j 4` if you have multiple CPU cores. This will take a **long** time.

You should now be able to run the `phonetisaurus-align` program.

See [docker-phonetisaurus](https://github.com/synesthesiam/docker-phonetisaurus) for a Docker build script.
