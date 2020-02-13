# Profiles

A Rhasspy profile contains all of the necessary files for wake word detection, speech transcription, intent recognition, and training.

Each profile is a directory contained in the top-level `profiles` directory. The `profiles/defaults.json` file contains the default configuration for all profiles. The `profile.json` file *inside* each individual profile directory (e.g., `profiles/en/profile.json`) **overrides** settings in `defaults.json`.

When starting Rhasspy, you must specify a profile name with `--profile <NAME>` where `<NAME>` is the name of the profile directory (`en`, `nl`, etc.).

## Profile Directories

Rhasspy looks for profile-related files in two directories:

1. The **system profile directory** (read only)
    * Override with `--system-profiles <DIR>`
2. The **user profile directory** (read/write)
    * Override with `--user-profiles <DIR>`

Files in the user profile directory override system files, and Rhasspy will *only* ever write to the user profile directory.
The default location for each of these directories is:

TODO: Update

* Virtual Environment
    * System profile location is `$PWD/profiles` where `$PWD` is Rhasspy's root directory (where `run-venv.sh` is located)
    * User profile location is `$HOME/.config/rhasspy/profiles`
* Docker
    * System profile location is either `/usr/share/rhasspy/profiles` (ALSA) or `/home/rhasspy/profiles` (PulseAudio)
    * User profile location **must** be explicitly set and mapped to a volume:
        * `docker run ... -v /path/to/profiles:/profiles synesthesiam/rhasspy-server --user-profiles /profiles`

### Example

TODO: Rewrite

Assume you are running Rhasspy in a virtual environment, and you add some new sentences to the `en` (English) profile in the web interface. When saving the `sentences.ini` file, Rhasspy will create `$HOME/.config/rhasspy/profiles/en` (if it doesn't exist), and write `sentences.ini` in that directory. If you adjust and save your settings, you will find them in `$HOME/.config/rhasspy/profiles/en/profile.json`.

## Downloading Profiles

The first time Rhasspy loads a profile, it needs to download the required binary artifacts (acoustic model, base dictionary, etc.) from [the internet](https://github.com/synesthesiam/rhasspy-profiles/releases). After the initial download, Rhasspy can function completely offline.

If you need to install Rhasspy onto a machine that is not connected to the internet, you can simply download the artifacts yourself and place them in a `download` directory *inside* the appropriate profile directory. For example, the `fr` (French) profile has [three artifacts](https://github.com/synesthesiam/rhasspy-profiles/releases/tag/v1.0-fr):

1. `cmusphinx-fr-5.2.tar.gz`
2. `fr-g2p.tar.gz`
3. `fr-small.lm.gz`

If your user profile directory is `$HOME/.config/rhasspy/profiles`, then you should download/copy all three artifacts to `$HOME/.config/rhasspy/profiles/fr/download` on the offline machine. Now, when Rhasspy loads the `fr` profile and you click "Download", it will extract the files in the `download` directory without going out to the internet.

## Available Settings

See [the reference](reference.md#profile-settings) for all available profile settings.
