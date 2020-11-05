# Audio Output

Rhasspy provides audio feedback when waking up, processing voice commands, pronouncing custom words, and during [text to speech](text-to-speech.md).

## MQTT/Hermes

Rhasspy plays WAV audio data sent with the `hermes/audioServer/<siteId>/playBytes/<requestId>` topic. The `requestId` part of the topic is simply a unique ID that will be sent back in `id` field of the `hermes/audioServer/playFinished` response.

## ALSA

Plays WAV files on the local device by calling the `aplay` command. Should work with ALSA and PulseAudio.

Add to your [profile](profiles.md):

```json
"sounds": {
  "system": "aplay",
  "aplay": {
    "device": ""
  }
}
```

If provided, `sounds.aplay.device` is passed to `aplay` with the `-D` argument.
Leave it blank to use the default device.

You may set `sounds.aplay.volume` to a value in `[0, 1]` where 0 is off and 1 is full volume. This can be changed at runtime through the [`rhasspy/audioServer/setVolume`](reference.md#audioserver_setvolume) message or the [`/api/set-volume`](reference.md#api_set_volume) HTTP endpoint.

WAV audio sent to this service is automatically inspected for an [INFO chunk](https://github.com/synesthesiam/wav-chunk). If present, it's value is deserialized a JSON object and a "volume" property will used to determine the final playback volume (e.g., `{ "volume": 0.5 }`).

Implemented by [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)

## Remote

Rhasspy can POST audio data (as WAV) to a remote HTTP endpoint (like [`/api/play-wav`](reference.md#api_play_wav)).

Add to your [profile](profiles.md):

```json
"sounds": {
  "system": "remote",
  "remote": {
      "url": "http://<address>:<port>/path/to/endpoint"
  }
}
```

The `Content-Type` header will be set to `audio/wav`

Implemented by [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)

## Command

Calls an external program to play audio. WAV audio data is sent to the program's standard in, and the program should exit once audio is finished playing.

Add to your [profile](profiles.md):

```json
"sounds": {
  "system": "command",
  "command": {
    "play_program": "/path/to/play/program",
    "play_arguments": [],
    
    "list_program": "/path/to/list/program",
    "list_arguments": []
  }
}
```

The `sounds.command.play_program` is executed each time a sound is played with arguments from `sounds.command.play_arguments`. Rhasspy passes [WAV audio](https://en.wikipedia.org/wiki/WAV) to the program's standard input.

If provided, the `sounds.command.list_program` will be executed when a [`rhasspy/audioServer/getDevices`](reference.md#audioserver_getdevices) message is received. The program should return a listing of available audio output devices in the same format as `aplay -L`.

Implemented by [rhasspy-speakers-cli-hermes](https://github.com/rhasspy/rhasspy-speakers-cli-hermes)

## Dummy

Disables audio output.

Add to your [profile](profiles.md):

```json
"sounds": {
  "system": "dummy"
}
```
