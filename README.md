# Rhasspy Voice Assistant

![Rhasspy 2.5 logo](docs/img/rhasspy25.png)

Rhasspy (ˈɹæspi) is an [open source](https://github.com/rhasspy), fully offline set of [voice assistant services](#services) for [many human languages](#supported-languages) that works well with:

* [Hermes protocol](https://docs.snips.ai/reference/hermes) compatible services ([Snips.AI](https://snips.ai/))
* [Home Assistant](https://www.home-assistant.io/) and [Hass.io](https://www.home-assistant.io/hassio/)
* [Node-RED](https://nodered.org)
* [Jeedom](https://www.jeedom.com)
* [OpenHAB](https://www.openhab.org)

You specify voice commands in a [template language](https://rhasspy.readthedocs.io/en/latest/training/):

```ini
[LightState]
states = (on | off)
turn (<states>){state} [the] light
```

and Rhasspy will produce [JSON](https://json.org) events that can trigger action in home automation software, such as a [Node-RED flow](https://rhasspy.readthedocs.io/en/latest/usage/#node-red):

```json
{
    "text": "turn on the light",
    "intent": {
        "name": "LightState"
    },
    "slots": {
        "state": "on"
    }
}
```

Rhasspy is <strong>optimized for</strong>:

* Working with external services via [MQTT](https://rhasspy.readthedocs.io/en/latest/usage/#mqtt), [HTTP](https://rhasspy.readthedocs.io/en/latest/usage/#http-api), and [Websockets](https://rhasspy.readthedocs.io/en/latest/usage/#websocket-events)
    * Home Assistant and Hass.IO have [built-in support](https://rhasspy.readthedocs.io/en/latest/usage/#home-assistant)
* Pre-specified voice commands that are described well [by a grammar](https://rhasspy.readthedocs.io/en/latest/training/#sentencesini)
    * You can also do [open-ended speech recognition](https://rhasspy.readthedocs.io/en/latest/speech-to-text/#open-transcription)
* Voice commands with [uncommon words or pronunciations](https://rhasspy.readthedocs.io/en/latest/usage/#words-tab)
    * New words are added phonetically with [automated assistance](https://github.com/AdolfVonKleist/Phonetisaurus)
    
## Learn More

* [Rhasspy A-M Video Series](https://www.youtube.com/watch?v=dI5tS3sNZD0) by [Thorsten Müller](https://www.thorsten-voice.de/)
* [Video Demonstration](https://www.youtube.com/watch?v=IsAlz76PXJQ)
    * [Rhasspy In-Depth Series](https://www.youtube.com/playlist?list=PL0SUCSMtqzGE9z3oRFoPcz7wIM5XdIzQr)
* [Documentation](https://rhasspy.readthedocs.io/en/latest/)
    * [Getting Started Guide](https://rhasspy.readthedocs.io/en/latest/tutorials/#getting-started-guide)
    * [Why Rhasspy?](https://rhasspy.readthedocs.io/en/latest/why-rhasspy/)
    * [Whitepaper](https://rhasspy.readthedocs.io/en/latest/whitepaper/)
* [Community Discourse](https://community.rhasspy.org)

## Web Interface

Rhasspy comes with a [snazzy web interface](https://rhasspy.readthedocs.io/en/latest/usage/#web-interface) that lets you configure, program, and test your voice assistant remotely from your web browser. All of the web UI's functionality is exposed in a comprehensive [HTTP API](https://rhasspy.readthedocs.io/en/latest/reference/#http-api).

![Test page in web interface](docs/img/web-speech.png)

## Getting Started

Ready to try Rhasspy? Follow the steps below or check out the [Getting Started Guide](https://rhasspy.readthedocs.io/en/latest/tutorials/#getting-started-guide).

1. Make sure you have the [necessary hardware](https://rhasspy.readthedocs.io/en/latest/hardware/)
2. Choose an [installation method](https://rhasspy.readthedocs.io/en/latest/installation/)
3. Access the [web interface](https://rhasspy.readthedocs.io/en/latest/usage/#web-interface) to download a profile
4. Author your [custom voice commands](https://rhasspy.readthedocs.io/en/latest/training/) and train Rhasspy
5. Connect Rhasspy to other software like [Home Assistant](https://rhasspy.readthedocs.io/en/latest/usage/#home-assistant) or a [Node-RED](https://rhasspy.readthedocs.io/en/latest/usage/#node-red) flow by:
    * Sending and receiving [Hermes MQTT messages](https://rhasspy.readthedocs.io/en/latest/services/)
    * Using Rhasspy's [HTTP API](https://rhasspy.readthedocs.io/en/latest/usage/#http-api)
    * Connecting a Websocket to one of Rhasspy's [websocket](https://rhasspy.readthedocs.io/en/latest/usage/#http-api)

## Getting Help

If you have problems, please stop by the [Rhasspy community site](https://community.rhasspy.org) or [open a GitHub issue](https://github.com/synesthesiam/rhasspy/issues).

## Supported Languages

Rhasspy supports the following languages:

* English (`en`)
    * [Kaldi](https://github.com/synesthesiam/en-us_kaldi-zamia)
    * [Pocketsphinx](https://github.com/synesthesiam/en-us_pocketsphinx-cmu)
    * [DeepSpeech](https://github.com/synesthesiam/en-us_deepspeech-mozilla)
* German (Deutsch, `de`)
    * [Kaldi](https://github.com/synesthesiam/de_kaldi-zamia)
    * [Pocketsphinx](https://github.com/synesthesiam/de_pocketsphinx-cmu)
    * [DeepSpeech](https://github.com/synesthesiam/de_deepspeech-aashishag)
* Spanish (Español, `es`)
    * [Pocketsphinx](https://github.com/synesthesiam/es_pocketsphinx-cmu)
    * [Kaldi](https://github.com/rhasspy/es_kaldi-rhasspy)
    * [DeepSpeech](https://github.com/rhasspy/es_deepspeech-jaco)
* French (Français, `fr`)
    * [Kaldi](https://github.com/synesthesiam/fr_kaldi-guyot)
    * [Pocketsphinx](https://github.com/synesthesiam/fr_pocketsphinx-cmu)
    * [DeepSpeech](https://github.com/rhasspy/fr_deepspeech-jaco)
* Italian (Italiano, `it`)
    * [Pocketsphinx](https://github.com/synesthesiam/it_pocketsphinx-cmu)
    * [Kaldi](https://github.com/rhasspy/it_kaldi-rhasspy)
    * [DeepSpeech](https://github.com/rhasspy/it_deepspeech-jaco)
* Dutch (Nederlands, `nl`)
    * [Kaldi](https://github.com/synesthesiam/nl_kaldi-cgn)
    * [Pocketsphinx](https://github.com/synesthesiam/nl_pocketsphinx-cmu)
* Russian (Русский, `ru`)
    * [Pocketsphinx](https://github.com/synesthesiam/ru_pocketsphinx-cmu)
    * [Kaldi](https://github.com/rhasspy/ru_kaldi-rhasspy)
* Greek (Ελληνικά, `el`)
    * [Pocketsphinx](https://github.com/synesthesiam/el-gr_pocketsphinx-cmu)
* Hindi (Devanagari, `hi`)
    * [Pocketsphinx](https://github.com/synesthesiam/hi_pocketsphinx-cmu)
* Mandarin (中文, `zh`)
    * [Pocketsphinx](https://github.com/synesthesiam/zh-cn_pocketsphinx-cmu)
* Vietnamese (`vi`)
    * [Kaldi](https://github.com/synesthesiam/vi_kaldi-montreal)
* Portuguese (Português, `pt`)
    * [Pocketsphinx](https://github.com/synesthesiam/pt-br_pocketsphinx-cmu)
* Swedish (`sv`)
    * [Kaldi](https://github.com/rhasspy/sv_kaldi-rhasspy)
* Catalan (`ca`)
    * [Pocketsphinx](https://github.com/synesthesiam/ca-es_pocketsphinx-cmu)
* Czech (`cs`)
    * [Kaldi](https://github.com/rhasspy/cs_kaldi-rhasspy)
* Polish (`pl`)
    * [DeepSpeech](https://github.com/rhasspy/pl_deepspeech-jaco)

## Services

As of version 2.5, Rhasspy is composed of [independent services](https://rhasspy.readthedocs.io/en/latest/services/) that coordinate over [MQTT](https://mqtt.org) using a superset of the [Hermes protocol](https://docs.snips.ai/reference/hermes).

![Rhasspy services](docs/img/services.png)

You can easily extend or replace functionality in Rhasspy by using the [appropriate messages](https://rhasspy.readthedocs.io/en/latest/reference/#mqtt-api). Many of these messages can be also sent and received over the [HTTP API](https://rhasspy.readthedocs.io/en/latest/reference/#http-api) and the [Websocket API](https://rhasspy.readthedocs.io/en/latest/reference/#websocket-api).

## Intended Audience

Rhasspy is intended for savvy amateurs or advanced users that want to have a **private** voice interface to their chosen home automation software. There are many other voice assistants, but none (to my knowledge) that:

1. Can function **completely disconnected from the Internet**
2. Are entirely free/open source with a permissive license
3. Work well with freely available home automation software

If you feel comfortable sending your voice commands through the Internet for someone else to process, or are not comfortable customizing software to handle intents, I recommend taking a look at [Mycroft](https://mycroft.ai).

## Contributing

Community contributions are welcomed! There are many different [ways to contribute](docs/contributing.md), both as a developer and a non-developer.

![Open source](docs/img/open-source.png)

---

## Development Status

The various repositories also have their own issue tracker to follow and discuss development of these specific components. Here's the status of all repositories:

| Repository                                                                                        | Tests                                                                                                                                                                    | Open issues                                                                                                                                                               | Open pull requests                                                                                                                                                                 |
| ----------                                                                                        | -----                                                                                                                                                                    | -----------                                                                                                                                                               | ------------------                                                                                                                                                                 |
| [rhasspy](https://github.com/rhasspy/rhasspy) | [![Tests](https://github.com/rhasspy/rhasspy/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy)](https://github.com/rhasspy/rhasspy/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy)](https://github.com/rhasspy/rhasspy/pulls) |
| [rhasspy-asr](https://github.com/rhasspy/rhasspy-asr) | [![Tests](https://github.com/rhasspy/rhasspy-asr/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr)](https://github.com/rhasspy/rhasspy-asr/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr)](https://github.com/rhasspy/rhasspy-asr/pulls) |
| [rhasspy-asr-deepspeech](https://github.com/rhasspy/rhasspy-asr-deepspeech)                       | [![Tests](https://github.com/rhasspy/rhasspy-asr-deepspeech/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-deepspeech/actions)                       | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-deepspeech)](https://github.com/rhasspy/rhasspy-asr-deepspeech/issues)                       | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-deepspeech)](https://github.com/rhasspy/rhasspy-asr-deepspeech/pulls)
| [rhasspy-asr-deepspeech-hermes](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes)         | [![Tests](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes/actions)         | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-deepspeech-hermes)](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes/issues)         | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-deepspeech-hermes)](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes/pulls)
| [rhasspy-asr-kaldi](https://github.com/rhasspy/rhasspy-asr-kaldi) | [![Tests](https://github.com/rhasspy/rhasspy-asr-kaldi/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-kaldi/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-kaldi)](https://github.com/rhasspy/rhasspy-asr-kaldi/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-kaldi)](https://github.com/rhasspy/rhasspy-asr-kaldi/pulls) |
| [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-kaldi-hermes)](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-kaldi-hermes)](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes/pulls) |
| [rhasspy-asr-pocketsphinx](https://github.com/rhasspy/rhasspy-asr-pocketsphinx) | [![Tests](https://github.com/rhasspy/rhasspy-asr-pocketsphinx/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-pocketsphinx)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-pocketsphinx)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx/pulls) |
| [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-asr-pocketsphinx-hermes)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-asr-pocketsphinx-hermes)](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes/pulls) |
| [rhasspy-client](https://github.com/rhasspy/rhasspy-client) | [![Tests](https://github.com/rhasspy/rhasspy-client/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-client/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-client)](https://github.com/rhasspy/rhasspy-client/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-client)](https://github.com/rhasspy/rhasspy-client/pulls) |
| [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-dialogue-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-dialogue-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-dialogue-hermes)](https://github.com/rhasspy/rhasspy-dialogue-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-dialogue-hermes)](https://github.com/rhasspy/rhasspy-dialogue-hermes/pulls) |
| [rhasspy-fuzzywuzzy](https://github.com/rhasspy/rhasspy-fuzzywuzzy) | [![Tests](https://github.com/rhasspy/rhasspy-fuzzywuzzy/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-fuzzywuzzy/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-fuzzywuzzy)](https://github.com/rhasspy/rhasspy-fuzzywuzzy/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-fuzzywuzzy)](https://github.com/rhasspy/rhasspy-fuzzywuzzy/pulls) |
| [rhasspy-fuzzywuzzy-hermes](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-fuzzywuzzy-hermes)](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-fuzzywuzzy-hermes)](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes/pulls) |
| [rhasspy-hermes](https://github.com/rhasspy/rhasspy-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-hermes)](https://github.com/rhasspy/rhasspy-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-hermes)](https://github.com/rhasspy/rhasspy-hermes/pulls) |
| [rhasspy-hermes-app](https://github.com/rhasspy/rhasspy-hermes-app) | [![Tests](https://github.com/rhasspy/rhasspy-hermes-app/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-hermes-app/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-hermes-app)](https://github.com/rhasspy/rhasspy-hermes-app/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-hermes-app)](https://github.com/rhasspy/rhasspy-hermes-app/pulls) |
| [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)           | [![Tests](https://github.com/rhasspy/rhasspy-homeassistant-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-homeassistant-hermes/actions)           | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-homeassistant-hermes)](https://github.com/rhasspy/rhasspy-homeassistant-hermes/issues)           | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-homeassistant-hermes)](https://github.com/rhasspy/rhasspy-homeassistant-hermes/pulls)
| [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-microphone-cli-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-microphone-cli-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-microphone-cli-hermes)](https://github.com/rhasspy/rhasspy-microphone-cli-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-microphone-cli-hermes)](https://github.com/rhasspy/rhasspy-microphone-cli-hermes/pulls) |
| [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-microphone-pyaudio-hermes)](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-microphone-pyaudio-hermes)](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes/pulls) |
| [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) | [![Tests](https://github.com/rhasspy/rhasspy-nlu/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-nlu/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-nlu)](https://github.com/rhasspy/rhasspy-nlu/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-nlu)](https://github.com/rhasspy/rhasspy-nlu/pulls) |
| [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-nlu-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-nlu-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-nlu-hermes)](https://github.com/rhasspy/rhasspy-nlu-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-nlu-hermes)](https://github.com/rhasspy/rhasspy-nlu-hermes/pulls) |
| [rhasspy-profile](https://github.com/rhasspy/rhasspy-profile) | [![Tests](https://github.com/rhasspy/rhasspy-profile/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-profile/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-profile)](https://github.com/rhasspy/rhasspy-profile/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-profile)](https://github.com/rhasspy/rhasspy-profile/pulls) |
| [rhasspy-python-template](https://github.com/rhasspy/rhasspy-python-template) | [![Tests](https://github.com/rhasspy/rhasspy-python-template/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-python-template/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-python-template)](https://github.com/rhasspy/rhasspy-python-template/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-python-template)](https://github.com/rhasspy/rhasspy-python-template/pulls) |
| [rhasspy-rasa-nlu-hermes](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes)                     | [![Tests](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes/actions)                     | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-rasa-nlu-hermes)](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes/issues)                     | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-rasa-nlu-hermes)](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes/pulls)
| [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-remote-http-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-remote-http-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-remote-http-hermes)](https://github.com/rhasspy/rhasspy-remote-http-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-remote-http-hermes)](https://github.com/rhasspy/rhasspy-remote-http-hermes/pulls) |
| [rhasspy-server-hermes](https://github.com/rhasspy/rhasspy-server-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-server-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-server-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-server-hermes)](https://github.com/rhasspy/rhasspy-server-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-server-hermes)](https://github.com/rhasspy/rhasspy-server-hermes/pulls) |
| [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) | [![Tests](https://github.com/rhasspy/rhasspy-silence/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-silence/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-silence)](https://github.com/rhasspy/rhasspy-silence/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-silence)](https://github.com/rhasspy/rhasspy-silence/pulls) |
| [rhasspy-snips-nlu](https://github.com/rhasspy/rhasspy-snips-nlu)                                 | [![Tests](https://github.com/rhasspy/rhasspy-snips-nlu/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-snips-nlu/actions)                                 | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-snips-nlu)](https://github.com/rhasspy/rhasspy-snips-nlu/issues)                                 | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-snips-nlu)](https://github.com/rhasspy/rhasspy-snips-nlu/pulls)                                 |
| [rhasspy-snips-nlu-hermes](https://github.com/rhasspy/rhasspy-snips-nlu-hermes)                   | [![Tests](https://github.com/rhasspy/rhasspy-snips-nlu-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-snips-nlu-hermes/actions)                   | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-snips-nlu-hermes)](https://github.com/rhasspy/rhasspy-snips-nlu-hermes/issues)                   | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-snips-nlu-hermes)](https://github.com/rhasspy/rhasspy-snips-nlu-hermes/pulls)
| [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-speakers-cli-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-speakers-cli-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-speakers-cli-hermes)](https://github.com/rhasspy/rhasspy-speakers-cli-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-speakers-cli-hermes)](https://github.com/rhasspy/rhasspy-speakers-cli-hermes/pulls) |
| [rhasspy-supervisor](https://github.com/rhasspy/rhasspy-supervisor) | [![Tests](https://github.com/rhasspy/rhasspy-supervisor/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-supervisor/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-supervisor)](https://github.com/rhasspy/rhasspy-supervisor/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-supervisor)](https://github.com/rhasspy/rhasspy-supervisor/pulls) |
| [rhasspy-tag-action](https://github.com/rhasspy/rhasspy-tag-action) | [![Tests](https://github.com/rhasspy/rhasspy-tag-action/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-tag-action/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-tag-action)](https://github.com/rhasspy/rhasspy-tag-action/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-tag-action)](https://github.com/rhasspy/rhasspy-tag-action/pulls) |
| [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-tts-cli-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-tts-cli-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-tts-cli-hermes)](https://github.com/rhasspy/rhasspy-tts-cli-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-tts-cli-hermes)](https://github.com/rhasspy/rhasspy-tts-cli-hermes/pulls) |
| [rhasspy-update-repo-action](https://github.com/rhasspy/rhasspy-update-repo-action) | [![Tests](https://github.com/rhasspy/rhasspy-update-repo-action/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-update-repo-action/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-update-repo-action)](https://github.com/rhasspy/rhasspy-update-repo-action/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-update-repo-action)](https://github.com/rhasspy/rhasspy-update-repo-action/pulls) |
| [rhasspy-wake-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-pocketsphinx-hermes)](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-pocketsphinx-hermes)](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes/pulls) |
| [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-porcupine-hermes)](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-porcupine-hermes)](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes/pulls) |
| [rhasspy-wake-precise-hermes](https://github.com/rhasspy/rhasspy-wake-precise-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-wake-precise-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-precise-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-precise-hermes)](https://github.com/rhasspy/rhasspy-wake-precise-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-precise-hermes)](https://github.com/rhasspy/rhasspy-wake-precise-hermes/pulls) |
| [rhasspy-wake-raven](https://github.com/rhasspy/rhasspy-wake-raven) | [![Tests](https://github.com/rhasspy/rhasspy-wake-raven/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-raven/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-raven)](https://github.com/rhasspy/rhasspy-wake-raven/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-raven)](https://github.com/rhasspy/rhasspy-wake-raven/pulls) |
| [rhasspy-wake-raven-hermes](https://github.com/rhasspy/rhasspy-wake-raven-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-wake-raven-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-raven-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-raven-hermes)](https://github.com/rhasspy/rhasspy-wake-raven-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-raven-hermes)](https://github.com/rhasspy/rhasspy-wake-raven-hermes/pulls) |
| [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes) | [![Tests](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes/workflows/Tests/badge.svg)](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes/actions) | [![Open issues](https://img.shields.io/github/issues-raw/rhasspy/rhasspy-wake-snowboy-hermes)](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes/issues) | [![Open pull requests](https://img.shields.io/github/issues-pr-raw/rhasspy/rhasspy-wake-snowboy-hermes)](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes/pulls) |

