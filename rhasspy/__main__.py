import logging
import sys

_LOGGER = logging.getLogger(__name__)

# -----------------------------------------------------------------------------

_COMMANDS = [
    "asr-deepspeech-hermes",
    "asr-pocketsphinx",
    "asr-pocketsphinx-hermes",
    "asr-kaldi",
    "asr-kaldi-hermes",
    "dialogue-hermes",
    "fuzzywuzzy",
    "fuzzywuzzy-hermes",
    "hermes",
    "homeassistant-hermes",
    "microphone-cli-hermes",
    "microphone-pyaudio-hermes",
    "nlu",
    "nlu-hermes",
    "rasa-nlu-hermes",
    "profile",
    "remote-http-hermes",
    "silence",
    "server-hermes",
    "speakers-cli-hermes",
    "supervisor",
    "tts-cli-hermes",
    "wake-pocketsphinx-hermes",
    "wake-porcupine-hermes",
    "wake-precise-hermes",
    "wake-snowboy-hermes",
]


def main():
    """Main method."""
    if len(sys.argv) < 2:
        print("Usage: rhasspy COMMAND ARGS")
        print("Available commands: ", _COMMANDS)
        sys.exit(1)

    command = sys.argv[1]
    if command not in _COMMANDS:
        print("Unknown command: ", command)
        print("Available commands: ", _COMMANDS)
        sys.exit(1)

    # Remove command name from argument list
    sys.argv = [sys.argv[0]] + sys.argv[2:]

    # Run __main__.main() method in Python module
    module_name = "rhasspy" + command.replace("-", "_")
    module = __import__(module_name + ".__main__", fromlist=[module_name])
    module.main()


# -----------------------------------------------------------------------------

if __name__ == "__main__":
    main()
