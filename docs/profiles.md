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

* Virtual Environment
    * System profile location is `rhasspy-profile/rhasspyprofile/profiles` relative to Rhasspy's root directory
    * User profile location is `$HOME/.config/rhasspy/profiles`
* Docker
    * System profile location is `/usr/lib/rhasspy-voltron/rhasspy-profile/rhasspyprofile/profiles`
    * User profile location **must** be explicitly set and mapped to a volume:
        * `docker run ... -v /path/to/profiles:/profiles <IMAGE_NAME> --user-profiles /profiles`

### Example

Assume you are running Rhasspy in a virtual environment, and you add some new sentences to the `en` (English) profile in the web interface. When saving the `sentences.ini` file, Rhasspy will create `$HOME/.config/rhasspy/profiles/en` (if it doesn't exist), and write `sentences.ini` in that directory. If you adjust and save your settings, you will find them in `$HOME/.config/rhasspy/profiles/en/profile.json`.

## Downloading Profiles

The first time Rhasspy loads a profile, it needs to download the required binary artifacts (acoustic model, base dictionary, etc.) from [the internet](https://github.com/synesthesiam). After the initial download, Rhasspy can function completely offline.

See the [supported languages list](index.md#supported-languages) for links to each language's profile artifacts. The [`rhasspy-profile`](https://github.com/rhasspy/rhasspy-profile) is responsible for downloading and unpacking these artifacts according to the `download` section in `profile.json` for [each language](https://github.com/rhasspy/rhasspy-profile/tree/master/rhasspyprofile/profiles).

Some files are gzipped, and should be unzipped before use (`unzip = true`). Other files are split into multiple parts so that they can be uploaded to GitHub. This is done with the `split` command:

```bash
split -d -b 25M FILE FILE.part-
```

They can be recombined simply with:

```bash
cat FILE.part-* > FILE
```

## Available Settings

See [the reference](reference.md#profile-settings) for all available profile settings.
