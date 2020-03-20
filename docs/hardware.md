# Hardware

Rhasspy is designed to be run on different kinds of hardware, such as:

* Raspberry Pi 2-3 B/B+ (`armhf`/`aarch64`)
* Desktop/laptop/server (`amd64`)
* Raspberry Pi Zero (`armv6l`)

The table below summarizes architecture compatibility with Rhasspy's components:

| Category               | Name                                           | amd64    | armhf    | aarch64  |
| --------               | ------                                         | -------  | -------  | -------  |
| **Wake Word**          | [pocketsphinx](wake-word.md#pocketsphinx)      | &#x2713; | &#x2713; | &#x2713; |
|                        | [snowboy](wake-word.md#snowboy)                | &#x2713; | &#x2713; |          |
|                        | [precise](wake-word.md#mycroft-precise)        | &#x2713; | &#x2713; |          |
|                        | [porcupine](wake-word.md#porcupine)            | &#x2713; | &#x2713; | &#x2713; |
| **Speech to Text**     | [pocketsphinx](speech-to-text.md#pocketsphinx) | &#x2713; | &#x2713; | &#x2713; |
|                        | [kaldi](speech-to-text.md#kaldi)               | &#x2713; | &#x2713; | &#x2713; |
| **Intent Recognition** | [fsticuffs](intent-recognition.md#fsticuffs)   | &#x2713; | &#x2713; | &#x2713; |
|                        | [fuzzywuzzy](intent-recognition.md#fuzzywuzzy) | &#x2713; | &#x2713; | &#x2713; |
|                        | [adapt](intent-recognition.md#mycroft-adapt)   | &#x2713; | &#x2713; | &#x2713; |
|                        | [flair](intent-recognition.md#flair)           | &#x2713; |          |          |
|                        | [rasaNLU](intent-recognition.md#rasanlu)       | &#x2713; | &#x2713; | &#x2713; |
| **Text to Speech**     | [espeak](text-to-speech.md#espeak)             | &#x2713; | &#x2713; | &#x2713; |
|                        | [flite](text-to-speech.md#flite)               | &#x2713; | &#x2713; | &#x2713; |
|                        | [picotts](text-to-speech.md#picotts)           | &#x2713; | &#x2713; |          |
|                        | [marytts](text-to-speech.md#marytts)           | &#x2713; | &#x2713; | &#x2713; |
|                        | [wavenet](text-to-speech.md#google-wavenet)    | &#x2713; | &#x2713; | &#x2713; |

## Raspberry Pi

To run Rhasspy on a Raspberry Pi, you'll need at least a 4 GB SD card and a good power supply. I highly recommend the [CanaKit Starter Kit](https://www.amazon.com/CanaKit-Raspberry-Starter-Premium-Black/dp/B07BCC8PK7), which includes a 32 GB SD card, a 2.5 A power supply, and a case.

Some components of Rhasspy will not work on the Raspberry Pi 3 B+ model with a 64-bit operating system (`aarch64`). As of the time of this writing, these are:

* [snowboy](wake-word.md#snowboy) (wake word)
* [Mycroft Precise](wake-word.md#mycroft-precise) (wake word)
* [picoTTS](text-to-speech.md#picotts) (text to speech)

## Microphone

Rhasspy can listen to audio input from a local microphone or from a [remote audio stream](audio-input.md#mqtthermes). Most of the local audio testing has been done with the following microphones:

* [PlayStation Eye camera](https://en.wikipedia.org/wiki/PlayStation_Eye)
* [ReSpeaker 4 Mic Array](https://respeaker.io/4_mic_array/)
* [ReSpeaker 2 Mics pHAT](https://respeaker.io/2_mic_array/)

Remote audio testing has main used the [MATRIX Voice](https://www.matrix.one/products/voice) and [Romkabouter's](https://github.com/Romkabouter) excellent [MQTT Audio Streamer](https://github.com/Romkabouter/Matrix-Voice-ESP32-MQTT-Audio-Streamer). For Raspberry Pi's, check out the [hermes-audio-server](https://pypi.org/project/hermes-audio-server) by [koenvervloesem](https://github.com/koenvervloesem). Some users have also reported success with the `snips-audio-server` package from [Snips.AI](https://snips.ai). In both cases, you will need to configure Rhasspy to [listen for audio data over MQTT](audio-input.md#mqtthermes).

You may also be interested in reading [this microphone benchmarking post](https://medium.com/snips-ai/benchmarking-microphone-arrays-respeaker-conexant-microsemi-acuedge-matrix-creator-minidsp-950de8876fda) that the [Snips.AI](http://snips.ai/) folks did back in 2017.
