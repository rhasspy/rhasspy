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
