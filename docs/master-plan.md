# The Master Plan

* [Languages](#languages)
* [Phoneme Inventory and Text Processing](#phoneme-inventory-and-text-processing)
* [Speech to Text](#speech-to-text)
* [Text to Speech](#text-to-speech)
* [Wake Word](#wake-word)
* [Audio Corpora](#audio-corpora)

To keep pace in the short term and grow in the long term, the Rhasspy project needs to train its own models instead of scavenging the Internet for them. With the plethora of free [audio corpora](#audio-corpora) available, it's possible to create high quality [speech to text](#speech-to-text) and [text to speech](#text-to-speech) voices for most of Rhasspy's [supported languages](#languages)!

An over-arching theme in Rhasspy's Master Plan is the use of the [International Phonetic Alphabet](https://en.wikipedia.org/wiki/International_Phonetic_Alphabet) (IPA). All speech to text models and text to speech voices are trained with IPA [phoneme inventories](#phoneme-inventory-and-text-processing) and lexicons.

## Languages

* Arabic (ar)
* Catalan (ca)
* Chinese (zh-cn)
* Czech (cs)
* English (en)
    * U.S. (en-us)
    * U.K. (en-gb)
* Dutch (nl)
* Finnish (fi)
* French (fr)
* German (de)
* Greek (el)
* Hebrew (he)
* Italian (it)
* Hindi (hi)
* Hungarian (hu)
* Japanese (ja)
* Korean (ko)
* Persian (fa)
* Polish (pl)
* Portuguese (pt-br)
* Russian (ru)
* Spanish (es-es)
* Swedish (sv-se)
* Ukranian (uk)
* Vietnamese (vi-n)

## Phoneme Inventory and Text Processing

Before a [speech to text model](#speech-to-text) or a [text to speech voice](#text-to-speech) can be trained with available [audio corpora](#audio-corpora), several things are needed for each language:

* A [phoneme inventory](https://en.wikipedia.org/wiki/Phoneme) using the [International Phonetic Alphabet](https://en.wikipedia.org/wiki/International_Phonetic_Alphabet) (IPA)
    * [Language phonologies](https://en.wikipedia.org/wiki/Template:Language_phonologies)
    * [gruut-ipa](https://github.com/rhasspy/gruut-ipa)
* A lexicon with word pronunciations and IPA phonemes
    * May be derived from [Wiktionary](https://www.wiktionary.org/)
    * Stress is required for some languages
* A grapheme-to-phoneme (g2p) model for predicting the pronunciations of unknown words
    * Trained with [phonetisaurus](https://github.com/AdolfVonKleist/Phonetisaurus)
* A tokenizer for "words" from raw text
    * Using whitespace and regular expressions
    * [gruut](https://github.com/rhasspy/gruut)
* A method for expanding numbers, etc. into lexicon words
    * [num2words](https://github.com/rhasspy/num2words)
    * [babel](https://pypi.org/project/babel/)
    
With all of the pieces, we can go from raw text (UTF-8) to phonemes (UTF-8 IPA) through this pipeline:

1. Raw text is split into tokens
2. Numbers, etc. are expanded into words
3. Words in the lexicon are looked up and turned into phonemes
4. Words not in the lexicon have their pronunciations guessed using g2p model

A currently missing piece involves step 3: some words have multiple pronunciations, and context may be necessary to determine the appropriate pronunciation. For example, the English word "read" may be pronounced like "red" (I read the book) or "reed" (I like to read) depending on context. [gruut](https://github.com/rhasspy/gruut) sidesteps this problem for now by letting you explicitly mark pronunciations as "word(n)" where "n" is the nth pronunciation in the lexicon. 

In the future, we would like to pre-trained word vectors and alignments generated during the Kaldi training process to train language-specific classifiers for guessing which word pronunciation is appropriate given a word's context.

### Completed

[Available here](https://github.com/rhasspy/gruut-ipa/tree/master/gruut_ipa/data)

* Czech (cs)
* Dutch (nl)
* English (en)
    * U.S. (en-us)
    * U.K. (en-gb)
* French (fr)
* German (de)
* Greek (el)
* Hebrew (he)
    * Right to left writing system
* Italian (it)
* Persian (fa)
    * Right to left writing system
    * Using [hazm](https://www.sobhe.ir/hazm/) for genitive case (e̞)
* Portuguese (pt-br)
* Russian (ru)
* Spanish (es-es)
* Swedish (sv-se)
    * Has [pitch accent](https://en.wikipedia.org/wiki/Pitch_accent)
* Vietnamese (vi-n)
    * Has [tones](https://en.wikipedia.org/wiki/Vietnamese_phonology#Tone)

### Not Completed

* Arabic (ar)
    * Right to left writing system
* Catalan (ca)
* Chinese (zh-cn)
    * Needs intelligent tokenizer
* Finnish (fi)
* Hindi (hi)
* Hungarian (hu)
* Japanese (ja)
    * Multiple writing systems
    * Needs intelligent tokenizer
* Korean (ko)
* Polish (pl)
* Ukranian (uk)

---

## Speech to Text

Transcribing speech to text is a core function of Rhasspy. High quality models are a plus (low word error rate), but even models with moderate quality can be quite useful because Rhasspy is intended to recognize a limited set of [pre-scripted voice commands](training.md#sentencesini).

### Kaldi

The [ipa2kaldi](https://github.com/rhasspy/ipa2kaldi) project creates a Kaldi nnet3 recipe from one or more audio datasets using [gruut](https://github.com/rhasspy/gruut) to tokenize and phonemize the dataset transcriptions. The IPA phoneme inventories are used directly as well.

#### Completed

* [Czech (cs)](https://github.com/rhasspy/cs_kaldi-rhasspy/)
    * WER: 11.03
* [French (fr)](https://github.com/rhasspy/fr_kaldi-rhasspy/)
    * WER: 3.23
* [Italian (it)](https://github.com/rhasspy/it_kaldi-rhasspy/)
    * WER: 2.86
* [Russian (ru)](https://github.com/rhasspy/ru_kaldi-rhasspy/)
    * Need to calculate WER
* [Spanish (es-es)](https://github.com/rhasspy/es_kaldi-rhasspy/)
    * WER: 2.03

#### Not Completed

* Arabic (ar)
* Catalan (ca)
* Chinese (zh-cn)
* English (en)
    * U.S. (en-us)
    * U.K. (en-gb)
* Dutch (nl)
* Finnish (fi)
* German (de)
* Greek (el)
* Hebrew (he)
* Hindi (hi)
* Hungarian (hu)
* Japanese (ja)
* Korean (ko)
* Persian (fa)
* Polish (pl)
* Portuguese (pt-br)
* Swedish (sv-se)
* Ukranian (uk)
* Vietnamese (vi-n)

### Mozilla DeepSpeech

Besides Kaldi, Mozilla's DeepSpeech is another useful speech to text tool. We would like to produce a fork that uses [gruut](https://github.com/rhasspy/gruut) and IPA phonemes, similar to [ipa2kaldi](https://github.com/rhasspy/ipa2kaldi).

#### Available

Pre-trained models are available directly from Mozilla and [DeepSpeech Polyglot](https://gitlab.com/Jaco-Assistant/deepspeech-polyglot).

* Chinese (zh-cn)
* English (en)
    * U.S. (en-us)
* French (fr)
* German (de)
* Italian (it)
* Polish (pl)
* Spanish (es)

### Accented Speech Recognition

A useful side effect of using IPA for speech to text models is the possibility of using an acoustic model trained for one language to recognized accented speech from a different language. Given a phoneme map, where phonemes from a source language are approximated in a target language, accented speech could be recognized as follows:

1. An acoustic model trained on language A is loaded
2. The lexicon for language B is transliterated to language A using the phoneme map
3. The acoustic model (A) and transliterated lexicon (B -> A) are used to transcribe speech

This approach has not yet been tested.

---

## Text to Speech

Voice assistants need to talk back, and Rhasspy is no exception. Projects like [opentts](https://github.com/synesthesiam/opentts) have collected a large number of voices and text to speech systems, but the quality varies between languages.

### MozillaTTS and Larynx

The [MozillaTTS](https://github.com/mozilla/TTS) project can produce natural-sounding voices given enough data and GPU computing power. A fork named [Larynx](https://github.com/rhasspy/larynx) has been created to make use of [gruut](https://github.com/rhasspy/gruut) and its [IPA phoneme inventories](#phoneme-inventory-and-text-processing).

#### Completed

* Dutch (nl)
    * [rdh (GlowTTS)](https://github.com/rhasspy/nl_larynx-rdh)
* English (en)
    * U.S. (en-us)
        * [kathleen (Tacotron2)](https://github.com/rhasspy/en-us_larynx-kathleen)
* French (fr)
    * [siwis (GlowTTS)](https://github.com/rhasspy/fr_larynx-siwis)
* German (de)
    * [thorsten (GlowTTS)](https://github.com/rhasspy/de_larynx-thorsten)
* Russian (ru)
    * [nikolaev (GlowTTS)](https://github.com/rhasspy/ru_larynx-nikolaev)
* Spanish (es-es)
    * [css10 (GlowTTS)](https://github.com/rhasspy/es_larynx-css10)

#### Not Completed

* Arabic (ar)
* Catalan (ca)
* Chinese (zh-cn)
* Czech (cs)
* English (en)
    * U.K. (en-gb)
* Finnish (fi)
* Greek (el)
* Hebrew (he)
* Italian (it)
* Hindi (hi)
* Hungarian (hu)
* Japanese (ja)
* Korean (ko)
* Persian (fa)
* Polish (pl)
* Portuguese (pt-br)
* Swedish (sv-se)
* Ukranian (uk)
* Vietnamese (vi-n)

### Text Prompts

The [audio corpora](#audio-corpora) needed to train a text to speech voice is a bit different than a speech to text model. Rather than many different speakers in a wide variety of acoustic environments, you (typically) want a single speaker in a quiet environment with a high quality microphone. These datasets are harder to come by for languages other than English, so volunteers are being enlisted to produce them.

In order to reduce the burden on volunteers, sentences must be carefully chosen. Reading 15k sentences may produce an excellent voice, but few volunteers will be on board with spending weeks to complete all of them. Our goal is to find less than 2k sentences that are phonemically rich -- i.e., there are many examples of both individual phonemes as well as phoneme pairs.

[gruut](https://github.com/rhasspy/gruut) can find phonemically rich sentences in a large text corpus, such as Mozilla's [Common Voice](https://github.com/mozilla/common-voice/tree/master/server/data/) or [Oscar](https://oscar-corpus.com/). Importantly, these sentences are vetted by native speakers so that they (1) can be read without ambiguity, (2) are not offensive or nonsensical, and (3) are something a native speaker would actually say.

#### Completed

[Available here](https://github.com/rhasspy/tts-prompts/)

* Dutch (nl)
* English (en)
  * U.S. (en-us)
* French (fr)
* German (de)
* Swedish (sv-se)

#### Not Completed

* Arabic (ar)
* Catalan (ca)
* Chinese (zh-cn)
* Czech (cs)
* English (en)
  * U.K. (en-gb)
* Finnish (fi)
* Greek (el)
* Hebrew (he)
* Italian (it)
* Hindi (hi)
* Hungarian (hu)
* Japanese (ja)
* Korean (ko)
* Persian (fa)
* Polish (pl)
* Portuguese (pt-br)
* Russian (ru)
* Spanish (es-es)
* Ukranian (uk)
* Vietnamese (vi-n)

### Accented Text to Speech

Because all Larynx voices share the same underlying phoneme alphabet (IPA), it is possible to have voices speak in a different language than what they were trained for! All this requires is a phoneme map that tells Larynx how to approximate phonemes outside the voice's native inventory.

As an example, consider a French voice that is being used to speak U.S. English. The English word "that" can be phonemized as `/ðæt/` but the French phoneme inventory (in [gruut](https://github.com/rhasspy/gruut)) does not have `ð` or `æ`. One approximation could be `ð -> z` and `æ -> a`, sounding more like "zat" to an English speaker.

With a complete phoneme map from language A (native to the voice) to B, accented speech can be achieved using the following process:

1. Text is tokenized and phonemized according to language B's rules and lexicon
2. Phonemes are mapped back to language A through the phoneme map
3. The voice is given the mapped phonemes to speak

---

## Wake Word

Voice assistants are typical dormant until a special wake word is spoken. Audio after the wake word is then interpreted as a voice command.

### Raven

There are a variety of free wake word systems available, but virtually none of them are fully open source. [Raven](https://github.com/rhasspy/rhasspy-wake-raven) is an exception -- it is free, open source, and can be trained with only 3 examples.

Unfortunately, Raven is not as fast or accurate as other wake word systems. We would like to rewrite Raven in a lower-level language like C++ or Rust. Other methods of wake word recognition should also be explored (like [GRUs](https://github.com/MycroftAI/mycroft-precise)). Ideally, a GRU-based system could be trained on a fast machine (possibly with a GPU), and then executed directly in code like [RNNoise](https://jmvalin.ca/demo/rnnoise/) or [g2pE](https://github.com/Kyubyong/g2p).

---

## Audio Corpora

The following list contains links to free audio corpora that were available for download.

* Arabic (ar)
    * [Arabic Speech Corpus](http://en.arabicspeechcorpus.com/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [Lingua Libre](https://lingualibre.org)
    * [Sermon Online](https://www.sermon-online.com/)
* Catalan (ca)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [VoxForge](http://voxforge.org/ca)
* Chinese (zh-cn)
* Czech (cs)
    * [Vystadial VOIP](http://www.openslr.org/6/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
* English (en)
    * U.S. (en-us)
        * [Spoken Wikipedia](https://nats.gitlab.io/swc/)
        * [VCTK](https://datashare.ed.ac.uk/handle/10283/3443)
        * [Tatoeba](https://tatoeba.org/eng/downloads)
        * [Mozilla Common Voice](https://voice.mozilla.org/)
        * [MLS](http://www.openslr.org/94/)
        * [LibriSpeech](https://www.openslr.org/12/)
        * [Lingua Libre](https://lingualibre.org)
        * [VoxForge](http://voxforge.org/en)
    * U.K. (en-gb)
        * [ARU](https://www.liverpool.ac.uk/architecture/research/acoustics-research-unit/speech-corpus/)
        * [Harvard](https://salford.figshare.com/collections/HARVARD_speech_corpus_-_audio_recording_2019/4437578/1)
        * [Mozilla Common Voice](https://voice.mozilla.org/)
        * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
* Dutch (nl)
    * [CGN](http://lands.let.ru.nl/cgn/ehome.htm)
    * [CSS10](https://www.kaggle.com/bryanpark/dutch-single-speaker-speech-dataset)
    * [MLS](http://www.openslr.org/94/)
    * [Spoken Wikipedia](https://nats.gitlab.io/swc/)
    * [Lingua Libre](https://lingualibre.org)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [VoxForge](http://voxforge.org/nl)
    * [RDH](https://github.com/r-dh/dutch-vl-tts)
* Finnish (fi)
    * [CSS10](https://www.kaggle.com/bryanpark/finnish-single-speaker-speech-dataset)
* French (fr)
    * [CSS10](https://www.kaggle.com/bryanpark/french-single-speaker-speech-dataset)
    * [Lingua Libre](https://lingualibre.org)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [SIWIS](https://datashare.is.ed.ac.uk/handle/10283/2353)
* German (de)
    * [CSS10](https://www.kaggle.com/bryanpark/german-single-speaker-speech-dataset)
    * [Spoken Wikipedia](https://nats.gitlab.io/swc/)
    * [Tuda](https://www.inf.uni-hamburg.de/en/inst/ab/lt/resources/data/acoustic-models.html)
    * [Zamia](https://goofy.zamia.org/zamia-speech/corpora/zamia_de/)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [Thorsten](https://www.openslr.org/95/)
    * [Lingua Libre](https://lingualibre.org)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [VoxForge](http://voxforge.org/de)
* Greek (el)
    * [CSS10](https://www.kaggle.com/bryanpark/greek-single-speaker-speech-dataset)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [Sermon Online](https://www.sermon-online.com/)
    * [VoxForge](http://voxforge.org/el)
* Hebrew (he)
    * [CoSIH](http://www.cosih.com/english/index.html)
    * [Lingua Libre](https://lingualibre.org)
    * [Sermon Online](https://www.sermon-online.com/)
    * [VoxForge](http://voxforge.org/el)
* Italian (it)
    * [MSPKA](http://www.mspkacorpus.it/)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [VoxForge](http://voxforge.org/it)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
* Hindi (hi)
* Hungarian (hu)
    * [CSS10](https://www.kaggle.com/bryanpark/hungarian-single-speaker-speech-dataset)
* Japanese (ja)
    * [CSS10](https://www.kaggle.com/bryanpark/japanese-single-speaker-speech-dataset)
    * [JSUT](https://sites.google.com/site/shinnosuketakamichi/publication/jsut)
    * [JVS](https://sites.google.com/site/shinnosuketakamichi/research-topics/jvs_corpus)
* Korean (ko)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [KSS](https://www.kaggle.com/bryanpark/korean-single-speaker-speech-dataset/data)
    * [Zeroth](https://www.openslr.org/40/)
* Persian (fa)
    * [Miras Voice](https://github.com/miras-tech/MirasVoice)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [Sermon Online](https://www.sermon-online.com/)
    * [VoxForge](http://voxforge.org/fa)
* Polish (pl)
    * [Lingua Libre](https://lingualibre.org)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
* Portuguese (pt-br)
    * [Edresson](https://github.com/Edresson/TTS-Portuguese-Corpus)
    * Falabrasil-LAPS
    * [Lingua Libre](https://lingualibre.org)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [Sermon Online](https://www.sermon-online.com/)
* Russian (ru)
    * [CSS10](https://www.kaggle.com/bryanpark/russian-single-speaker-speech-dataset)
    * [Lingua Libre](https://lingualibre.org)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [OpenSTT](https://spark-in.me/post/open-stt-release-v10)
    * [Russian LibriSpeech](http://www.openslr.org/96/)
    * [Sermon Online](https://www.sermon-online.com/)
    * [VoxForge](http://voxforge.org/ru)
* Spanish (es-es)
    * [CarlFM](https://github.com/carlfm01/my-speech-datasets)
    * [CSS10](https://www.kaggle.com/bryanpark/spanish-single-speaker-speech-dataset)
    * [Librivox](https://www.kaggle.com/carlfm01/120h-spanish-speech)
    * [Lingua Libre](https://lingualibre.org)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [MLS](http://www.openslr.org/94/)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [VoxForge](http://voxforge.org/es)
* Swedish (sv-se)
    * [Mozilla Common Voice](https://voice.mozilla.org/)
    * [NST](https://www.nb.no)
* Ukranian (uk)
    * [M-AILabs](https://www.caito.de/2019/01/the-m-ailabs-speech-dataset/)
    * [VoxForge](http://voxforge.org/uk)
    * [Ukranian Open Speech to Text Dataset](https://github.com/egorsmkv/speech-recognition-uk#compiled-dataset-from-different-open-sources--companies--community--9944gb--800-hours-)
* Vietnamese (vi-n)
    * [FOSD](https://data.mendeley.com/datasets/k9sxg2twv4/4)
    * [Sermon Online](https://www.sermon-online.com/)
    * [VAIS 1000](https://ieee-dataport.org/documents/vais-1000-vietnamese-speech-synthesis-corpus)
    * [VIVOS](https://ailab.hcmus.edu.vn/vivos/)

### Librivox

A potential source of audio data is [Librivox](https://librivox.org/), which includes free audiobooks for [public domain books](https://www.gutenberg.org).

To make this data useful for model training, it must be split into individual sentences and aligned with its text. The [aeneas tool](https://www.readbeyond.it/aeneas/docs/) may help with this process.
