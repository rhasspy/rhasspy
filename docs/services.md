# Services

Rhasspy is composed of independent services that communicate over [MQTT](https://mqtt.org) using a superset of the [Hermes protocol](https://docs.snips.ai/reference/hermes).

Message payloads are typically [JSON objects](https://json.org), except for the following messages whose payloads are binary [WAV audio](https://en.wikipedia.org/wiki/WAV):

* [`hermes/audioServer/<siteId>/audioFrame`](reference.md#audioserver_audioframe)
* [`hermes/audioServer/<siteId>/playBytes/<requestId>`](reference.md#audioserver_playbytes)
* [`rhasspy/asr/<siteId>/<sessionId>/audioCaptured`](reference.md#asr_audiocaptured)

Most messages contain a string `siteId` property, whose default value is "default". Each service takes one or more `--siteId <NAME>` arguments that determine which site IDs the service will listen for. If not specified, the service will listen for **all sites**.

## Web Server

Provides a graphical web interface for managing Rhasspy, and handles downloading language-specific profile artifacts.

### Available Services

* [rhasspy-server-hermes](https://github.com/rhasspy/rhasspy-server-hermes)
    * [Vue.js](https://vuejs.org/) based web UI at `http://YOUR_SERVER:12101`
    * Implements Rhasspy's [HTTP API](reference.md#http-api) and [websocket API](reference.md#websocket-api)

## Dialogue

![Hermes dialogue message flow](img/hermes-flow.png)

### Available Services

* [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes)

### Input Messages

* `hermes/dialogueManager/startSession`
    * `siteId: string = "default"` - Hermes site ID
* `hermes/dialogueManager/continueSession`
    * `siteId: string = "default"` - Hermes site ID
* `hermes/dialogueManager/endSession`
    * `siteId: string = "default"` - Hermes site ID

### Output Messages

* `hermes/dialogueManager/sessionStarted`
    * `siteId: string = "default"` - Hermes site ID
* `hermes/dialogueManager/sessionQueued`
    * `siteId: string = "default"` - Hermes site ID
* `hermes/dialogueManager/sessionEnded`
    * `siteId: string = "default"` - Hermes site ID
* `hermes/dialogueManager/intentNotRecognized`
    * `siteId: string = "default"` - Hermes site ID

## Audio Input

### Available Services

* [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)
    * Calls an external program for audio input
    * Implements [arecord](audio-input.md#alsa)
* [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)
    * Records directly from a [PyAudio](https://people.csail.mit.edu/hubert/pyaudio/) device
    * Implements [pyaudio](audio-input.md#pyaudio)

### Input Messages

* `rhasspy/audioServer/getDevices` - requests available input devices

### Output Messages

* `hermes/audioServer/<siteId>/audioFrame`
    * `wav_bytes: bytes` - WAV data to play (message payload)
    * `siteId: string` - Hermes site ID (part of topic)
* `rhasspy/audioServer/devices` - response to `getDevices`

## Wake Word Detection

### Available Services

* [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes)
* [rhasspy-wake-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes)
* [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes)

### Input Messages

* `hermes/hotword/toggleOn`
* `hermes/hotword/toggleOff`

### Output Messages

 * `hermes/wake/hotword/<wakewordId>/detected`
    * `wakewordId: string` - ID of detected wake word (part of topic)

## Speech to Text

### Available Services

* [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes)
* [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes)

### Input Messages

* `hermes/audioServer/<siteId>/audioFrame`
    * `wav_bytes: bytes` - WAV data to play (message payload)
    * `siteId: string` - Hermes site ID (part of topic)
* `hermes/asr/toggleOn`
* `hermes/asr/toggleOff`
* `hermes/asr/startListening`
* `hermes/asr/stopListening`
* `rhasspy/asr/<siteId>/train`
    * `siteId: string` - Hermes site ID (part of topic)

### Output Messages

* `hermes/asr/textCaptured` - successful transcription
* `hermes/error/asr` - error during transcription/training
* `rhasspy/asr/<siteId>/trainSuccess` - training succeeded
    * `siteId: string` - Hermes site ID (part of topic)
* `rhasspy/asr/<siteId>/<sessionId>/audioCaptured` - audio from voice command
    * `wav_bytes: bytes` - WAV data to play (message payload)
    * `siteId: string` - Hermes site ID (part of topic)
    * `session: string` - current session ID (part of topic)

## Intent Recognition

### Available Services

* [rhasspy-fuzzywuzzy-hermes](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes)
* [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes)

### Input Messages

* `hermes/nlu/query` - recognize intent from text
    * `input: string` - input text
* `rhasspy/nlu/<siteId>/train` - retrain NLU system
    * `siteId: string` - Hermes site ID (part of topic)

### Output Messages

* `hermes/nlu/intent/<intentName>` - intent successfully recognized
    * `intentName: string` - name of recognized intent (part of topic)
* `hermes/nlu/intentNotRecognized` - intent was not recognized
* `hermes/error/nlu` - error during recognition/training
* `rhasspy/nlu/<siteId>/trainSuccess` - training succeeded
    * `siteId: string` - Hermes site ID (part of topic)

## Intent Handling

### Available Services

* [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)

### Input Messages

* `hermes/nlu/intent/<intentName>` - intent successfully recognized
    * `intentName: string` - name of recognized intent (part of topic)

### Output Messages

* `hermes/tts/say` - speak a sentence

### Input Messages

* `hermes/nlu/intent/<intentName>`
    * `intentName: string` - name of intent to handle (part of topic)

## Text to Speech

### Available Services

* [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)
    * Calls external program for text to speech
    * Implements [espeak](text-to-speech.md#espeak), [flite](text-to-speech.md#flite), [picoTTS](text-to-speech.md#picotts), and [command](text-to-speech.md#command)
* [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)
    * POSTs to remote web server for text to speech
    * Implements [remote](text-to-speech.md#remote) (`--tts-url`) and [command](text-to-speech.md#command) (`--tts-command`)

### Input Messages

* `hermes/tts/say` - speak a sentence
    * `text: string` - sentence to speak (required)
    * `lang: string = ""` - language for TTS system
    * `id: string = ""` - unique ID for request (copied to `sayFinished`)
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID

### Output Messages

* `hermes/tts/sayFinished` - response to `say`
    * `id: string = ""` - unique ID for request (copied from `say`)
    * `sessionId: string = ""` - current session ID (copied from `say`)

## Audio Output

Plays WAV audio through an audio output device (speakers).

### Available Services

* [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)

### Input Messages

* [`hermes/audioServer/<siteId>/playBytes/<requestId>`](reference.md#audioserver_playbytes)
* `rhasspy/audioServer/getDevices` - request output devices
    * TODO

### Output Messages

* [`hermes/audioServer/<siteId>/playFinished`](reference.md#audioserver_playfinished)
* `rhasspy/audioServer/devices` - response to `getDevices`
    * TODO
