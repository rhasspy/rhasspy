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
    "device": "",
    "frames_per_buffer": 480
  }
}
```

Set `microphone.pyaudio.device` to a PyAudio device number or leave blank for the default device.
Streams 30ms chunks of 16-bit, 16 kHz mono audio by default (480 frames).

Implemented by [rhasspy-microphone-pyaudio-hermes](https://github.com/rhasspy/rhasspy-microphone-pyaudio-hermes)

## ALSA

Starts an `arecord` process locally and reads audio data from its standard out.
Works best with [ALSA](https://www.alsa-project.org/main/index.php/Main_Page).

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "arecord",
  "arecord": {
    "device": "",
    "chunk_size": 960
  }
}
```

Set `microphone.arecord.device` to the name of the ALSA device to use (`-D` flag
to `arecord`) or leave blank for the default device.
By default, calls `arecord -t raw -r 16000 -f S16_LE -c 1` and reads 30ms (960
bytes) of audio data at a time.

Implemented by [rhasspy-microphone-cli-hermes](https://github.com/rhasspy/rhasspy-microphone-cli-hermes)

## HTTP Stream

Accepts chunks of 16-bit 16 kHz mono audio via an HTTP POST stream (assumes [chunked transfer encoding](https://en.wikipedia.org/wiki/Chunked_transfer_encoding)).

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "http",
  "http": {
    "host": "127.0.0.1",
    "port": 12333,
    "stop_after": "never"
  }
}
```

Set `microphone.http.stop_after` to one of "never", "text", or "intent". When set to "never", you can continuously stream (chunked) audio into Rhasspy across multiple voice commands. When set to "text" or "intent", the stream will be closed when the first voice command has been transcribed ("text") or recognized ("intent"). Once closed, you can perform an HTTP GET request to the stream URL to retrieve the result (text for transcriptions or JSON for intent).

Note that `microphone.http.port` must be different than Rhasspy's webserver port (usually 12101).

TODO: Not Implemented

## GStreamer

Receives audio chunks via stdout from a [GStreamer](https://gstreamer.freedesktop.org/) pipeline.

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "gstreamer",
  "gstreamer": {
    "pipeline": "...",
  }
}
```

Set `microphone.gstreamer.pipeline` to your GStreamer pipeline **without a sink** (this will be added by Rhasspy). By default, the pipeline is:

```
udpsrc port=12333 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16le sample-rate=16000 num-channels=1 ! queue ! audioconvert ! audioresample
```

which "simply" receives raw 16-bit 16 kHz audio chunks via UDP port 12333. You could stream microphone audio to Rhasspy from another machine by running the following terminal command:

```bash
gst-launch-1.0 \
    autoaudiosrc ! \
    audioconvert ! \
    audioresample ! \
    audio/x-raw, rate=16000, channels=1, format=S16LE ! \
    udpsink host=RHASSPY_SERVER port=12333
```

where `RHASSPY_SERVER` is the hostname of your Rhasspy server (e.g., `localhost`).

The Rhasspy Docker images contains the ["good" plugin](https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-good-plugins/html/) set for GStreamer, which includes a wide variety of ways to stream/transform audio.

TODO: Not Implemented

## Dummy

Disables microphone recording.

Add to your [profile](profiles.md):

```json
"microphone": {
  "system": "dummy"
}
```

See `rhasspy.audio_recorder.DummyAudioRecorder` for details.
