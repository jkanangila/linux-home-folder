## Rotate wallpaper in caelestia

### Manage files

```bash
stow --no-folding -t ~ rotate-wallpaper-caelestia
```

### Manage service

- Start timer

```bash
systemctl --user daemon-reload
systemctl --user enable --now caelestia-wallpaper-rotate.timer
```

- Check timer status

```bash
systemctl --user status caelestia-wallpaper-rotate.timer
systemctl --user list-timers
```
