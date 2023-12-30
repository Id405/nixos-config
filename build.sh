nix flake update
sudo nixos-rebuild --flake . switch --install-bootloader
home-manager -b backup --flake . switch
