# Intent Handling

After a voice command has been transcribed and your intent has been successfully recognized, Rhasspy is ready to send a JSON event to another system like Home Assistant or a remote Rhasspy server.

You can also handle intents by:

* Listening for `hermes/intent/<intentName>` messages over MQTT ([details](intent-recognition.md#mqtthermes))
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

See the [Home Assistant Example](https://github.com/rhasspy/rhasspy/tree/master/examples/homeassistant) for sentences that use Home Assistant's [built-in intents](https://developers.home-assistant.io/docs/intent_builtin/) and a [slot program](training.md#slot-programs) can automatically download the names of your entities.

When an intent is triggered, any speech received from Home Assistant is automatically forwarded to your [text to speech system](text-to-speech.md).

### Intents

Home Assistant can accept intents directly from Rhasspy using an HTTP endpoint. Add the following to your `configuration.yaml` file:

```yaml
intent:
```

This will enable intents over the HTTP endponit. Next, write [intent scripts](https://www.home-assistant.io/integrations/intent_script) to handle each Rhasspy intent:

```yaml
intent_script:
  ChangeLightColor:
    action:
      ...
```

The possible [actions](https://www.home-assistant.io/docs/automation/action/) are the same as in automations.

### Events

Rhasspy can also send Home Assistant an event every time an intent is recognized through its [REST API](https://developers.home-assistant.io/docs/en/external_api_rest.html#post-api-events-lt-event-type). The type of the event is determined by the name of the intent, and the event data comes from the tagged words in your [sentences](training.md#sentencesini).

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

Rhasspy also provides a few extra fields besides the intent's slots:

* `_text` - string with [substituted intent text](training.md#substitutions)
* `_raw_text` - string with original intent text
* `_intent` - object with recognized [Hermes intent](https://docs.snips.ai/reference/dialogue#intent)

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

Implemented by [rhasspy-homeassistant-hermes](https://github.com/rhasspy/rhasspy-homeassistant-hermes)


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
  "pem_file": "/path/to/certfile",
  "key_file": "/path/to/keyfile"
}
```

Set `home_assistant.pem_file` to the full path to your <a href="https://docs.python.org/3/library/ssl.html#ssl-certificates">PEM certificate file</a>. If your key is separate, set `home_assistant.key_file` as well.

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

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

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

## Command

Once an intent is successfully recognized, can call a custom program to handle it.

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

When an intent arrives, Rhasspy will call your custom program with the intent JSON printed to standard in. You should return JSON to standard out, optionally with additional information (see below).

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

Implemented by [rhasspy-remote-http-hermes](https://github.com/rhasspy/rhasspy-remote-http-hermes)

## Dummy

Disables intent handling.

Add to your [profile](profiles.md):

```json
"handle": {
  "system": "dummy"
}
```
