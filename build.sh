nix flake update
sudo nixos-rebuild --flake . switch
home-manager -b backup --flake . switch
