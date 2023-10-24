nix flake update
sudo nixos-generate-config --dir ~/Dev/nixos/nixos
sudo nixos-rebuild --flake . switch --install-bootloader
home-manager -b backup --flake . switch
