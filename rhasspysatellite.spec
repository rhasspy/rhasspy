# -*- mode: python -*-
import os
import site
from pathlib import Path

block_cipher = None

a = Analysis(
    [Path.cwd() / "__main__.py"],
    pathex=[
        ".",
        "rhasspy-dialogue-hermes",
        "rhasspy-fuzzywuzzy",
        "rhasspy-fuzzywuzzy-hermes",
        "rhasspy-hermes",
        "rhasspy-homeassistant-hermes",
        "rhasspy-microphone-cli-hermes",
        "rhasspy-microphone-pyaudio-hermes",
        "rhasspy-nlu",
        "rhasspy-nlu-hermes",
        "rhasspy-profile",
        "rhasspy-remote-http-hermes",
        "rhasspy-server-hermes",
        "rhasspy-speakers-cli-hermes",
        "rhasspy-supervisor",
        "rhasspy-tts-cli-hermes",
        "rhasspy-wake-pocketsphinx-hermes",
        "rhasspy-wake-porcupine-hermes",
        "rhasspy-wake-snowboy-hermes",
    ],
    binaries=[],
    datas=[],
    hiddenimports=[
        "pkg_resources.py2_warn",
        "aiohttp",
        "fuzzywuzzy",
        "pyaudio",
        "snowboy",
        "num2words",
        "rhasspydialogue_hermes.__main__",
        "rhasspyfuzzywuzzy.__main__",
        "rhasspyfuzzywuzzy_hermes.__main__",
        "rhasspyhermes.__main__",
        "rhasspyhomeassistant_hermes.__main__",
        "rhasspymicrophone_cli_hermes.__main__",
        "rhasspymicrophone_pyaudio_hermes.__main__",
        "rhasspynlu",
        "rhasspynlu.__main__",
        "rhasspynlu_hermes.__main__",
        "rhasspyremote_http_hermes.__main__",
        "rhasspyserver_hermes.__main__",
        "rhasspyspeakers_cli_hermes.__main__",
        "rhasspysupervisor.__main__",
        "rhasspytts_cli_hermes.__main__",
        "rhasspywake_pocketsphinx_hermes.__main__",
        "rhasspywake_porcupine_hermes.__main__",
        "rhasspywake_snowboy_hermes.__main__",
    ],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="rhasspysatellite",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
)
coll = COLLECT(
    exe, a.binaries, a.zipfiles, a.datas, strip=False, upx=True, name="rhasspysatellite"
)
