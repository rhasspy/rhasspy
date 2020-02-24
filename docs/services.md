# Services

Rhasspy is composed of independent services that communicate over [MQTT](https://mqtt.org) using a superset of the [Hermes protocol](https://docs.snips.ai/reference/hermes) for these components:

* [Web Server](#web-server)
* [Dialogue Manager](#dialogue-manager)
* [Audio Input](#audio-input)
* [Wake Word Detection](#wake-word-detection)
* [Speech to Text](#speech-to-text)
* [Intent Recognition](#intent-recognition)
* [Intent Handling](#intent-handling)
* [Text to Speech](#text-to-speech)
* [Audio Output](#audio-output)

Message payloads are typically [JSON objects](https://json.org), except for the following messages whose payloads are binary [WAV audio](https://en.wikipedia.org/wiki/WAV):

* [`hermes/audioServer/<siteId>/audioFrame`](reference.md#audioserver_audioframe)
    * WAV chunk from microphone
* [`hermes/audioServer/<siteId>/playBytes/<requestId>`](reference.md#audioserver_playbytes) 
    * WAV audio to play through speakers
* [`rhasspy/asr/<siteId>/<sessionId>/audioCaptured`](reference.md#asr_audiocaptured) 
    * WAV audio recorded from session

Most messages contain a string `siteId` property, whose default value is "default". Each service takes one or more `--siteId <NAME>` arguments that determine which site IDs the service will listen for. If not specified, the service will listen for **all sites**.

## Web Server

Provides a [graphical web interface](usage.md#web-interface) for managing Rhasspy, and handles downloading language-specific profile artifacts.

### Available Services

* [rhasspy-server-hermes](https://github.com/rhasspy/rhasspy-server-hermes)
    * [Vue.js](https://vuejs.org/) based web UI at `http://YOUR_SERVER:12101`
    * Implements Rhasspy's [HTTP API](reference.md#http-api) and [websocket API](reference.md#websocket-api)

## Dialogue Manager

Manages sessions initiated by a wake word [`detection`](reference.md#hotword_detected) or a [`startSession`](reference.md#dialoguemanager_startsession).

![Hermes dialogue message flow](img/hermes-flow.png)

### Available Services

* [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes)

### Input Messages

* [`hermes/dialogueManager/startSession`](reference.md#dialoguemanager_startsession) 
    * Start a new session
* [`hermes/dialogueManager/continueSession`](reference.md#dialoguemanager_continuesession)
    * Continue an existing session
* [`hermes/dialogueManager/endSession`](reference.md#dialoguemanager_endsession) 
    * End an existing session

### Output Messages

* [`hermes/dialogueManager/sessionStarted`](reference.md#dialoguemanager_sessionstarted)
    * New session has started
* [`hermes/dialogueManager/sessionQueued`](reference.md#dialoguemanager_sessionqueued)
    * New session has be enqueued
* [`hermes/dialogueManager/sessionEnded`](reference.md#dialoguemanager_sessionended)
    * Existing session has terminated
* [`hermes/dialogueManager/intentNotRecognized`](reference.md#dialoguemanager_intentnotrecognized)
    * Voice command was not recognized in existing session

## Audio Input

Records audio from a microphone and streams it as WAV chunks over MQTT. See [Audio Input](audio-input.md) for details.

### Available Services

* [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)
    * Calls an external program for audio input
    * Implements [arecord](audio-input.md#alsa)
* [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)
    * Records directly from a [PyAudio](https://people.csail.mit.edu/hubert/pyaudio/) device
    * Implements [pyaudio](audio-input.md#pyaudio)

### Input Messages

* [`rhasspy/audioServer/getDevices`](reference.md#audioserver_getdevices)
    * Requests available input devices

### Output Messages

* [`hermes/audioServer/<siteId>/audioFrame`](reference.md#audioserver_audioframe)
    * WAV chunk from microphone
* [`rhasspy/audioServer/devices`](reference.md#audioserver_devices)
    * Description of available audio input devices

## Wake Word Detection

Listens to WAV chunks and tries to detect a wake/hotword. See [Wake Word](wake-word.md) for details.

### Available Services

* [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes)
* [rhasspy-wake-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes)
* [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes)

### Input Messages

* [`hermes/hotword/toggleOn`](reference.md#hotword_toggleon)
    * Enables wake word detection
* [`hermes/hotword/toggleOff`](reference.md#hotword_toggleoff)
    * Disables wake word detection

### Output Messages

 * [`hermes/wake/hotword/<wakewordId>/detected`](reference.md#hotword_detected)
    * Wake word successfully detected

## Speech to Text

Listens to WAV chunks and transcribes voice commands. See [Speech to Text](speech-to-text.md) for details.

### Available Services

* [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes)
* [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes)

### Input Messages

* [`hermes/audioServer/<siteId>/audioFrame`](reference.md#audioserver_audioframe)
    * WAV chunk from microphone
* [`hermes/asr/toggleOn`](reference.md#asr_toggleon)
    * Enable ASR system
* [`hermes/asr/toggleOff`](reference.md#asr_toggleoff)
    * Disable ASR system
* [`hermes/asr/startListening`](reference.md#asr_startlistening)
    * Start recording a voice command
* [`hermes/asr/stopListening`](reference.md#asr_stoplistening)
    * Stop recording a voice command
* [`rhasspy/asr/<siteId>/train`](reference.md#asr_train)
    * Re-train ASR system
* [`rhasspy/g2p/pronounce`](reference.md#g2p_pronounce)
    * Get phonetic pronunciations for words

### Output Messages

* [`hermes/asr/textCaptured`](reference.md#asr_textcaptured)
    * Successful voice command transcription
* [`hermes/error/asr`](reference.md#error_asr)
    * Error during transcription/training
* [`rhasspy/asr/<siteId>/trainSuccess`](reference.md#asr_trainsuccess)
    * ASR training succeeded
* [`rhasspy/asr/<siteId>/<sessionId>/audioCaptured`](reference.md#asr_audiocaptured)
    * Audio recorded from voice command
* [`rhasspy/g2p/phonemes`](reference.md#g2p_phonemes)
    * Phonetic pronunciations of words

## Intent Recognition

Recognizes user intents from text input. See [Intent Recognition](intent-recognition.md) for details.

### Available Services

* [rhasspy-fuzzywuzzy-hermes](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes)
* [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes)

### Input Messages

* [`hermes/nlu/query`](reference.md#nlu_query)
    * Recognize intent from text
* [`rhasspy/nlu/<siteId>/train`](reference.md#nlu_<siteid>/train)
    * Retrain NLU system

### Output Messages

* [`hermes/intent/<intentName>`](reference.md#nlu_intent)
    * Intent successfully recognized
* [`hermes/nlu/intentNotRecognized`](reference.md#nlu_intentnotrecognized)
    * Intent was **not** recognized
* [`hermes/error/nlu`](reference.md#error_nlu)
    * Error during recognition/training
* [`rhasspy/nlu/<siteId>/trainSuccess`](reference.md#nlu_trainsuccess)
    * NLU training succeeded

## Intent Handling

Dispatches recognized intents to home automation software. See [Intent Handling](intent-handling.md) for details.

### Available Services

* [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)

### Input Messages

* [`hermes/nlu/intent/<intentName>`](reference.md#nlu_intent)
    * Intent successfully recognized
* [`hermes/handle/toggleOn`](reference.md#handle_toggleon)
    * Enable intent handling
* [`hermes/handle/toggleOff`](reference.md#handle_toggleoff)
    * Disable intent handling

### Output Messages

* [`hermes/tts/say`](reference.md#tts_say)
    * Speak a sentence

## Text to Speech

Generates spoken audio for a sentence. See [Text to Speech](text-to-speech.md) for details.

### Available Services

* [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)
    * Calls external program for text to speech
    * Implements [espeak](text-to-speech.md#espeak), [flite](text-to-speech.md#flite), [picoTTS](text-to-speech.md#picotts), and [command](text-to-speech.md#command)
* [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)
    * POSTs to remote web server for text to speech
    * Implements [remote](text-to-speech.md#remote) (`--tts-url`) and [command](text-to-speech.md#command) (`--tts-command`)

### Input Messages

* [`hermes/tts/say`](reference.md#tts_say)
    * Speak a sentence

### Output Messages

* [`hermes/tts/sayFinished`](reference.md#tts_sayfinished)
    * Finished *generating* audio

## Audio Output

Plays WAV audio through an audio output device (speakers). See [Audio Output](audio-output.md) for details.

### Available Services

* [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)

### Input Messages

* [`hermes/audioServer/<siteId>/playBytes/<requestId>`](reference.md#audioserver_playbytes)
    * WAV audio to play through speakers
* [`rhasspy/audioServer/getDevices`](reference.md#audioserver_getdevices)
    * Request audio output devices

### Output Messages

* [`hermes/audioServer/<siteId>/playFinished`](reference.md#audioserver_playfinished)
    * Audio has finished playing
* [`rhasspy/audioServer/devices`](reference.md#audioserver_devices)
    * Details of audio output devices
