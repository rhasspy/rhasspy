# Text to Speech

After you voice command has been [handled](intent-handling.md), it's common to produce speech as a response back to the user. Rhasspy has support for several text to speech systems which, importantly, can be played through any of the [audio output](audio-output.md) systems.

The following table summarizes language support for the various text to speech systems:

| System                                      | en       | de       | es       | fr       | it       | nl       | ru       | el       | hi       | zh       | vi       | pt       | ca       |
| ------                                      | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  | -------  |
| [espeak](text-to-speech.md#espeak)          | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |
| [flite](text-to-speech.md#flite)            | &#x2713; |          |          |          |          |          |          |          | &#x2713; |          |          |          |          |
| [picotts](text-to-speech.md#picotts)        | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          |          |          |          |          |          |          |          |
| [marytts](text-to-speech.md#marytts)        | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |          | &#x2713; |          |          |          |          |          |          |
| [wavenet](text-to-speech.md#google-wavenet) | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; | &#x2713; |          | &#x2713; | &#x2713; |          | &#x2713; |          |

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

## MaryTTS

Uses a remote [MaryTTS](http://mary.dfki.de/) web server. Supported languages include German, British and American English, French, Italian, Luxembourgish, Russian, Swedish, Telugu, and Turkish. An [MaryTTS Docker image](https://hub.docker.com/r/synesthesiam/marytts) is available, though only the default voice is included.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "marytts",
  "marytts": {
    "url": "http://localhost:59125",
    "voice": "cmu-slt",
    "locale": "en-US"
  }
}
```

To run the Docker image, simply execute:

```bash
docker run -it -p 59125:59125 synesthesiam/marytts:5.2
```

and visit [http://localhost:59125](http://localhost:59125) after it starts. 

If you're using [docker compose](https://docs.docker.com/compose/), add the following to your docker-compose.yml file:

    marytts:
      image: synesthesiam/marytts:5.2
      restart: unless-stopped
      ports:
        - "59125:59125"

When using docker-compose, set `marytts.url` in your profile to be `http://marytts:59125`.  This will allow rhasspy, from within 
its docker container, to resolve and connect to marytts (its sibling container).


### Adding Voices

For more English voices, run the following commands in a Bash shell:

```bash
mkdir -p marytts-5.2/download
for voice in dfki-prudence dfki-poppy dfki-obadiah dfki-spike cmu-bdl cmu-rms;
  do wget -O marytts-5.2/download/voice-${voice}-hsmm-5.2.zip https://github.com/marytts/voice-${voice}-hsmm/releases/download/v5.2/voice-${voice}-hsmm-5.2.zip;
  unzip -d marytts-5.2 marytts-5.2/download/voice-${voice}-hsmm-5.2.zip;
done
```

Now run the Docker image again with the following command (in the same directory):

```bash
voice=dfki-prudence
docker run -it -p 59125:59125 -v "$(pwd)/marytts-5.2/lib/voice-${voice}-hsmm-5.2.jar:/marytts/lib/voice-${voice}-hsmm-5.2.jar" synesthesiam/marytts:5.2
```

Change the first line to select the voice you'd like to add. It's not recommended to link in all of the voices at once, since MaryTTS seems to load them all into memory and overwhelm the RAM of a Raspberry Pi.

See `rhasspy.tts.MaryTTSSentenceSpeaker` for details.

### Audio Effects

MaryTTS is capable of applying several audio effects when producing speech.  See the web interface at [http://localhost:59125](http://localhost:59125)
to experiment with this.


To use these effects within Rhasspy, set `text_to_speech.marytts.effects` within your profile, for example:

```json
"text_to_speech": {
   "system": "marytts",
   "marytts": {
        "url": "http://localhost:59125",
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
    "voice": "Wavenet-C",
    "fallback_tts": "espeak"
  }
}
```

Before using WaveNet, you must set up a Google cloud account and [generate a JSON credentials file](https://cloud.google.com/text-to-speech/docs/reference/libraries#setting_up_authentication). Save the JSON credentials file to wherever `wavenet.credentials_json` points to in your profile directory. You may also need to visit your Google cloud account settings and enable the text-to-speech API.

WAV files of each sentence are cached in `wavenet.cache_dir` in your profile directory. Sentences are cached based on their text and the `gender`, `voice`, `language_code`, and `sample_rate` of the `wavenet` system. Changing any of these things will require using the Google API.

If there are problems using the Google API (e.g., your internet connection fails), Rhasspy will switch over to the text to speech system given in `wavenet.fallback_tts`. The settings for the fallback system will be loaded from your profile as expected.

Contributed by [Romkabouter](https://github.com/Romkabouter).

TODO: Unimplemented

## Home Assistant TTS Platform

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

TODO: Unimplemented

## Remote

Simply POSTs the sentence to be spoken to an HTTP endpoint.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "remote",
  "remote": {
      "url": "http://tts-server/endpoint"
  }
}
```

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Command

You can extend Rhasspy easily with your own external text to speech system. When a sentence needs to be spoken, Rhasspy will call your custom program with the text given on standard in. Your program should return the corresponding WAV data on standard out.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "command",
  "command": {
      "program": "/path/to/program",
      "arguments": []
  }
}
```

Implemented by [rhasspy-tts-cli-hermes](https://github.com/rhasspy/rhasspy-tts-cli-hermes) and [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Dummy

Disables text to speech.

Add to your [profile](profiles.md):

```json
"text_to_speech": {
  "system": "dummy"
}
```

See `rhasspy.tts.DummySentenceSpeaker` for details.
