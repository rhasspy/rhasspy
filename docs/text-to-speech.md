# Text to Speech

After you voice command has been [handled](intent-handling.md), it's common to produce speech as a response back to the user. Rhasspy has support for several text to speech systems which, importantly, can be played through any of the [audio output](audio-output.md) systems.

The following table summarizes language support for the various text to speech systems:

| Language | [espeak](text-to-speech.md#espeak) | [flite](text-to-speech.md#flite) | [picotts](text-to-speech.md#picotts) | [nanotts](text-to-speech.md#nanotts) | [marytts](text-to-speech.md#marytts) | [opentts](text-to-speech.md#opentts) | [wavenet](text-to-speech.md#google-wavenet) | [larynx](text-to-speech.md#larynx) |
| en       | &#x2713;                           | &#x2713;                         | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                                    |                                    |
| de       | &#x2713;                           |                                  | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                                    | &#x2713;                           |
| es       | &#x2713;                           |                                  | &#x2713;                             | &#x2713;                             |                                      | &#x2713;                             | &#x2713;                                    |                                    |
| fr       | &#x2713;                           |                                  | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                                    | &#x2713;                           |
| it       | &#x2713;                           |                                  | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                             | &#x2713;                                    |                                    |
| nl       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             | &#x2713;                                    | &#x2713;                           |
| ru       | &#x2713;                           |                                  |                                      |                                      | &#x2713;                             | &#x2713;                             | &#x2713;                                    |                                    |
| el       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             |                                             |                                    |
| hi       | &#x2713;                           | &#x2713;                         |                                      |                                      |                                      | &#x2713;                             | &#x2713;                                    |                                    |
| zh       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             | &#x2713;                                    |                                    |
| vi       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             |                                             |                                    |
| pt       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             | &#x2713;                                    |                                    |
| ca       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             |                                             |                                    |
| cs       | &#x2713;                           |                                  |                                      |                                      |                                      | &#x2713;                             | &#x2713;                                    |                                    |

---

## eSpeak

Uses [eSpeak](http://espeak.sourceforge.net) to speak sentences. This is the default text to speech system and, while it sounds robotic, has the widest support for different languages.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "espeak",
  "espeak": {
    "voice": "en"
  }
}
```

Remove the `voice` option to have `espeak` use your profile's language automatically.

You may also pass additional arguments to the `espeak` command. For example,

```json
"text_to_speech": {
  "system": "espeak",
  "espeak": {
    "arguments": ["-s", "80"]
  }
}
```

will speak the sentence more slowly.

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## Flite

Uses FestVox's [flite](http://www.festvox.org/flite) for speech. Sounds better than `espeak` in most cases, but supports fewer languages out of the box.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "flite",
  "flite": {
    "voice": "kal16"
  }
}
```

Some other included voices are `rms`, `slt`, and `awb`.

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## PicoTTS

Uses SVOX's [picotts](https://en.wikipedia.org/wiki/SVOX) for text to speech. Sounds a bit better (to me) than `flite` or `espeak`.

Included languages are `en-US`, `en-GB`, `de-DE`, `es-ES`, `fr-FR` and `it-IT`.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "picotts",
  "picotts": {
    "language": "en-US"
  }
}
```

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## NanoTTS

Uses an [improved fork](https://github.com/gmn/nanotts) of SVOX's picoTTS for text to speech.

Included languages are `en-US`, `en-GB`, `de-DE`, `es-ES`, `fr-FR` and `it-IT`.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "nanotts",
  "nanotts": {
    "language": "en-GB"
  }
}
```

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## MaryTTS

Uses a remote [MaryTTS](http://mary.dfki.de/) web server. Supported languages include German, British and American English, French, Italian, Luxembourgish, Russian, Swedish, Telugu, and Turkish. A [MaryTTS Docker image](https://hub.docker.com/r/synesthesiam/marytts) is available with many voices included.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "marytts",
  "marytts": {
    "url": "http://localhost:59125/process",
    "voice": "cmu-slt",
    "locale": "en-US"
  }
}
```

To run the Docker image, simply execute:

```bash
$ docker run -it -p 59125:59125 synesthesiam/marytts:5.2
```

and visit [http://localhost:59125](http://localhost:59125) after it starts.

If you're using [docker compose](https://docs.docker.com/compose/), add the following to your docker-compose.yml file:

```yaml
services:
  marytts:
    image: synesthesiam/marytts:5.2
    ports:
      - 59125:59125
```

When using docker-compose, set `marytts.url` in your profile to be `http://marytts:59125/process`.  This will allow Rhasspy to resolve the address of its sibling container.

To save memory when running on a Raspberry Pi, considering [restricting the loaded voices](https://github.com/synesthesiam/docker-marytts#restricting-voices) by passing one or more `--voice <VOICE>` command-line arguments to the Docker container.

### Audio Effects

**Not supported yet in 2.5!**

MaryTTS is capable of applying several audio effects when producing speech.  See the web interface at [http://localhost:59125](http://localhost:59125)
to experiment with this.

To use these effects within Rhasspy, set `text_to_speech.marytts.effects` within your profile, for example:

```json
"text_to_speech": {
   "system": "marytts",
   "marytts": {
        "url": "http://localhost:59125/process",
        "effects": {
            "effect_Volume_selected": "on",
            "effect_Volume_parameters": "amount=0.9;",
            "effect_TractScaler_selected": "on",
            "effect_TractScaler_parameters": "amount:1.2;",
            "effect_F0Add_selected": "on",
            "effect_F0Add_parameters": "f0Add:-50.0;",
            "effect_Robot_selected": "on",
            "effect_Robot_parameters": "amount=50.0;"
        }
    }
}
```

You can determine the names of the parameters by examining the web interface [http://localhost:59125](http://localhost:59125)
using your browser's Developer Tools.

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## OpenTTS

Uses a remote [OpenTTS](https://github.com/synesthesiam/opentts) web server. Supports many different text to speech systems, including [Mozilla TTS](https://hub.docker.com/r/synesthesiam/mozilla-tts).

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "opentts",
  "opentts": {
    "url": "http://localhost:5500",
    "voice": "nanaotts:en-GB"
  }
}
```

Voices in OpenTTS have the format `<system>:<voice>` where `<system>` is the text to speech system (e.g., `espeak`, `flite`, `festival`, `nanotts`, `marytts`, `mozillatts`) and `<voice>` is the id of the voice within that system. Visit the test page at [http://localhost:5500](http://localhost:5500) to see and test available voices.

To run the Docker image, simply execute:

```bash
$ docker run -it -p 5500:5500 synesthesiam/opentts
```

and visit [http://localhost:5500](http://localhost:5500) after it starts.

If you're using [docker compose](https://docs.docker.com/compose/), add the following to your docker-compose.yml file:

```yaml
services:
  opentts:
    image: synesthesiam/opentts
    ports:
      - 5500:5500
```

To run the full suite of text to speech systems offered by OpenTTS, add:

```yaml
services:
  opentts:
    image: synesthesiam/opentts
    ports:
      - 5500:5500
    command: --marytts-url http://marytts:59125 --mozillatts-url http://mozillatts:5002
    tty: true
  marytts:
    image: synesthesiam/marytts:5.2
    tty: true
  mozillatts:
    image: synesthesiam/mozilla-tts
    tty: true
```

**NOTE:** Mozilla TTS will not run on a Raspberry Pi.

When using docker-compose, set `opentts.url` in your profile to be `http://opentts:5500`.  This will allow Rhasspy to resolve the address of its sibling container.

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## Google WaveNet

Uses Google's [WaveNet](https://cloud.google.com/text-to-speech/docs/wavenet) text to speech system. This **requires a Google account and an internet connection to function**. Rhasspy will cache WAV files for previously spoken sentences, but you will be sending Google information for every new sentence that Rhasspy speaks.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "wavenet",
  "wavenet": {
    "cache_dir": "tts/googlewavenet/cache",
    "credentials_json": "tts/googlewavenet/credentials.json",
    "gender": "FEMALE",
    "language_code": "en-US",
    "sample_rate": 22050,
    "url": "https://texttospeech.googleapis.com/v1/text:synthesize",
    "voice": "Wavenet-C"
  }
}
```

Before using WaveNet, you must set up a Google cloud account and [generate a JSON credentials file](https://cloud.google.com/text-to-speech/docs/reference/libraries#setting_up_authentication). Save the JSON credentials file to wherever `wavenet.credentials_json` points to in your profile directory. You may also need to visit your Google cloud account settings and enable the text-to-speech API.

WAV files of each sentence are cached in `wavenet.cache_dir` in your profile directory. Sentences are cached based on their text and the `gender`, `voice`, `language_code`, and `sample_rate` of the `wavenet` system. Changing any of these things will require using the Google API.

Contributed by [Romkabouter](https://github.com/Romkabouter).

Implemented by [rhasspy-tts-wavenet-hermes](https://github.com/rhasspy/rhasspy-tts-wavenet-hermes)

## Larynx

[Text to speech system](https://github.com/rhasspy/larynx) based on [a fork](https://github.com/rhasspy/TTS) of [MozillaTTS](https://github.com/mozilla/TTS). Uses pre-trained [PyTorch](https://pytorch.org) models and vocoders from public single-speaker datasets.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "larynx",
  "larynx": {
    "cache_dir": "tts/larynx/cache",
    "default_voice": "myvoice",
    "voices": {
      "myvoice" {
        "model": "/path/to/tts_checkpoint.pth.tar",
        "config": "/path/to/tts_config.json",
        "vocoder_model": "/path/to/vocoder_checkpoint.pth.tar",
        "vocoder_config": "/path/to/vocoder_config.json",
      }
    }
  }
}
```

The `model` property is required for each voice. If `config` is missing, a file named `config.json` is assumed to exist in the same directory as the model checkpoint file. The `vocoder_model` and `vocoder_config` properties are optional. Vocoders and TTS models must currently share the same audio details (sample rate, etc.).

* Supported model types:
  * Tacotron2
  * Glow-TTS
Supported vocoder types:
    * Multi-band MelGAN
    * Fullband MelGAN
    
Available voices:
    * Dutch
        * [nl-rdh](https://github.com/rhasspy/nl_larynx-rdh)
        
Please contact a Rhasspy developer if you'd like to volunteer your voice!

Implemented by [rhasspy-tts-larynx-hermes](https://github.com/rhasspy/rhasspy-tts-larynx-hermes)

## Home Assistant TTS Platform

**Not supported yet in 2.5!**

Use a [TTS platform](https://www.home-assistant.io/integrations/tts) on your Home Assistant server.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "hass_tts",
  "hass_tts": {
      "platform": "..."
  }
}
```

The settings from your profile's `home_assistant` section are automatically used (URL, access token, etc.).

## Remote

Simply POSTs the sentence to be spoken to an HTTP endpoint. Expects [WAV audio](https://en.wikipedia.org/wiki/WAV) back with a `Content-Type: audio/wav` header.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "remote",
  "remote": {
      "url": "http://tts-server/endpoint"
  }
}
```

The `lang` property of [`hermes/tts/say`](reference.md#tts_say) is not empty, a query parameter `language` is added to the URL (e.g., `http://tts-server/endpoint?language=<lang>`).

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Command

You can extend Rhasspy easily with your own external text to speech system. When a sentence needs to be spoken, Rhasspy will call your custom program with the text given on standard in. Your program should return the corresponding WAV data on standard out.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "command",
  "command": {
      "say_program": "/path/to/say/program",
      "say_arguments": [],
      "voices_program": "/path/to/voices/program",
      "voices_arguments": [],
      "language": ""
  }
}
```

The `text_to_speech.command.say_program` is executed each time a text to speech request is made with arguments from `text_to_speech.command.say_arguments`. The command is run through Python's `str.format` function with a `lang` keyword argument set to `text_to_speech.command.language` (so `{lang}` is replaced). Rhasspy passes the sentence as the first command-line argument to the program and expects [WAV audio](https://en.wikipedia.org/wiki/WAV) back on standard out.

If provided, the `text_to_speech.command.voices_program` will be executed when a [`rhasspy/tts/getVoices`](reference.md#tts_getvoices) message is received. The program should return a listing of available voices, one per line with the first whitespace-separated column being a unique voice ID.

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes)

## Dummy

Disables text to speech.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "dummy"
}
```
