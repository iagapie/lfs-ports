
# Starting Plasma5

You can start Plasma5 from a TTY, using xinit-1.4.1.

To start Plasma 5 using xinit-1.4.1, run the following commands:

```bash
cat > ~/.xinitrc << "EOF"
dbus-launch --exit-with-session $KF5_PREFIX/bin/startkde
EOF

startx
```

The X session starts on the first unused virtual terminal, normally vt7. You can switch to another vtn simultaneously pressing the keys Ctrl-Alt-Fn (n=1, 2, ...). To switch back to the X session, normally started at vt7, use Ctrl-Alt-F7. The vt where the command startx was executed will display many messages, including X starting messages, applications automatically started with the session, and eventually, some warning and error messages. You may prefer to redirect those messages to a log file, which not only will keep the initial vt uncluttered, but can also be used for debugging purposes. This can be done starting X with:

```bash
startx &> ~/x-session-errors
```

When shutting down or rebooting, the shutdown messages appear on the vt where X was running. If you wish to see those messages, simultaneously press keys Alt-F7 (assuming that X was running on vt7).

If you intend to start Plasma using a display manager such as lightdm-1.30.0, there will be two entries for Plasma, one for use with Xorg, and another for Wayland. Modify the Xorg entry with the following command, as the root user, so that you can differentiate between the two:

```bash
sed '/^Name=/s/Plasma/Plasma on Xorg/' -i /usr/share/xsessions/plasma.desktop
```
