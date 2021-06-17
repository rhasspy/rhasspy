# Speech to Text

Rhasspy's primary function is convert voice commands to JSON events. The first step of this process is converting speech to text (transcription).

Available speech to text systems are:

* [Pocketsphinx](speech-to-text.md#pocketsphinx)
* [Kaldi](speech-to-text.md#kaldi)
* [DeepSpeech](speech-to-text.md#deepspeech)
* [Remote HTTP Server](speech-to-text.md#remote-http-server)
* [External Command](speech-to-text.md#command)

The following table summarizes language support for the various speech to text systems:

| Language  | [pocketsphinx](speech-to-text.md#pocketsphinx)   | [kaldi](speech-to-text.md#kaldi)   | [deepspeech](speech-to-text.md#deepspeech)   |
| --------- | ------------------------------------------------ | ---------------------------------- | -------------------------------------------- |
| ca        | &#x2713;                                         |                                    |                                              |
| cs        |                                                  | &#x2713;                           |                                              |
| de        | &#x2713;                                         | &#x2713;                           | &#x2713;                                     |
| el        | &#x2713;                                         |                                    |                                              |
| en        | &#x2713;                                         | &#x2713;                           | &#x2713;                                     |
| es        | &#x2713;                                         | &#x2713;                           | &#x2713;                                     |
| fr        | &#x2713;                                         | &#x2713;                           | &#x2713;                                     |
| hi        | &#x2713;                                         |                                    |                                              |
| it        | &#x2713;                                         | &#x2713;                           | &#x2713;                                     |
| nl        | &#x2713;                                         | &#x2713;                           |                                              |
| pl        |                                                  | &#x2713;                           | &#x2713;                                     |
| pt        | &#x2713;                                         |                                    | &#x2713;                                     |
| ru        | &#x2713;                                         | &#x2713;                           |                                              |
| sv        |                                                  | &#x2713;                           |                                              |
| vi        |                                                  | &#x2713;                           |                                              |
| zh        | &#x2713;                                         |                                    |                                              |

## Silence Detection

You can adjust how Rhasspy detects the start and stop of voice commands. Add to your [profile](profiles.md):

```json
  "command": {
    "webrtcvad": {
      "skip_sec": 0,
      "min_sec": 1,
      "speech_sec": 0.3,
      "silence_sec": 0.5,
      "before_sec": 0.5,
      "silence_method": "vad_only",
      "vad_mode": 1,
      "max_energy": "",
      "max_current_energy_ratio_threshold": "",
      "current_energy_threshold": ""
    }
  }
}
```

where:

* `skip_sec` is how many seconds of audio should be ignored before recording
* `min_sec` is the minimum number of seconds a voice command should last
* `speech_sec` is the seconds of speech before a command starts
* `silence_sec` is the seconds a silence after a command before ending
* `before_sec` is how many seconds of audio before a command starts are kept
* `silence_method` determines how Rhasspy detects the end of a voice command
    * `vad_only` - only [webrtcvad](https://github.com/wiseman/py-webrtcvad) is used
    * `current_only` - audio frames whose energy is above `current_energy_threshold` are considered speech
    * `ratio_only` - audio frames whose ratio of max/current energy is below `max_current_energy_ratio_threshold` are considered speech (see `max_energy`)
    * `vad_and_current` - both VAD and current audio energy are used
    * `vad_and_ratio` - both VAD and max/current energy ratio are used
    * `all` - VAD, current energy, and max/current energy ratio are all used
* `vad_mode` is the sensitivity of speech detection (3 is the <strong>least</strong> sensitive)
* `current_energy_threshold` - frame with audio energy threshold above this value is considered speech
* `max_current_energy_ratio_threshold` - frame with ratio of max/current energy below this value is considered speech
* `max_energy` - if not set, max energy is computed for every audio frame; otherwise, this fixed value is used

Implemented by [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence)

## ASR Confidence

Each ASR system reports word-level and overall sentence confidences (see `asrTokens` in [asr/textCaptured](reference.md#asr_textcaptured)).

* Pocketsphinx
    * Sentence confidence is `exp(p)` where `p` is the hypothesis probability
    * Word confidences are `exp(p)` where `p` is the segment probability
* Kaldi
    * Sentence confidence is the result of [MinimumBayesRisk.GetBayesRisk](http://kaldi-asr.org/doc/classkaldi_1_1MinimumBayesRisk.html#a0c65227b9d5ba270428cdc3f55edf682)
    * Word confidences are the result of [MinimumBayesRisk.GetOneBestConfidences](http://kaldi-asr.org/doc/classkaldi_1_1MinimumBayesRisk.html#a535b2836b20009fb6c5e8dcdfefb356c)
    * See [online2-cli-nnet3-decode-faster-confidence.cc](https://github.com/rhasspy/rhasspy-asr-kaldi/blob/master/etc/online2-cli-nnet3-decode-faster-confidence.cc)
* DeepSpeech
    * Sentence confidence is `exp(c)` where `c` is the [metadata confidence value](https://deepspeech.readthedocs.io/en/latest/Python-API.html#native_client.python.CandidateTranscript.confidence)
    * Word confidences are always set to 1
    
The [rhasspy-dialogue-hermes](https://github.com/rhasspy/rhasspy-dialogue-hermes) will use the value of `speech_to_text.<SYSTEM>.min_confidence` to decide when a voice command should be rejected as not recognized (where `<SYSTEM>` is `pocketsphinx`, `kaldi`, or `deepspeech`). This is set to 0 by default, **allowing all voice commands through**.

In the web interface, look for "Minimum Confidence" in the settings for your speech to text system:

![Minimum ASR confidence setting](img/min-asr-confidence.png)

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
        "unknown_words": "unknown_words.txt",
        "language_model_type": "arpa"
    }
  }
}
```

Rhasspy currently supports `nnet3` and `gmm` Kaldi acoustic models.

This requires Kaldi to be installed, which is...challenging. The [Docker image of Rhasspy](https://cloud.docker.com/u/synesthesiam/repository/docker/synesthesiam/rhasspy-server) contains a [pre-built copy](https://github.com/synesthesiam/kaldi-docker/releases) of Kaldi, which might work for you outside of Docker. Make sure to set `kaldi_dir` to wherever you installed Kaldi.

### Language Model Type

By default, Rhasspy generates an [ARPA](https://cmusphinx.github.io/wiki/arpaformat/) language model from [your custom voice commands](training.md#sentencesini). This model is somewhat flexible, allowing minor deviations from the prescribed templates. For longer voice commands or when you have slots with many possibilities, this language modeling approach can cause recognition problems.

Setting `speech_to_text.kaldi.language_model_type` to "text_fst" instead of "arpa" will cause Rhasspy to directly convert your custom voice command graph into a Kaldi grammar finite state transducer (`G.fst`). While less flexible, this approach will only ever produce sentences from your templates.

### Open Transcription

If you just want to use Rhasspy for general speech to text, you can set `speech_to_text.kaldi.open_transcription` to `true` in your profile. This will use the included general language model (much slower) and ignore any custom voice commands you've specified.

Implemented by [rhasspy-asr-kaldi-hermes](https://github.com/rhasspy/rhasspy-asr-kaldi-hermes)

## DeepSpeech

Does speech recognition with [Mozilla's DeepSpeech](https://github.com/mozilla/DeepSpeech) version 0.9.
This is done completely offline, on your device. If you experience performance problems (usually on a Raspberry Pi), consider running on a home server as well and have your client Rhasspy use a [remote HTTP connection](speech-to-text.md#remote-http-server).

```json
{
  "speech_to_text": {
    "system": "deepspeech",
    "deepspeech": {
      "alphabet": "deepspeech/model/0.6.1/alphabet.txt",
      "acoustic_model": "deepspeech/model/0.6.1/output_graph.pbmm",
      "base_language_model": "deepspeech/model/0.6.1/base_lm.binary",
      "base_trie": "deepspeech/model/0.6.1/base_trie",
      "compatible": true,
      "language_model": "deepspeech/lm.binary",
      "trie": "deepspeech/trie",
      "open_transcription": false
    }
  }
}
```

Uses the official [deepspeech library](https://pypi.org/project/deepspeech/), an appropriate native client, and [KenLM](https://kheafield.com/code/kenlm/) for building language models. For English, Rhasspy automatically uses Mozilla's TFLite graph on the Raspberry Pi (`armv7l`).

### Open Transcription

If you just want to use Rhasspy for general speech to text, you can set `speech_to_text.deepspeech.open_transcription` to `true` in your profile. This will use the included general language model (much slower) and ignore any custom voice commands you've specified. Beware that the required downloads are quite large (at least 1 GB extra).

Implemented by [rhasspy-asr-deepspeech-hermes](https://github.com/rhasspy/rhasspy-asr-deepspeech-hermes)

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

During speech recognition, 16-bit 16 kHz mono WAV data will be POST-ed to the endpoint with the `Content-Type` set to `audio/wav`. A `application/json` response with the `{text: "transcribed text"}` transcription is expected back.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Home Assistant STT Platform

**Not supported yet in 2.5!**

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
