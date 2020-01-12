# Rhasspy Voltron

Runs Rhasspy services using [supervisord](http://supervisord.org/).

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

```bash
sudo apt-get update
sudo apt-get install supervisor mosquitto sox alsa-utils
```

## Running


