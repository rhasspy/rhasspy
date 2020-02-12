# Command Listener

As of Rhasspy 2.5, the [speech to text](speech-to-text.md) system is responsible for detecting the boundaries of a voice command (the default systems use the [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library). Previously, this was done by a seperate "command listener" system. This page and its sections are here to avoid broken links and provide an explanation.

## MQTT/Hermes

Rhasspy listens for messages according to the [Hermes protocol](https://docs.snips.ai/reference/hermes) to decide when to record voice commands. See the [speech to text page](speech-to-text.md#mqtthermes) for more details.

## WebRTCVAD

The [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library used by Rhasspy's [pocketsphinx](speech-to-text.md#pocketsphinx) and [kaldi](speech-to-text.md#kaldi) uses [webrtcvad](https://github.com/wiseman/py-webrtcvad) to detect speech and silence.

TODO: Silence detection parameters

Add to your [profile](profiles.md):

```json
"command": {
  "system": "webrtcvad",
  "webrtcvad": {
    "chunk_size": 960,
    "min_sec": 2,
    "sample_rate": 16000,
    "silence_sec": 0.5,
    "speech_buffers": 5,
    "throwaway_buffers": 10,
    "timeout_sec": 30,
    "vad_mode": 0
  }
}
```

This system listens for up to `timeout_sec` for a voice command. The first few frames of audio data are discarded (`throwaway_buffers`) to avoid clicks from the microphone being engaged. When speech is detected for some number of successive frames (`speech_buffers`), the voice command is considered to have *started*. After `min_sec`, Rhasspy will start listening for silence. If at least `silence_sec` goes by without any speech detected, the command is considered *finished*, and the recorded WAV data is sent to the [speech recognition system](speech-to-text.md).

You may want to adjust `min_sec`, `silence_sec`, and `vad_mode` for your environment.
These control how short a voice command can be (`min_sec`), how much silence is required before Rhasspy stops listening (`silence_sec`), and how aggressive the voice activity filter `vad_mode` is: this is an integer between 0 and 3. 0 is the least aggressive about filtering out non-speech, 3 is the most aggressive.

## OneShot

Deprecated as of Rhasspy 2.5. 

This system previously listened for a single WAV audio chunk and processed it as a complete voice command.
You can acheive the same thing now with the following steps:

1. Send a `hermes/asr/startListening` message with the `stopOnSilence` property set to `true`
2. Send one or more `hermes/audioServer/<siteId>/audioFrame` messages with your voice command WAV audio
3. Send a `hermes/asr/stopListening` message

With `stopOnSilence` set in `startListening`, the configured [speech to text](speech-to-text.md) system should not attempt a transcription until the `stopListening` message is received.

## Command

Deprecated as of Rhasspy 2.5.

This system previously allowed for an external program to determine voice command boundaries.

## Dummy

Deprecated as of Rhasspy 2.5.

This system previously disabled voice command recording.
