# Nix Configs

An effort to merge my [dotfiles](https://github.com/breadcat/dotfiles), [dockerfiles](https://github.com/breadcat/Dockerfiles) and [ahk-assistant](https://github.com/breadcat/ahk-assistant) in a declarative way.

Amend your `variables.nix`, then run:
```
sudo nixos-rebuild -I nixos-config=entrypoint.nix switch
```

## Machines
* `arcadia` - Intel NUC HTPC
* `artemis` - Ampere VPS
* `atlas` - Gaming workstation
* `ilias` - Optiplex NAS
* `minerva` - Thinkpad Laptop

## Notes

### Hostnames
I'm intentionally avoiding using flakes for this project, so you'll need to set your hostname to one of the above, then run the switch command at the top.

### Filesystems
Filesystems are mounted via label, not UUID; so you'll want to label your drives before installing:
```
nix-shell -p dosfstools
sudo fatlabel /dev/sda1 NIXBOOT
sudo e2label /dev/sda2 NIXROOT
```

### Upgrades
All `system.stateVersion` are defined at time of install. To upgrade a system, change the channel:
```
sudo nix-channel --list
sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixos
sudo nix-channel --update
```
The home-manager version is defined in `common/home-manager.nix`.
