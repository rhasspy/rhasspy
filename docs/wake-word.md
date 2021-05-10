# Wake Word

The typical workflow for interacting with a voice assistant is to first activate it with a "wake" or "hot" word, then provide your voice command. Rhasspy supports listening for a wake word with one of several systems.

Available wake word systems are:

* [Raven](wake-word.md#raven)
* [Porcupine](wake-word.md#porcupine)
* [Snowboy](wake-word.md#snowboy)
* [Mycroft Precise](wake-word.md#precise)
* [Pocketsphinx](wake-word.md#pocketsphinx)
* [External Command](wake-word.md#command)

You can also wake Rhasspy up using the [HTTP API](usage.md#http-api) by POST-ing to `/api/listen-for-command`. Rhasspy will immediately wake up and start listening for a voice command.

The following table summarizes the key characteristics of each wake word system:

| System                                    | Performance | Training to Customize | Online Sign Up          |
| ------                                    | ----------- | -----------------     | ----------------------- |
| [raven](wake-word.md#raven)               | moderate    | yes, offline          | no                      |
| [porcupine](wake-word.md#porcupine)       | excellent   | yes, offline          | no                      |
| [snowboy](wake-word.md#snowboy)           | good        | yes, offline          | no                      |
| [precise](wake-word.md#mycroft-precise)   | moderate    | yes, offline          | no                      |
| [pocketsphinx](wake-word.md#pocketsphinx) | poor        | no                    | no                      |

## MQTT/Hermes

Rhasspy listens for `hermes/hotword/<wakewordId>/detected` messages to decide when to wake up. The `hermes/hotword/toggleOff` and `hermes/hotword/toggleOff` messages can be used to disable/enable wake word listening (done automatically during voice command recording and audio output).

## Raven

Listens for a wake word with [Raven](https://github.com/rhasspy/rhasspy-wake-raven). This system is based on the [Snips Personal Wakeword Detector](https://medium.com/snips-ai/machine-learning-on-voice-a-gentle-introduction-with-snips-personal-wake-word-detector-133bd6fb568e) and works by comparing incoming audio to several pre-recorded templates.

<div style="border: 1px solid green; padding: 5px; margin: 0 0 1rem 0;">
    See the <a href="../tutorials/#custom-wakeword-with-raven">Raven tutorial</a> for how to get started.
</div>

The underlying implementation of Raven heavily borrows from [node-personal-wakeword](https://github.com/mathquis/node-personal-wakeword) by [mathquis](https://github.com/mathquis).

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "raven",
  "raven": {
    "probability_threshold": 0.5,
    "minimum_matches": 1,
    "average_templates": true
  }
}
```

To train Raven, you will need to record at least 3 WAV template files with your custom wake word. This can be done in the Rhasspy web interface or manually with a program like [Audacity](https://www.audacityteam.org/). If you record manually, make sure to trim silence from the beginning and end of the audio and export the templates to a directory named `raven/default` in your profile as 16-bit 16Khz mono WAV files.

You can adjust the sensitivity by changing `raven.probability_threshold` to a value in `[0, 1]` (realistically between 0.1 and 0.73). A value below 0.5 will make Raven more sensitive, increasing false positives. A value above 0.5 will make Raven less sensitive, increasing false negatives. Additionally, you can increase the value of `minmum_matches` to required more than one WAV template to match before a detection occurs. This should reduce false positives, but may increase false negatives.

The `average_templates` setting will combine all of the example WAV templates into a single template, reducing CPU usage. This may also reduce accuracy, but the loss appears negligible in practice.

### Multiple Wake Words

Raven supports any number of wake words, and is only limited by CPU. A separate thread is used for each wake word detection in order to utilize multiple cores. To add more keywords to Raven, you must edit your profile:

```json
"wake": {
  "system": "raven",
  "raven": {
      ...

      "keywords": {
          "default": {
              "probability_threshold": 0.4
          },
          
          "other-keyword": {
              "average_templates": False,
              "minimum_matches": 2
          }
      }
  }
}
```

The `wake.raven.keywords` object contains a key for each wake/keyword and their individual settings. If you don't specify a setting, the value under `wake.raven` is used instead.

A keyword whose key is `NAME` should have it's WAV templates stored in `raven/NAME` in your profile directory. Changing the "Wakeword Id" in the Raven section of Rhasspy's web UI will allow you to record examples to the appropriate directory (`NAME` = Wakeword Id).

### Saving Positive Examples

Setting `wake.raven.examples_dir` to the name of a directory in your profile will cause Raven to save WAV audio of any positive wakeword detections to `DIR/NAME/FORMAT` where `DIR` is `wake.raven.examples_dir`, `NAME` is the keyword name (e.g., "default"), and `FORMAT` is a `strftime` format string specified in `wake.raven.examples_format`. For example:

```json
"wake": {
  "system": "raven",
  "raven": {
      ...

      "examples_dir": "raven"
  }
}
```

will save positive WAV examples to `raven/default/examples`. These examples could be used to train a more sophisticated wake word system like [Mycroft Precise](#mycroft-precise).

### UDP Audio Streaming

By default, Rhasspy will stream microphone audio over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite has woken up. For this case, set **both** `microphone.<MICROPHONE_SYSTEM>.udp_audio` and `wake.raven.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-wake-raven-hermes](https://github.com/rhasspy/rhasspy-wake-raven-hermes)


## Porcupine

Listens for a wake word with [porcupine](https://github.com/Picovoice/Porcupine). This system has the best performance out of the box. If you want a custom wake word, however, you will need to re-run their optimizer tool every 30 days.

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "porcupine",
  "porcupine": {
    "sensitivity": 0.5
  }
}
```

There are a lot of [keyword files](https://github.com/Picovoice/Porcupine/tree/master/resources/keyword_files) available for download. Use the `linux` platform if you're on desktop/laptop (`amd64`) and the `raspberrypi` platform if you're using a Raspberry Pi (`armhf`/`aarch64`). The `.ppn` files should go in the `porcupine` directory inside your profile (referenced by `keyword_path`).

If you want to create a custom wake word, you will need to use the [Picovoice Console](https://github.com/Picovoice/porcupine#picovoice-console). **NOTE**: the generated keyword file is only valid for 30 days, though you can always just re-run the optimizer.

### UDP Audio Streaming

By default, Rhasspy will stream microphone audio over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite has woken up. For this case, set **both** `microphone.<MICROPHONE_SYSTEM>.udp_audio` and `wake.porcupine.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-wake-porcupine-hermes](https://github.com/rhasspy/rhasspy-wake-porcupine-hermes)

## Snowboy

Listens for one or more wake words with [snowboy](https://snowboy.kitt.ai). This system has the good performance out of the box, but requires an online service to train.

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "snowboy",
  "hermes": {
    "wakeword_id": "default"
  },
  "snowboy": {
    "model": "snowboy/snowboy.umdl",
    "audio_gain": 1,
    "sensitivity": "0.5",
    "apply_frontend": false
  }
}
```

If your hotword model has multiple embedded hotwords (such as `jarvis.umdl`), the "sensitivity" parameter should contain sensitivities for each embedded hotword separated by commas (e.g., "0.5,0.5").

To train your own wake word model, see [seasalt-ai](https://github.com/seasalt-ai/snowboy). The resulting file, ending with `.pmdl`, should go in your profile directory. Then, set `wake.snowboy.model` to the name of that file.

You also have the option of using a pre-train *universal* model (`.umdl`) from [Kitt.AI](https://github.com/Kitt-AI/snowboy/tree/master/resources/models).

### Multiple Wake Words

You can have `snowboy` listen for multiple wake words with different models, each with their own settings. You will need to download each model file to the `snowboy` directory in your profile.

For example, to use both the `snowboy.umdl` and `jarvis.umdl` models, add this to your profile:

```json
"wake": {
  "system": "snowboy",
  "snowboy": {
    "model": "snowboy/snowboy.umdl,snowboy/jarvis.umdl",
    "model_settings": {
      "snowboy/snowboy.umdl": {
        "sensitivity": "0.5",
        "audio_gain": 1,
        "apply_frontend": false
      },
      "snowboy/jarvis.umdl": {
        "sensitivity": "0.5,0.5",
        "audio_gain": 1,
        "apply_frontend": false
      }
    }
  }
}
```

Make sure to include all models you want in the `model` setting (separated by commas). Each model may have different settings in `model_settings`. If a setting is not present, the default values under `snowboy` will be used.

### UDP Audio Streaming

By default, Rhasspy will stream microphone audio over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite has woken up. For this case, set **both** `microphone.<MICROPHONE_SYSTEM>.udp_audio` and `wake.snowboy.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-wake-snowboy-hermes](https://github.com/rhasspy/rhasspy-wake-snowboy-hermes)

## Mycroft Precise

Listens for a wake word with [Mycroft Precise](https://github.com/MycroftAI/mycroft-precise). It requires training up front, but can be done completely offline!

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "precise",
  "precise": {
    "model": "model-name.pb",
    "sensitivity": 0.5,
    "trigger_level": 3,
    "chunk_size": 2048
  }
}
```

Follow [the instructions from Mycroft AI](https://github.com/MycroftAI/mycroft-precise/wiki/Training-your-own-wake-word#how-to-train-your-own-wake-word) to train your own wake word model. When you're finished, place **both** the `.pb` and `.pb.params` files in the `precise` directory of your profile. Then set `wake.precise.model` to the name of the `.pb` file (e.g., `my-wake-word.pb`).

### UDP Audio Streaming

By default, Rhasspy will stream microphone audio over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite has woken up. For this case, set **both** `microphone.<MICROPHONE_SYSTEM>.udp_audio` and `wake.precise.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-wake-precise-hermes](https://github.com/rhasspy/rhasspy-wake-precise-hermes)

## Pocketsphinx

Listens for a [keyphrase](https://cmusphinx.github.io/wiki/tutoriallm/#using-keyword-lists-with-pocketsphinx) using [pocketsphinx](https://github.com/cmusphinx/pocketsphinx). This is the most flexible wake system, but has the worst performance in terms of false positives/negatives.

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "pocketsphinx",
  "pocketsphinx": {
    "keyphrase": "okay rhasspy",
    "threshold": 1e-30,
    "chunk_size": 960
  }
}
```

Set `wake.pocketsphinx.keyphrase` to whatever you like, though 3-4 syllables is recommended. Make sure to [train](training.md) and restart Rhasspy whenever you change the keyphrase.

The `wake.pocketsphinx.threshold` should be in the range 1e-50 to 1e-5. The smaller the number, the less like the keyphrase is to be observed. At least one person has written a script to [automatically tune the threshold](https://medium.com/@PankajB96/automatic-tuning-of-keyword-spotting-thresholds-a27256869d31).

### UDP Audio Streaming

By default, Rhasspy will stream microphone audio over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite has woken up. For this case, set **both** `microphone.<MICROPHONE_SYSTEM>.udp_audio` and `wake.pocketsphinx.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-wake-pocketsphinx-hermes](https://github.com/rhasspy/rhasspy-wake-pocketsphinx-hermes)

## Command

Calls a custom external program to listen for a wake word, only waking up Rhasspy when the program exits. A `wakewordId` should be printed to standard out before exiting. You will receive chunks of raw audio on standard in.

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "command",
  "command": {
    "program": "/path/to/program",
    "arguments": [],
    "sample_rate": 16000,
    "sample_width": 2,
    "channels": 1
  }
}
```

When Rhasspy starts, your program will be called with the given arguments. Raw audio chunks will be written to standard in as Rhasspy receives `hermes/audioServer/<siteId>/audioFrame` messages. This audio is automatically converted to the format given by `wake.command.sample_rate` (hertz), `wake.command.sample_width` (bytes), and `wake.command.channels`.

Once your program detects the wake word, it should print a `wakewordId` to standard out and exit. Rhasspy will call your program again when it goes back to sleep. If the empty string is printed, Rhasspy will use "default" for the `wakewordId`.

The following environment variables are available to your program:

* `$RHASSPY_BASE_DIR` - path to the directory where Rhasspy is running from
* `$RHASSPY_PROFILE` - name of the current profile (e.g., "en")
* `$RHASSPY_PROFILE_DIR` - directory of the current profile (where `profile.json` is)

See [sleep.sh](https://github.com/synesthesiam/rhasspy/blob/master/bin/mock-commands/sleep.sh) for an example program.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Dummy

Disables wake word functionality.

Add to your [profile](profiles.md):

```json
"wake": {
  "system": "dummy"
}
```
