{ config, pkgs, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" ];
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "colemak,";
  console.useXkbConfig = true;
  
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "SHA256:sIEkER7FxEM8Qs5aYGGUm6YzaywUnP7vF498mdrtbS8 lily@nixos"
  ];

  environment.systemPackages = with pkgs; [
    kakoune
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

