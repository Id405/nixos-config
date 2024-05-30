#!/usr/bin/env fish
echo "updating dependencies"
sudo nix flake update
echo "building system configuration..."
sudo nixos-rebuild --flake . switch --install-bootloader
and echo "building home configuration..."
and home-manager -b backup --flake . switch
and echo "building live image..."
and sudo nix build .#nixosConfigurations.live.config.system.build.isoImage
and echo "pushing git changes..."
and git add .
and git commit -m "`date`"
and git push
