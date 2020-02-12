# Speech to Text

Rhasspy's primary function is convert voice commands to JSON events. The first step of this process is converting speech to text (transcription).

Available speech to text systems are:

* [Pocketsphinx](speech-to-text.md#pocketsphinx)
* [Kaldi](speech-to-text.md#kaldi)
* [Remote HTTP Server](speech-to-text.md#remote-http-server)
* [External Command](speech-to-text.md#command)

The following table summarizes language support for the various speech to text systems:

| System                                         | en       | de       | es       | fr       | it       | nl       | ru       | el       | hi       | zh       | vi       | pt       | ca       |
| ------                                         | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  |
| [pocketsphinx](speech-to-text.md#pocketsphinx) | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |
| [kaldi](speech-to-text.md#kaldi)               | &#x2713; | &#x2713; |          | &#x2713; |          | &#x2713; |          |          |          |          | &#x2713; |          |          |

## MQTT/Hermes

Rhasspy transcribes audio according to the [Hermes protocol](https://docs.snips.ai/reference/hermes). The following steps are needed to get a transcription:

1. A `hermes/asr/startListening` message is sent with a unique `sessionId`
2. One or more `hermes/audioServer/<siteId>/audioFrame` messages are sent with WAV audio data
3. If enough silence is detected, a transcription is attempted
4. A `hermes/asr/stopListening` message is sent with the same `sessionId`. If a transcription has been sent, it will be.

Either a `hermes/asr/textCaptured` or a `hermes/error/asr` message will be sent in response.

## Pocketsphinx

Does speech recognition with [CMU's pocketsphinx](https://github.com/cmusphinx/pocketsphinx).
This is done completely offline, on your device. If you experience performance problems (usually on a Raspberry Pi), consider running on a home server as well and have your client Rhasspy use a [remote HTTP connection](speech-to-text.md#remote-http-server).

Add to your [profile](profiles.md):

```json
"speech_to_text": {
  "system": "pocketsphinx",
  "pocketsphinx": {
    "acoustic_model": "acoustic_model",
    "base_dictionary": "base_dictionary.txt",
    "custom_words": "custom_words.txt",
    "dictionary": "dictionary.txt",
    "language_model": "language_model.txt"
  }
}
```

The `dictionary`, `language_model`, and `unknown_words` files are written during training by the default [speech to text training system](training.md#how-it-works). The `acoustic_model` and `base_dictionary` components for each profile were taken from [a set of pre-trained models](https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/). Anyone can extend Rhasspy to new languages by training a [new acoustic model](https://cmusphinx.github.io/wiki/tutorialam).

When Rhasspy starts, it creates a pocketsphinx decoder with the following attributes:

* `hmm` - `speech_to_text.pocketsphinx.acoustic_model` (directory)
* `dict` - `speech_to_text.pocketsphinx.dictionary` (file)
* `lm` - `speech_to_text.pocketsphinx.language_model` (file)

### Open Transcription

If you just want to use Rhasspy for general speech to text, you can set `speech_to_text.pocketsphinx.open_transcription` to `true` in your profile. This will use the included general language model (much slower) and ignore any custom voice commands you've specified. For English, German, and Dutch, you may want to use [Kaldi](#kaldi) instead for better results.

Implemented by [rhasspy-asr-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-asr-pocketsphinx-hermes)

## Kaldi

Does speech recognition with [Kaldi](https://kaldi-asr.org).
This is done completely offline, on your device. If you experience performance problems (usually on a Raspberry Pi), consider running on a home server as well and have your client Rhasspy use a [remote HTTP connection](speech-to-text.md#remote-http-server).

```json
{
  "speech_to_text": {
    "system": "kaldi",
    "kaldi": {
        "base_dictionary": "base_dictionary.txt",
        "compatible": true,
        "custom_words": "custom_words.txt",
        "dictionary": "dictionary.txt",
        "graph": "graph",
        "kaldi_dir": "/opt/kaldi",
        "language_model": "language_model.txt",
        "model_dir": "model",
        "unknown_words": "unknown_words.txt"
    }
  }
}
```

Rhasspy currently supports `nnet3` and `gmm` Kaldi acoustic models.

This requires Kaldi to be installed, which is...challenging. The [Docker image of Rhasspy](https://cloud.docker.com/u/synesthesiam/repository/docker/synesthesiam/rhasspy-server) contains a [pre-built copy](https://github.com/synesthesiam/kaldi-docker/releases) of Kaldi, which might work for you outside of Docker. Make sure to set `kaldi_dir` to wherever you installed Kaldi.

### Open Transcription

If you just want to use Rhasspy for general speech to text, you can set `speech_to_text.kaldi.open_transcription` to `true` in your profile. This will use the included general language model (much slower) and ignore any custom voice commands you've specified.

Implemented by [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes)

## Remote HTTP Server

Uses a remote HTTP server to transform speech (WAV) to text.
The `/api/speech-to-text` endpoint from [Rhasspy's HTTP API](usage.md#http-api) does just this, allowing you to use a remote instance of Rhasspy for speech recognition.
This is typically used in a client/server set up, where Rhasspy does speech/intent recognition on a home server with decent CPU/RAM available.

Add to your [profile](profiles.md):

```json
"speech_to_text": {
  "system": "remote",
  "remote": {
    "url": "http://my-server:12101/api/speech-to-text"
  }
}
```

During speech recognition, 16-bit 16 kHz mono WAV data will be POST-ed to the endpoint with the `Content-Type` set to `audio/wav`. A `text/plain` response with the transcription is expected back.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Home Assistant STT Platform

Use an [STT platform](https://www.home-assistant.io/integrations/stt) on your Home Assistant server.
This is the same way [Ada](https://github.com/home-assistant/ada) sends speech to Home Assistant.

Add to your [profile](profiles.md):

```json
"speech_to_text": {
  "system": "hass_stt",
  "hass_stt": {
    "platform": "...",
    "sample_rate": 16000,
    "bit_size": 16,
    "channels": 1,
    "language": "en-US"
  }
}
```

The settings from your profile's `home_assistant` section are automatically used (URL, access token, etc.).

Rhasspy will convert audio to the configured format before streaming it to Home Assistant.
In the future, this will be auto-detected from the STT platform API.

TODO: Not implemented

## Command

Calls a custom external program to do speech recognition. WAV audio data is provided to your program's standard in, and a transcription is expected on standard out.

Add to your [profile](profiles.md):

```json
"speech_to_text": {
  "system": "command",
  "command": {
    "program": "/path/to/program",
    "arguments": []
  }
}
```

The following environment variables are available to your program:

* `$RHASSPY_BASE_DIR` - path to the directory where Rhasspy is running from
* `$RHASSPY_PROFILE` - name of the current profile (e.g., "en")
* `$RHASSPY_PROFILE_DIR` - directory of the current profile (where `profile.json` is)

See [speech2text.sh](https://github.com/synesthesiam/rhasspy/blob/master/bin/mock-commands/speech2text.sh) for an example program.

If you want to also call an external program during training, add to your profile:

```json
"training": {
  "system": "auto",
  "speech_to_text": {
    "command": {
      "program": "/path/to/training/program",
      "arguments": []
    }
  }
}
```

If `training.speech_to_text.command.program` is set, Rhasspy will call your program with the intent graph generated by [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) provided as JSON on standard input. No response is expected, though a non-zero exit code indicates a training failure.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Dummy

Disables speech to text decoding.

Add to your [profile](profiles.md):

```json
"speech_to_text": {
  "system": "dummy"
}
```
