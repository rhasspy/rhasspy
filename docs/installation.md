# Install

Rhasspy can be installed in several different ways. The easiest way is [with Docker](#docker), which will pull a 1.5-2GB image with all of the [officially supported services](https://github.com/rhasspy/rhasspy-voltron).

## Docker

The easiest way to try Rhasspy is with Docker. To get started, make sure you have [Docker installed](https://docs.docker.com/install/):

```bash
$ curl -sSL https://get.docker.com | sh
```

and that your user is part of the `docker` group:

```bash
$ sudo usermod -a -G docker $USER
```

**Be sure to reboot** after adding yourself to the `docker` group!

Next, start the [Rhasspy Docker image](https://hub.docker.com/r/rhasspy/rhasspy) in the background:

```bash
$ docker run -d -p 12101:12101 \
      --name rhasspy \
      --restart unless-stopped \
      -v "$HOME/.config/rhasspy/profiles:/profiles" \
      -v "/etc/localtime:/etc/localtime:ro" \
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
    container_name: rhasspy
    restart: unless-stopped
    volumes:
        - "$HOME/.config/rhasspy/profiles:/profiles"
        - "/etc/localtime:/etc/localtime:ro"
    ports:
        - "12101:12101"
    devices:
        - "/dev/snd:/dev/snd"
    command: --user-profiles /profiles --profile en
```

Rhasspy runs an MQTT broker inside the Docker image on port `12183` by default. Connecting to this broker will let you interact with Rhasspy over its [MQTT API](reference.md#mqtt-api).

### Updating

To update your Rhasspy Docker image, simply run:

```bash
$ docker pull rhasspy/rhasspy:2.5.0-pre
```

## Debian

**Coming soon**

Rhasspy will be packaged as a `.deb` file for easy non-Docker installation on Debian, Ubuntu, and Raspbian.

## Virtual Environment

See the [Github documentation](https://github.com/rhasspy/rhasspy-voltron). On a Debian system, you should only need to install the necessary dependencies:

```bash
$ sudo apt-get update
$ sudo apt-get install \
       python3 python3-dev python3-setuptools python3-pip python3-venv \
       git build-essential libatlas-base-dev swig portaudio19-dev
       supervisor mosquitto sox alsa-utils libgfortran4 \
       espeak flite libttspico-utils \
       perl curl patchelf ca-certificates
```

and then clone/build:

```bash
$ git clone --recursive https://github.com/rhasspy/rhasspy-voltron
$ cd rhasspy-voltron/
$ ./configure
$ make
$ make install
```

This will install Rhasspy inside a virtual environment at `$PWD/.venv` by default with **all** of the supported speech to text engines and supporting tools. When installation is finished, copy `rhasspy.sh` somewhere in your `PATH` and rename it to `rhasspy`.

### Customizing Installation

You can pass additional information to `configure` to avoid installing parts of Rhasspy that you won't use. For example, if you only plan to use the French language profiles, set the `RHASSPY_LANGUAGE` environment variable to `fr` when configuring your installation:

```bash
$ ./configure RHASSPY_LANGUAGE=fr
```

The installation will now be configured to install only Kaldi (if supported). If instead you want a specific speech to text system, use `RHASSPY_SPEECH_SYSTEM` like:

```bash
$ ./configure RHASSPY_SPEECH_SYSTEM=deepspeech
```

which will only enable DeepSpeech (on supported platforms). The `RHASSPY_WAKE_SYSTEM` variable controls which wake system is installed, such as `precise` or `porcupine`.

To force the supporting tools to be built from source instead of downloading pre-compiled binaries, use `--disable-precompiled-binaries`. Dependencies will be compiled in a `build` directory (override with `$BUILD_DIR` during `make`), and bundled for installation in `download` (override with `$DOWNLOAD_DIR`).

See `./configure --help` for additional options.

### Updating

To update your Rhasspy virtual environment, you must update your code and any dependencies:

```bash
$ git submodule foreach git pull origin master
$ git pull origin master
$ ./configure
$ make
$ make install
```

## Windows Subsystem for Linux (WSL)

If you're using Windows, you can run Rhasspy inside WSL and access its web interface from Windows. This setup is mainly
useful when you want to work on the Rhasspy source code. If you just plan to use it as an end user you should stick
to Docker.

### Prequisites

This documentation assumes that you have already set up a WSL environment. If not, you can do that by following
[this guide](https://docs.microsoft.com/en-us/windows/wsl/install-win10). It is recommended to use Debian or a derivate
like Ubuntu. The following steps were tested on Ubuntu 20.04 running in WSL 2.

### Rhasspy

Installing Rhasspy is basically the same procedure as if you were running Linux natively. Open your WSL terminal and
follow the steps from the section [Virtual Environment](#virtual-environment).

After you have started Rhasspy, open a web browser **in Windows** and open http://localhost:12101. You should see the
Rhasspy web interface.

You could use Rhasspy now, but you won't hear anything and can't interact with it with your voice because audio is not
working. Stick to the next section to learn how to fix that.

### Enabling audio

WSL does not natively support audio devices. Fortunately, there is a solution for that: You can run a PulseAudio server
on the Windows side and tell your PulseAudio clients in WSL to use the Windows PulseAudio server over the network.

#### Installation on Windows

You can find [pre-build binaries for Windows on this website](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/).
After downloading the zip file, extract it and make the following config changes:

**etc/pulse/default.pa**:

```
From: #load-module module-native-protocol-tcp
To:   load-module module-native-protocol-tcp auth-anonymous=1
```

Some guides use the option `auth-ip-acl` here, which is not required when you use `auth-anonymous=1` (this tells
PulseAudio to accept every connection).

**etc/pulse/daemon.pa**:

```
From: ; exit-idle-time = 20
To:   exit-idle-time = -1
```

After that you may need to add an exception for "pulseaudio.exe" to your Firewall (at least this was required for the
Windows Firewall). You may add a rule that allows TCP traffic for private and public networks.

That’s it for the Windows side! You can launch "pulseaudio.exe" now.

#### Installation on Linux

Install the PulseAudio command line tools:

```sh
$ sudo apt install pulseaudio-utils
```

Now you need to tell PulseAudio to use the remote server, which is running on your Windows host. You can do that by
defining an environment variable (you may want to add that line to your ".bashrc" file):

```sh
$ export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
```

You can use Netcat to see if a connection to the PulseAudio server can be established:

```sh
$ nc -vz $(grep nameserver /etc/resolv.conf | awk '{print $2}') 4713
```

Netcat should immediately return "Connection to 4713 port [tcp/*] succeeded!".

`parecord` and `paplay` should also work now.

##### ALSA

Rhasspy uses ALSA to play and record audio. That’s why we need to tell ALSA to use a virtual PulseAudio device. This is
quite easy.

Open "/etc/asound.conf" and insert the following content:

```conf
pcm.!default {
    type pulse
    # If defaults.namehint.showall is set to off in alsa.conf, then this is
    # necessary to make this pcm show up in the list returned by
    # snd_device_name_hint or aplay -L
    hint.description "Default Audio Device"
}
ctl.!default {
    type pulse
}
```

"type pulse" requires some extra libraries that can be installed with the following command:

```sh
$ sudo apt install libasound2-plugins
```

After that `arecord` and `aplay` should work just like their PulseAudio counterparts.
