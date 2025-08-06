# Nix Configs

An effort to merge [dotfiles](https://github.com/breadcat/dotfiles), [dockerfiles](https://github.com/breadcat/Dockerfiles) and all things in between in a declarative way.

Amend your `variables.nix`, then run:
```
sudo nixos-rebuild -I nixos-config=entrypoint.nix switch
```
