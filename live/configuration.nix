{ config, pkgs, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" ];
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak,";
  i18n.consoleUseXkbConfig = true;
  
  networking.networkmanager.enable = true;
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "SHA256:sIEkER7FxEM8Qs5aYGGUm6YzaywUnP7vF498mdrtbS8 lily@nixos"
  ]
}

