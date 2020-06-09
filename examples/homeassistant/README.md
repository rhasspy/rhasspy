# Home Assistant Example

Sample Rhasspy sentences and slots for directly using Home Assistant's [built-in intents](https://developers.home-assistant.io/docs/intent_builtin/).

Requires `curl` and `jq` to work.

## Rhasspy Configuration

Files in the `profile` directory are meant for Rhasspy. The included `sentences.ini` file has English sentences for the following Home Assistant intents:

* `HassTurnOn`
    * Example: turn on the kitchen lights
* `HassTurnOff`
    * Example: turn off the bed light
* `HassOpenCover`
    * Example: open the garage door
* `HassCloseCover`
    * Example: close the hall window
* `HassToggle`
    * Example: toggle AC
* `HassLightSet`
    * Example: set kitchen lights to cornflower blue
    * Example: set the bed light to ten percent brightness
    
The `slots/hass/colors` slot file contains all CSS3 color names.

### Entities Slot Program

The most important file is `slot_programs/hass/entities`, which is a Bash script that connects to your Home Assistant server when Rhasspy is trained and downloads the friendly names of available entities. This slot program (referenced in `sentences.ini` as `$hass/entities`) reads your `profile.json` to get the URL and long-lived access token of your Home Assistant Server.

The `$hass/entities` script optionally takes one or more domain names as arguments. For example, `$hass/entities,light,switch` will only print entities whose id starts with `light.` or `switch.` (note the "."). With no arguments, `$hass/entities` returns **all** entities.

## Home Assistant Configuration

On the Home Assistant side, you must have the [REST API](https://developers.home-assistant.io/docs/api/rest/) enabled (done by default). Make sure to create a long-lived access token and copy it into your Rhasspy settings for Home Assistant.

In your `configuration.yaml` file, you will also need to enable the `intent` integration by adding:

```yaml
intent:
```

somewhere in your configuration file and restarting Home Assistant. This allows Rhasspy to `POST` intents directly to Home Assistant's `/api/intent/handle` endpoint.

### Adding New Entities

If you add or remove entities from Home Assistant, make sure to re-train Rhasspy. The `$hass/entities` script will fetch the new entity list and update your voice commands appropriately.

## Missing Intents

The `HassShoppingListAddItem` and `HassShoppingListLastItems` are not included in the example `sentences.ini`. If you'd like to add them, you'll need to list the possible items that can go in your shopping list. Something like this:

```ini
[HassShoppingListAddItem]
items = (apples | carrots | bananas)
add (<items>){item} to my shopping list

[HassShoppingListLastItems]
whats in my shopping list
```

Also make sure to add `shopping_list:` to your `configuration.yaml` file, per [the documentation](https://www.home-assistant.io/integrations/shopping_list/).
