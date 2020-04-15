# Audio Input

Rhasspy can listen to audio input from a local microphone or a remote audio
stream. Most of the local audio testing has been done with a USB [PlayStation
Eye camera](https://en.wikipedia.org/wiki/PlayStation_Eye).


## MQTT/Hermes

Rhasspy receives audio over [MQTT](https://mqtt.org) using the [Hermes protocol](https://docs.snips.ai/reference/hermes): specifically, audio chunks in the [WAV format](https://en.wikipedia.org/wiki/WAV) on the topic `hermes/audioServer/<siteId>/audioFrame`

To avoid unnecessary conversion overhead, the WAV audio should be 16-bit 16Khz mono.

## PyAudio

Streams microphone data from a [PyAudio](https://people.csail.mit.edu/hubert/pyaudio/) device.
This is the default audio input system, and should work with both [ALSA](https://www.alsa-project.org/main/index.php/Main_Page) and [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/).

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "pyaudio",
  "pyaudio": {
    "device": ""
  }
}
```

Set `microphone.pyaudio.device` to a PyAudio device number or leave blank for the default device.
Streams 2048 byte chunks of 16-bit, 16 kHz mono audio by default.

### UDP Audio Streaming

By default, audio will streamed over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite as woken up. For this case, set **both** `microphone.pyaudio.udp_audio` and `wake.<WAKE_SYSTEM>.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)

## ALSA

Starts an `arecord` process locally and reads audio data from its standard out.
Works best with [ALSA](https://www.alsa-project.org/main/index.php/Main_Page).

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "arecord",
  "arecord": {
    "device": ""
  }
}
```

Set `microphone.arecord.device` to the name of the ALSA device to use (`-D` flag
to `arecord`) or leave blank for the default device.
By default, calls `arecord -t raw -r 16000 -f S16_LE -c 1` and reads 2048 byte chunks of audio data at a time.

### UDP Audio Streaming

By default, audio will streamed over MQTT in WAV chunks. When using Rhasspy in a [master/satellite](tutorials.md#server-with-satellites) setup, it may be desirable to only send audio to the MQTT broker after the satellite as woken up. For this case, set **both** `microphone.arecord.udp_audio` and `wake.<WAKE_SYSTEM>.udp_audio` to the **same** free port number on your satellite. This will cause the microphone service to stream over UDP until an [`asr/startListening`](reference.md#asr_startlistening) message is received. It will go back to UDP stream when an [`asr/stopListening`](reference.md#asr_stoplistening).

Implemented by [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)

## Command

Calls an external program to record audio. RAW audio data is expected from the program's standard out.

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "command",
  "command": {
    "record_program": "/path/to/record/program",
    "record_arguments": [],
    "sample_rate": 16000,
    "sample_width": 2,
    "channels": 1,
    
    "list_program": "/path/to/list/program",
    "list_arguments": [],
    
    "test_program": "/path/to/test/program",
    "test_arguments": []
  }
}
```

The `microphone.command.record_program` is executed when Rhasspy starts. It should output raw PCM audio data on its standard out. The `sample_rate` (Hertz), `sample_width` (bytes), and `channels` parameters tell Rhasspy the format of the raw audio data.

If provided, the `microphone.command.list_program` will be executed when a `rhasspy/audioServer/getDevices` message is received and the `test` field is `false`. The program should return a listing of available audio output devices in the same format as `arecord -L`.

If provided, the `microphone.command.test_program` will be executed when a `rhasspy/audioServer/getDevices` message is received and the `test` field is `true`. This program is called for each device returned by `list_command`. The `test_program` and its arguments are send to Python's `str.format` with the device name as the only argument, so `{}` in `test_program` or `test_arguments` will be replaced with it.

Implemented by [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)

## GStreamer

As of Rhasspy 2.5, you can use `gstreamer` through the [command microphone system](#command).

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "command",
  "command": {
    "record_program": "gstreamer",
    "record_arguments": "udpsrc port=12333 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16le sample-rate=16000 num-channels=1 ! queue ! audioconvert ! audioresample ! filesink location=/dev/stdout",
    "sample_rate": 16000,
    "sample_width": 2,
    "channels": 1
  }
}
```

This command receives raw 16-bit 16 kHz audio chunks via UDP port 12333. If you're using Docker, make sure to add `-p 12333:12333/udp` to your `docker run` command. 

You can then stream microphone audio *to* Rhasspy from another computer by running the following terminal command:

```bash
gst-launch-1.0 \
    autoaudiosrc ! \
    audioconvert ! \
    audioresample ! \
    audio/x-raw, rate=16000, channels=1, format=S16LE ! \
    udpsink host=RHASSPY_SERVER port=12333
```

where `RHASSPY_SERVER` is the hostname of your Rhasspy server (e.g., `localhost`). You may need to install the `gstreamer1.0-tools` and `gstreamer1.0-plugins-good` packages first.

The official Rhasspy Docker image contains the ["good" plugin set](https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-good-plugins/html/) for GStreamer, which includes a wide variety of ways to stream/transform audio.

## Dummy

Disables microphone recording.

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "dummy"
}
```

See `rhasspy.audio_recorder.DummyAudioRecorder` for details.
