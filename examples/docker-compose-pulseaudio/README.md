The `docker-compose.yml` runs Rhasspy container that is connected to Pulseaudio.
As a regular user that has Pulseaudio running you can execute
`CURRENT_UID=$(id -u):$(id -g) docker-compose up`. It will start the docker container
as the same user as current user and setup Rhasspy available on http://localhost:12101 .

The `rhasspy.service` is a user systemd service file, that allows to execute Rhasspy upon
user login from systemd. To use it:

- Copy the contents of this directory to some custom chosen directory,
  for example to `~/.config/rhasspy/docker-compose`.
- Copy `rhasspy.service` to `~/.config/systemd/user/`.
- Edit `rhasspy.service` in `~/.config/systemd/user/` and change `WorkingDirectory`
  to the directory you copied `docker-compose.yml` into. You can use `%h` for
  user home directory, see https://www.freedesktop.org/~#Specifiers . for example:
  `WorkingDirectory=%h/.config/rhasspy/docker-compose`.
- Refresh Systemd `systemctl daemon-reload --user`.
- Then enable the service `systemctl enable --user rhasspy`.
- Then start the service `systemctl start --user rhasspy`.



