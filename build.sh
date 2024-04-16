#!/usr/bin/env fish
sudo nix flake update
sudo nixos-rebuild --flake . switch --install-bootloader
and home-manager -b backup --flake . switch
and git add .
and git commit -m "`date`"
and git push
