# Command Listener

As of Rhasspy 2.5, the [speech to text](speech-to-text.md) system is responsible for detecting the boundaries of a voice command (the default systems use the [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library). Previously, this was done by a seperate "command listener" system. This page and its sections are here to avoid broken links and provide an explanation.

## MQTT/Hermes

Rhasspy listens for messages according to the [Hermes protocol](https://docs.snips.ai/reference/hermes) to decide when to record voice commands. See the [speech to text page](speech-to-text.md#mqtthermes) for more details.

## WebRTCVAD

The [rhasspy-silence](https://github.com/rhasspy/rhasspy-silence) library used by Rhasspy's [pocketsphinx](speech-to-text.md#pocketsphinx) and [kaldi](speech-to-text.md#kaldi) use [webrtcvad](https://github.com/wiseman/py-webrtcvad) to detect speech and silence.

## OneShot

**Deprecated as of Rhasspy 2.5** 

This system previously listened for a single WAV audio chunk and processed it as a complete voice command.
You can acheive the same thing now with the following steps:

1. Send a `hermes/asr/startListening` message with the `stopOnSilence` property set to `true`
2. Send one or more `hermes/audioServer/<siteId>/audioFrame` messages with your voice command WAV audio
3. Send a `hermes/asr/stopListening` message

With `stopOnSilence` set in `startListening`, the configured [speech to text](speech-to-text.md) system should not attempt a transcription until the `stopListening` message is received.

## Command

**Deprecated as of Rhasspy 2.5** 

This system previously allowed for an external program to determine voice command boundaries.

## Dummy

**Deprecated as of Rhasspy 2.5** 

This system previously disabled voice command recording.
