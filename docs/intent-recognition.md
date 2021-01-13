# Intent Recognition

After your voice command has been transcribed by the [speech to text](speech-to-text.md) system, the next step is to recognize your intent.
The end result is a JSON event with information about the intent.

Available intent recognition systems are:

* [Fsticuffs](intent-recognition.md#fsticuffs)
* [Fuzzywuzzy](intent-recognition.md#fuzzywuzzy)
* [Snips NLU](intent-recognition.md#snips-nlu)
* [RasaNLU](intent-recognition.md#rasanlu)
* [Mycroft Adapt](intent-recognition.md#mycroft-adapt)
* [Flair](intent-recognition.md#flair)
* [Remote HTTP Server](intent-recognition.md#remote-http-server)
* [External Command](intent-recognition.md#command)

The following table summarizes the trade-offs of using each intent recognizer:

| System                                               | Ideal Sentence count | Training Speed | Recognition Speed | Flexibility                   |
| --------                                             | ----                 | --------       | -----             | -------------                 |
| [Fsticuffs](intent-recognition.md#fsticuffs)         | 1M+                  | very fast      | very fast         | ignores unknown words         |
| [Fuzzywuzzy](intent-recognition.md#fuzzywuzzy)       | 100-1K               | fast           | very fast         | fuzzy string matching         |
| [Snips NLU](intent-recognition.md#snips-nlu)         | 1K-100K              | moderate       | very fast         | handles unseen words/entities |
| [RasaNLU](intent-recognition.md#rasanlu)             | 1K-100K              | very slow      | moderate          | handles unseen words          |
| [Mycroft Adapt](intent-recognition.md#mycroft-adapt) | 100-1K               | moderate       | fast              | ignores unknown words         |
| [Flair](intent-recognition.md#flair)                 | 1K-100K              | very slow      | moderate          | handles unseen words          |

## MQTT/Hermes

Rhasspy receives intent recognition requests on the `hermes/nlu/query` topic. Successful recognitions are published to `hermes/intent/<intentName>`, and unsuccessful recognitions to `hermes/nlu/intentNotRecognized` The format of these messages adheres to the [Hermes protocol](https://docs.snips.ai/reference/dialogue#intent).

You can react to these intent recognitions in your own programs, for example using the [rhasspy-hermes-app](https://rhasspy-hermes-app.readthedocs.io) library.

## Fsticuffs

Uses the [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) library to recognize **only** those sentences that Rhasspy was [trained on](training.md#sentencesini). While less flexible than the other intent recognizers, `fsticuffs` can be trained and perform recognition over *millions* of sentences in milliseconds. If you only plan to recognize voice commands from your training set (and not unseen ones via text chat), `fsticuffs` is the best choice.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "fsticuffs",
  "fsticuffs": {
    "intent_graph": "intent.json",
    "ignore_unknown_words": true,
    "fuzzy": true
  }
}
```

By default, fuzzy mathing is enabled (`fuzzy` is true). This allows `fsticuffs` to be less strict when matching text, skipping over any words in the profile's `stop_words.txt`, and handling repeated words gracefully. Words must still appear in the correct order according to `sentences.ini`, but additional words will not cause a recognition failure.

When `ignore_unknown_words` is true, any word outside of `sentences.ini` is silently ignored. This allows a lot more sentences to be accepted, but may cause unexpected results when used with arbitrary input from text chat.

Implemented by [rhasspy-nlu-hermes](https://github.com/rhasspy/rhasspy-nlu-hermes)

## Fuzzywuzzy

Finds the closest matching intent by using the [rapidfuzz library](https://github.com/maxbachmann/rapidfuzz) between the text and all of the [training sentences](training.md#sentencesini) you provided. Works best when you have a small number of sentences (dozens to hundreds) and need some resiliency to spelling errors (i.e., from text chat).

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "fuzzywuzzy",
  "fuzzywuzzy": {
    "examples_json": "intent_examples.json"
  }
}
```

Implemented by [rhasspy-fuzzywuzzy-hermes](https://github.com/rhasspy/rhasspy-fuzzywuzzy-hermes)

## Snips NLU

Uses [Snips NLU](https://github.com/snipsco/snips-nlu) to flexibly recognize sentences in the following languages: de, en, es, fr, it, ja, ko, pt_br, pt_pt, zh.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "snips",
  "snips": {
    "language": "",
    "engine_dir": "snips/engine",
    "dataset_file": "snips/dataset.yaml"
  }
}
```

If `intent.snips.language` is not specified, the profile's `language` is used. The `engine_dir` and `dataset_file` properties control where in your profile directory the generated engine and YAML dataset files are stored during training.

Number ranges are automatically converted into `snips/number` entities. All [tags](training.md#tags) are considered Snips slots. If a Rhasspy [slots list](training.md#slots-lists) is contained within the tag, the name of the Rhasspy `$slot` will become the Snips entity name. Otherwise, the tag name is used and **shared** across intents.

Implemented by [rhasspy-snips-nlu-hermes](https://github.com/rhasspy/rhasspy-snips-nlu-hermes)


## RasaNLU

Recognizes intents **remotely** using a [Rasa NLU](https://rasa.com/) server. You must [install a Rasa NLU server](https://rasa.com/docs/rasa/user-guide/installation/) somewhere that Rhasspy can access. Works well when you have a large number of sentences (thousands to hundreds of thousands) and need to handle sentences *and* words not seen during training. This needs Rasa 1.0 or higher.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "rasa",
  "rasa": {
    "examples_markdown": "intent_examples.md",
    "project_name": "rhasspy",
    "url": "http://localhost:5005/"
  }
}
```

Set `intent.rasa.config_yaml` to the name of a file in your profile directory if you want to use a custom configuration during training. If unset, the default configuration is:

```yaml
language: "en"
pipeline: "pretrained_embeddings_spacy"
```

where "en" is replaced with your profile's language or the value of `intent.rasa.language`.

### Installing Rasa NLU

If you have Docker, Rasa NLU can be run with (only on the Linux/amd64 architecture):

```bash
docker run -it -v "$(pwd):/app" -p 5005:5005 rasa/rasa:latest-spacy-en run --enable-api
```

Your Rasa NLU server should now be accessible at [http://localhost:5005](http://localhost:5005). Models will be saved in the `models` directory (relative to your current directory).

Implemented by [rhasspy-rasa-nlu-hermes](https://github.com/rhasspy/rhasspy-rasa-nlu-hermes)

## Mycroft Adapt

**Not supported yet in 2.5!**

Recognizes intents using [Mycroft Adapt](https://github.com/MycroftAI/adapt). Works best when you have a medium number of sentences (hundreds to thousands) and need to be able to recognize sentences not seen during training (no new words, though).

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "adapt",
  "adapt": {
      "stop_words": "stop_words.txt"
  }
}
```

The `intent.adapt.stop_words` text file contains words that should be ignored (i.e., cannot be "required" or "optional").

## Flair

**Not supported yet in 2.5!**

Recognizes intents using the [flair NLP framework](https://github.com/zalandoresearch/flair). Works best when you have a large number of sentences (thousands to hundreds of thousands) and need to handle sentences *and* words not seen during training.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "flair",
  "flair": {
      "data_dir": "flair_data",
      "max_epochs": 25,
      "do_sampling": true,
      "num_samples": 10000
  }
}
```

By default, the flair recognizer will generate 10,000 random sentences (`num_samples`) from each intent in your [sentences.ini](training.md#sentencesini) file. If you set `do_sampling` to `false`, Rhasspy will generate **all** possible sentences and use them as training data. This will produce the most accurate models, but may take a *long* time depending on the complexity of your grammars.

A flair `TextClassifier` will be trained to classify unseen sentences by intent, and a `SequenceTagger` will be trained for each intent that has at least one [tag](training.md#tags). During recognition, sentences are first classified by intent and then run through the appropriate `SequenceTagger` model to determine slots/entities.

## Remote HTTP Server

Uses a remote Rhasppy server to do intent recognition. POSTs the text to an HTTP endpoint and receives an intent as JSON. An empty `intent.name` property of the returned JSON object indicates a recognition failure.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "remote",
  "remote": {
    "url": "http://my-server:12101/api/text-to-intent"
  }
}
```

If you want to also POST to an endpoint during training, add to your profile:

```json
"training": {
  "system": "auto",
  "intent": {
    "remote": {
      "url": "http://my-server/intent-training-endpoint"
    }
  }
}
```

If `training.intent.remote.url` is set, Rhasspy will POST the intent graph generated by [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) to your endpoint as JSON. No response is expected, though an HTTP error code indicates that training has failed.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Home Assistant Conversation

**Not supported yet in 2.5!**

Sends transcriptions from [speech to text](speech-to-text.md) to [Home Assistant's conversation API](https://www.home-assistant.io/integrations/conversation/). If the response contains speech, Rhasspy can optionally speak it.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "conversation",
  "conversation": {
    "handle_speech": true
  }
}
```

When `handle_speech` is `true`, Rhasspy will forward the returned speech to your [text to speech](text-to-speech.md) system.

The settings from your profile's `home_assistant` section are automatically used (URL, access token, etc.).

Because Home Assistant will already handle your intent (probably using an [intent script](https://www.home-assistant.io/integrations/intent_script/)), Rhasspy will always generate an empty intent with this recognizer.

## Command

Recognizes intents from text using a custom external program. Your program should return a JSON object that describes the recognized intent; something like:

```json
{
  "intent": {
    "name": "ChangeLightColor",
    "confidence": 1.0
  },
  "entities": [
    { "entity": "name",
      "value": "bedroom light" },
    { "entity": "color",
      "value": "red" }
  ],
  "text": "set the bedroom light to red"
}
```
An empty `intent.name` property indicates a recognition failure.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "command",
  "command": {
    "program": "/path/to/program",
    "arguments": []
  }
}
```

If you want to also call an external program during training, add to your profile:

```json
"training": {
  "system": "auto",
  "intent": {
    "command": {
      "program": "/path/to/training/program",
      "arguments": []
    }
  }
}
```

If `training.intent.command.program` is set, Rhasspy will call your program with the intent graph generated by [rhasspy-nlu](https://github.com/rhasspy/rhasspy-nlu) provided as JSON on standard input. No response is expected, though a non-zero exit code indicates a training failure.

The following environment variables are available to your program:

* `$RHASSPY_BASE_DIR` - path to the directory where Rhasspy is running from
* `$RHASSPY_PROFILE` - name of the current profile (e.g., "en")
* `$RHASSPY_PROFILE_DIR` - directory of the current profile (where `profile.json` is)

See [text2intent.sh](https://github.com/synesthesiam/rhasspy/blob/master/bin/mock-commands/text2intent.sh) for an example program.

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Dummy

Disables intent recognition.

Add to your [profile](profiles.md):

```json
"intent": {
  "system": "dummy"
}
```
