# Intent Handling

After a voice command has been transcribed and your intent has been successfully recognized, Rhasspy is ready to send a JSON event to another system like Home Assistant or a remote Rhasspy server.

You can also handle intents by:

* Listening for `hermes/intents/<intentName>` messages over MQTT ([details](intent-recognition.md#mqtthermes))
* Connecting a websocket to `/api/events/intent` ([details](reference.md#websocket-api))

Available intent handling systems are:

* [Home Assistant](#home-assistant)
* [Remote HTTP Server](#remote-server)
* [External Command](#command)

## Home Assistant

Add to your [profile](profiles.md):

```json
"handle": {
  "system": "hass"
},

"home_assistant": {
  "access_token": "",
  "api_password": "",
  "event_type_format": "rhasspy_{0}",
  "url": "http://hassio/homeassistant/"
}
```

If you're running Rhasspy as an add-on inside [Hass.io](https://www.home-assistant.io/hassio/), the access token is [automatically provided](https://developers.home-assistant.io/docs/en/hassio_addon_communication.html#hassio-api). Otherwise, you'll need to create a [long-lived access token](https://www.home-assistant.io/docs/authentication/) and set `home_assistant.access_token` manually.

Implemented by [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)

### Events

Rhasspy will send Home Assistant an event every time an intent is recognized through its [REST API](https://developers.home-assistant.io/docs/en/external_api_rest.html#post-api-events-lt-event-type). The type of the event is determined by the name of the intent, and the event data comes from the tagged words in your [sentences](training.md#sentencesini).

For example, if you have an intent like:

```
[ChangeLightColor]
set the (bedroom light){name} to (red | green | blue){color}
```

and you say something like *"set the bedroom light to blue"*, Rhasspy will POST to the `/api/events/rhasspy_ChangeLightColor` endpoint of your Home Assistant server with the following data:

```json
{
  "name": "bedroom light",
  "color": "blue"
}
```

In order to do something with the `rhasspy_ChangeLightColor` event, create an automation with an [event trigger](https://www.home-assistant.io/docs/automation/trigger/#event-trigger). For example, add the following to your `automation.yaml` file:

```yaml
- alias: "Set bedroom light color (blue)"
  trigger:
    platform: event
    event_type: rhasspy_ChangeLightColor
    event_data:
      name: 'bedroom light'
      color: 'blue'
  action:
    ...
```

See the documentation on [actions](https://www.home-assistant.io/docs/automation/action/) for the different things you can do with Home Assistant.

### MQTT

Rhasspy automatically publishes intents over MQTT ([Hermes protocol](https://docs.snips.ai/reference/dialogue#intent)).
This allows Rhasspy to send interoperate with [Snips.AI](https://snips.ai/) compatible systems.

Home Assistant can listen directly to these intents using the `snips` plugin.
To use it, add to your Home Assistant's `configuration.yaml` file:

```yaml
snips:

intent_script:
  ...
```

See the [intent script](https://www.home-assistant.io/components/intent_script/) documentation for details on how to handle the intents.

### Self-Signed Certificate

If your Home Assistant uses a self-signed certificate, you'll need to give Rhasspy some extra information.

Add to your [profile](profiles.md):

```json
"home_assistant": {
  ...
  "pem_file": "/path/to/certfile"
}
```

Set `home_assistant.pem_file` to the full path to your <a href="http://docs.python-requests.org/en/latest/user/advanced/#ssl-cert-verification">CA_BUNDLE file or a directory with certificates of trusted CAs</a>.

Use the environment variable `RHASSPY_PROFILE_DIR` to reference your current profile's directory. For example, `$RHASSPY_PROFILE_DIR/my.pem` will tell Rhasspy to use a file named `my.pem` in your profile directory when verifying your self-signed certificate.

## Remote Server

Rhasspy can POST the intent JSON to a remote URL.

Add to your [profile](profiles.md):

```json
"handle": {
  "system": "remote",
  "remote": {
      "url": "http://<address>:<port>/path/to/endpoint"
  }
}
```

When an intent is recognized, Rhasspy will POST to `handle.remote.url` with the intent JSON. Your server should **return JSON** back, optionally with additional information (see below).

### Speech

If the returned JSON contains a "speech" key like this:

```json
{
  ...
  "speech": {
    "text": "Some text to speak."
  }
}
```

then Rhasspy will forward `speech.text` to the configured [text to speech](text-to-speech.md) system using a `hermes/tts/say` message.

TODO: Move to separate service

## Command

Once an intent is successfully recognized, Rhasspy will send an event to Home Assistant with the details. You can call a custom program instead *or in addition* to this behavior.

Add to your [profile](profiles.md):

```json
"handle": {
  "system": "command",
  "command": {
      "program": "/path/to/program",
      "arguments": []
  }
}
```

When an intent is recognized, Rhasspy will call your custom program with the intent JSON printed to standard in. You should return JSON to standard out, optionally with additional information (see below).

The following environment variables are available to your program:

* `$RHASSPY_BASE_DIR` - path to the directory where Rhasspy is running from
* `$RHASSPY_PROFILE` - name of the current profile (e.g., "en")
* `$RHASSPY_PROFILE_DIR` - directory of the current profile (where `profile.json` is)

See [handle.sh](https://github.com/synesthesiam/rhasspy/blob/master/bin/mock-commands/handle.sh) or [handle.py](https://github.com/synesthesiam/rhasspy/blob/master/bin/mock-commands/handle.py) for example programs.

### Speech

If the returned JSON contains a "speech" key like this:

```json
{
  ...
  "speech": {
    "text": "Some text to speak."
  }
}
```

then Rhasspy will forward `speech.text` to the configured [text to speech](text-to-speech.md) system using a `hermes/tts/say` message.

TODO: Not implemented

## Dummy

Disables intent handling.

Add to your [profile](profiles.md):

```json
"handle": {
  "system": "dummy"
}
```
