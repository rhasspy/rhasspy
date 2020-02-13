# Reference

* [Supported Languages](#supported-languages)
* [MQTT API](#mqtt-api)
* [HTTP API](#http-api)
* [Websocket API](#websocket-api)
* [Profile Settings](#profile-settings)
* [Command Line](#command-line)

## Supported Languages

The table below lists which components and compatible with Rhasspy's supported languages.

| Category               | Name                                           | Offline?               | en       | de       | es       | fr       | it       | nl       | ru       | el       | hi       | zh       | vi       | pt       | sv       | ca       |
| --------               | ------                                         | --------               | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  |
| **Wake Word**          | [pocketsphinx](wake-word.md#pocketsphinx)      | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          |          |          |          |
|                        | [porcupine](wake-word.md#porcupine)            | &#x2713;               | &#x2713; |          |          |          |          |          |          |          |          |          |          |          |          |          |
|                        | [snowboy](wake-word.md#snowboy)                | *requires account*     | &#x2713; | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   |
|                        | [precise](wake-word.md#mycroft-precise)        | &#x2713;               | &#x2713; | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   | &bull;   |
| **Speech to Text**     | [pocketsphinx](speech-to-text.md#pocketsphinx) | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          | &#x2713; |          | &#x2713; |
|                        | [kaldi](speech-to-text.md#kaldi)               | &#x2713;               | &#x2713; | &#x2713; |          | &#x2713; |          | &#x2713; |          |          |          |          | &#x2713; |          | &#x2713; |          |
| **Intent Recognition** | [fsticuffs](intent-recognition.md#fsticuffs)   | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
|                        | [fuzzywuzzy](intent-recognition.md#fuzzywuzzy) | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
|                        | [adapt](intent-recognition.md#mycroft-adapt)   | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
|                        | [flair](intent-recognition.md#flair)           | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          | &#x2713; |          |          |          |          |          | &#x2713; |          | &#x2713; |
|                        | [rasaNLU](intent-recognition.md#rasanlu)       | *needs extra software* | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
| **Text to Speech**     | [espeak](text-to-speech.md#espeak)             | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
|                        | [flite](text-to-speech.md#flite)               | &#x2713;               | &#x2713; |          |          |          |          |          |          |          | &#x2713; |          |          |          |          |          |
|                        | [picotts](text-to-speech.md#picotts)           | &#x2713;               | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          |          |          |          |          |          |          |          |          |
|                        | [marytts](text-to-speech.md#marytts)           | &#x2713;               | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |          | &#x2713; |          |          |          |          |          |          |          |
|                        | [wavenet](text-to-speech.md#google-wavenet)    |                        | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |          |

&bull; - yes, but requires training/customization

## MQTT API

Rhasspy implements a superset of the [Hermes protocol](https://docs.snips.ai/reference/hermes) in [rhasspy-hermes](https://github.com/rhasspy/rhasspy-hermes) for the following components:

* [Audio Server](#audio-server)
* [Automated Speech Recognition](#automated-speech-recognition)
* [Dialogue Manager](#dialogue-manager)
* [Hotword Detection](#hotword-detection)
* [Text to Speech](#text-to-speech)

### Audio Server

* <a id="audioserver_audioframe"><tt>hermes/audioServer/&lt;siteId&gt;/audioFrame</tt></a> (binary)
    * Chunk of WAV audio data
    * `wav_bytes: bytes` - WAV data to play (**message payload**)
    * `siteId: string` - Hermes site ID (part of topic)
* <a id="audioserver_playbytes"><tt>hermes/audioServer/&lt;siteId&gt;/playBytes/&lt;requestId&gt;</tt></a> (JSON)
    * Play WAV data
    * `wav_bytes: bytes` - WAV data to play (message payload)
    * `requestId: string` - unique ID for request (part of topic)
    * `siteId: string` - Hermes site ID (part of topic)
    * Response(s)
        * [`hermes/audioServer/<siteId>/playFinished`](#audioserver_playfinished) (JSON)
* <a id="audioserver_playfinished"><tt>hermes/audioServer/&lt;siteId&gt;/playFinished</tt></a>
    * Indicates that audio has finished playing
    * Response to [`hermes/audioServer/<siteId>/playBytes/<requestId>`](#audioserver_playbytes)
    * `siteId: string` - Hermes site ID (part of topic)
    * `id: string = ""` - `requestId` from request message
    
### Automated Speech Recognition

* <a id="asr_toggleon"><tt>hermes/asr/toggleOn</tt></a> (JSON)
    * Enables ASR system
    * `siteId: string = "default"` - Hermes site ID
* <a id="asr_toggleoff"><tt>hermes/asr/toggleOff</tt></a> (JSON)
    * Disables ASR system
    * `siteId: string = "default"` - Hermes site ID
* <a id="asr_startlistening"><tt>hermes/asr/startListening</tt></a> (JSON)
    * Tell ASR system to start recording/transcribing
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
* <a id="asr_stoplistening"><tt>hermes/asr/stopListening</tt></a> (JSON)
    * Tell ASR system to stop recording
    * Emits [`textCaptured`](#asr_textcaptured) if silence has was not detected earlier
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
* <a id="asr_textcaptured"><tt>hermes/asr/textCaptured</tt></a> (JSON)
    * Successful transcription, sent either when silence is detected or on [`stopListening`](#asr_stoplistening)
    * `text: string` - transcription text
    * `likelihood: float` - confidence from ASR system
    * `seconds: float` - transcription time in seconds
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
* <a id="asr_error"><tt>hermes/error/asr</tt></a> (JSON)
    * Sent when an error occurs in the ASR system
    * `error: string` - description of the error
    * `context: string` - system-defined context of the error
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
* <a id="asr_train"><tt>hermes/asr/&lt;siteId&gt;/train</tt></a> (JSON, Rhasspy only)
    * Instructs the ASR system to re-train
    * `id: string` - unique ID for request (copied to [`trainSuccess`](#asr_trainsuccess))
    * `graph_dict: object` - intent graph from [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) encoded as a JSON object
    * `siteId: string` - Hermes site ID (part of topic)
    * Response(s)
        * [`hermes/asr/<siteId>/trainSuccess`](#asr_trainsuccess)
        * [`hermes/error/asr`](#asr_error)
* <a id="asr_trainsuccess"><tt>hermes/asr/&lt;siteId&gt;/trainSuccess</tt></a> (JSON, Rhasspy only)
    * Indicates that training was successful
    * `id: string` - unique ID from request (copied from [`train`](#asr_train))
    * `siteId: string` - Hermes site ID (part of topic)
    * Response to [`hermes/asr/<siteId>/train`](#asr_train)
* <a id="asr_audiocaptured"><tt>hermes/asr/&lt;siteId&gt;/&lt;sessionId&gt;/audioCaptured</tt></a> (binary, Rhasspy only)
    * WAV audio data captured by ASR session
    * `siteId: string` - Hermes site ID (part of topic)
    * `sessionId: string` - current session ID (part of topic)
    * Only sent if `sendAudioCaptured = true` in [`startListening`](#asr_startlistening)
    
### Dialogue Manager

* <a id="dialoguemanager_startsession"><tt>hermes/dialogueManager/startSession</tt></a> (JSON)
    * Starts a new dialogue session (done automatically on hotword [`detected`](#hotword_detected))
    * `init: object` - JSON object with one of two forms:
        * Action
            * `type: string = "action"` - required
            * `canBeEnqueued: bool` - true if session can be queued if there is already one (required)
            * `text: string = ""` - sentence to speak using [text to speech](#text-to-speech)
            * `intentFilter: [string] = null` - valid intent names (`null` means all) 
            * `sendIntentNotRecognized: bool = false` - send [`hermes/dialogueManager/intentNotRecognized`](#dialoguemanager_intentnotrecognized) if [intent recognition](#intent-recognition) fails
        * Notification
            * `type: string = "notification"` - required
            * `text: string` - sentence to speak using [text to speech](#text-to-speech) (required)
    * `siteId: string = "default"` - Hermes site ID
    * `customData: string = ""` - user-defined data passed to subsequent session messages
    * Response(s)
        * [`hermes/dialogueManager/sessionStarted`](#dialoguemanager_sessionstarted)
        * [`hermes/dialogueManager/sessionQueued`](#dialoguemanager_sessionqueued)
* <a id="dialoguemanager_sessionstarted"><tt>hermes/dialogueManager/sessionStarted</tt></a> (JSON)
    * Indicates a session has started
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
    * `customData: string = ""` - user-defined data (copied from [`startSession`](#dialoguemanager_startsession))
    * Response to [`hermes/dialogueManager/startSession`]
* <a id="dialoguemanager_sessionqueued"><tt>hermes/dialogueManager/sessionQueued</tt></a> (JSON)
    * Indicates a session has been queued (only when `init.canBeEnqueued = true` in [`startSession`](#dialoguemanager_startsession))
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
    * `customData: string = ""` - user-defined data (copied from [`startSession`](#dialoguemanager_startsession))
    * Response to [`hermes/dialogueManager/startSession`]
* <a id="dialoguemanager_continuesession"><tt>hermes/dialogueManager/continueSession</tt></a> (JSON)
    * Requests that a session be continued after an [`intent`](#nlu_intent) has been recognized
    * `sessionId: string` - current session ID (required)
    * `customData: string = ""` - user-defined data (overrides session `customData` if not empty)
    * `text: string = ""` - sentence to speak using [text to speech](#text-to-speech)
    * `intentFilter: [string] = null` - valid intent names (`null` means all) 
    * `sendIntentNotRecognized: bool = false` - send [`hermes/dialogueManager/intentNotRecognized`](#dialoguemanager_intentnotrecognized) if [intent recognition](#intent-recognition) fails
* <a id="dialoguemanager_endsession"><tt>hermes/dialogueManager/endSession</tt></a> (JSON)
    * Requests that a session be terminated nominally
    * `sessionId: string` - current session ID (required)
    * `customData: string = ""` - user-defined data (overrides session `customData` if not empty)
* <a id="dialoguemanager_sessionended"><tt>hermes/dialogueManager/sessionEnded</tt></a> (JSON)
    * Indicates a session has terminated
    * `termination: string` reason for termination (required), one of:
        * nominal
        * abortedByUser
        * intentNotRecognized
        * timeout
        * error
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
    * `customData: string = ""` - user-defined data (copied from [`startSession`](#dialoguemanager_startsession))
    * Response to [`hermes/dialogueManager/endSession`](#dialoguemanager_endsession) or other reasons for a session termination
    
### Hotword Detection

* <a id="hotword_toggleon"><tt>hermes/hotword/toggleOn</tt></a> (JSON)
    * Enables hotword detection
    * `siteId: string = "default"` - Hermes site ID
* <a id="hotword_toggleoff"><tt>hermes/hotword/toggleOff</tt></a> (JSON)
    * Disables hotword detection
    * `siteId: string = "default"` - Hermes site ID
* <a id="hotword_detected"><tt>hermes/hotword/&lt;wakewordId&gt;/detected</tt></a> (JSON)
    * Indicates a hotword was successfully detected
    * `wakewordId: string` - wake word ID (part of topic)
    * `modelId: string` - ID of wake word model used (service specific)
    * `modelVersion: string = ""` - version of wake word model used (service specific)
    * `modelType: string = "personal"` - type of wake word model used (service specific)
    * `currentSensitivity: float = 1.0` - sensitivity of wake word detection (service specific)
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID (Rhasspy only)
* <a id="hotword_error"><tt>hermes/error/hotword</tt></a> (JSON, Rhasspy only)
    * Sent when an error occurs in the hotword system
    * `error: string` - description of the error
    * `context: string` - system-defined context of the error
    * `siteId: string = "default"` - Hermes site ID

### Text to Speech

* <a id="tts_say"><tt>hermes/tts/say</tt></a> (JSON)
    * Generate spoken audio for a sentence using the configured text to speech system
    * Automatically sends [`playBytes`](#audioserver_playbytes)
        * `playBytes.requestId = say.id`
    * `text: string` - sentence to speak (required)
    * `lang: string = ""` - language for TTS system
    * `id: string = ""` - unique ID for request (copied to `sayFinished`)
    * `siteId: string = "default"` - Hermes site ID
    * `sessionId: string = ""` - current session ID
    * Response(s)
        * [`hermes/tts/sayFinished`](#tts_sayfinished) (JSON)
* <a id="tts_sayfinished"><tt>hermes/tts/sayFinished</tt></a> (JSON)
    * Indicates that the text to speech system has finished generating audio
    * `id: string = ""` - unique ID for request (copied from `say`)
    * `siteId: string = "default"` - Hermes site ID
    * Response to [`hermes/tts/say`](#tts_say)
    * Listen for [`playFinished`](#audioserver_playfinished) to determine when audio is finished playing
        * `playFinished.id = sayFinished.id`

## HTTP API

Rhasspy's HTTP endpoints are documented below. You can also visit `/api/` in your Rhasspy server (note the final slash) to try out each endpoint.

Application authors may want to use the [rhasspy-client](https://pypi.org/project/rhasspy-client/), which provides a high-level interface to a remote Rhasspy server.

### Endpoints

* `/api/custom-words`
    * GET custom word dictionary as plain text, or POST to overwrite it
    * See `custom_words.txt` in your profile directory
* `/api/download-profile`
    * Force Rhasspy to re-download profile
    * `?delete=true` - clear download cache
* `/api/listen-for-command`
    * POST to wake Rhasspy up and start listening for a voice command
    * Returns intent JSON when command is finished
    * `?nohass=true` - stop Rhasspy from handling the intent
    * `?timeout=<seconds>` - override default command timeout
    * `?entity=<entity>&value=<value>` - set custom entity/value in recognized intent
* `/api/listen-for-wake-word`
    * POST "on" to have Rhasspy listen for a wake word
    * POST "off" to disable wake word
* `/api/lookup`
    * POST word as plain text to look up or guess pronunciation
    * `?n=<number>` - return at most `n` guessed pronunciations
* `/api/microphones`
    * GET list of available microphones
* `/api/phonemes`
    * GET example phonemes from speech recognizer for your profile
    * See `phoneme_examples.txt` in your profile directory
* `/api/play-wav`
    * POST to play WAV data
* `/api/profile`
    * GET the JSON for your profile, or POST to overwrite it
    * `?layers=profile` to only see settings different from `defaults.json`
    * See `profile.json` in your profile directory
* `/api/restart`
    * Restart Rhasspy server
* `/api/sentences`
    * GET voice command templates or POST to overwrite
    * Set `Accept: application/json` to GET JSON with all sentence files
    * Set `Content-Type: application/json` to POST JSON with sentences for multiple files
    * See `sentences.ini` and `intents` directory in your profile
* `/api/slots`
    * GET slot values as JSON or POST to add to/overwrite them
    * `?overwrite_all=true` to clear slots in JSON before writing
* `/api/speakers`
    * GET list of available audio output devices
* `/api/speech-to-intent`
    * POST a WAV file and have Rhasspy process it as a voice command
    * Returns intent JSON when command is finished
    * `?nohass=true` - stop Rhasspy from handling the intent
* `/api/speech-to-text`
    * POST a WAV file and have Rhasspy return the text transcription
    * Set `Accept: application/json` to receive JSON with more details
    * `?noheader=true` - send raw 16-bit 16Khz mono audio without a WAV header
* `/api/start-recording`
    * POST to have Rhasspy start recording a voice command
* `/api/stop-recording`
    * POST to have Rhasspy stop recording and process recorded data as a voice command
    * Returns intent JSON when command has been processed
    * `?nohass=true` - stop Rhasspy from handling the intent
* `/api/test-microphones`
    * GET list of available microphones and if they're working
* `/api/text-to-intent`
    * POST text and have Rhasspy process it as command
    * Returns intent JSON when command has been processed
    * `?nohass=true` - stop Rhasspy from handling the intent
* `/api/text-to-speech`
    * POST text and have Rhasspy speak it
    * `?play=false` - get WAV data instead of having Rhasspy speak
    * `?voice=<voice>` - override default TTS voice
    * `?language=<language>` - override default TTS language or locale
    * `?repeat=true` - have Rhasspy repeat the last sentence it spoke
* `/api/train`
    * POST to re-train your profile
    * `?nocache=true` - re-train profile from scratch
* `/api/unknown-words`
    * GET words that Rhasspy doesn't know in your sentences
    * See `unknown_words.txt` in your profile directory
    
TODO: /api/mqtt

## Websocket API

## Profile Settings

## Command Line Tools
