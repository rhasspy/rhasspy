# Install

Rhasspy can be installed in several different ways. The easiest way is [with Docker](#docker), which will pull a 1.5-2GB image with all of the [officially supported services](https://github.com/rhasspy/rhasspy-voltron).

## Docker

The easiest way to try Rhasspy is with Docker. To get started, make sure you have [Docker installed](https://docs.docker.com/install/):

    curl -sSL https://get.docker.com | sh

and that your user is part of the `docker` group:

    sudo usermod -a -G docker $USER

**Be sure to reboot** after adding yourself to the `docker` group!

Next, start the [Rhasspy Docker image](https://hub.docker.com/r/rhasspy/rhasspy) in the background:

```bash
docker run -d -p 12101:12101 \
    --restart unless-stopped \
    -v "$HOME/.config/rhasspy/profiles:/profiles" \
    --device /dev/snd:/dev/snd \
    rhasspy/rhasspy:2.5.0-pre \
    --user-profiles /profiles \
    --profile en
```

This will start Rhasspy with the English profile (`en`) in the background (`-d`) on port 12101 (`-p`) and give Rhasspy access to your microphone (`--device`). Any changes you make to [your profile](profiles.md) will be saved to `/home/<YOUR_USER>/.config/rhasspy`.

Once it starts, Rhasspy's web interface should be accessible at [http://localhost:12101](http://localhost:12101). If something went wrong, trying running docker with `-it` instead of `-d` to see the output.

If you're using [docker compose](https://docs.docker.com/compose/), add the following to your `docker-compose.yml` file:

```yaml
rhasspy:
    image: "rhasspy/rhasspy:2.5.0-pre"
    restart: unless-stopped
    volumes:
        - "$HOME/.config/rhasspy/profiles:/profiles"
    ports:
        - "12101:12101"
    devices:
        - "/dev/snd:/dev/snd"
    command: --user-profiles /profiles --profile en
```

Rhasspy runs an MQTT broker inside the Docker image on port `12183` by default. Connecting to this broker will let you interact with Rhasspy over its [MQTT API](reference.md#mqtt-api).

## Debian

**Coming soon**

Rhasspy will be packaged as a `.deb` file for easy non-Docker installation on Debian, Ubuntu, and Raspbian.

## Virtual Environment

See the [Github documentation](https://github.com/rhasspy/rhasspy-voltron). On a Debian system, you should only need to install the necessary dependencies:

```bash
sudo apt-get update
sudo apt-get install \
     python3 python3-dev python3-setuptools python3-pip python3-venv \
     git build-essential libatlas-base-dev swig portaudio19-dev
     supervisor mosquitto sox alsa-utils libgfortran4 \
     espeak flite libttspico-utils \
     perl curl patchelf ca-certificates
```

and then clone/build:

```bash
git clone --recursive https://github.com/rhasspy/rhasspy-voltron
cd rhasspy-voltron/
make
```
