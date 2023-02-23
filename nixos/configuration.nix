{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = { allowUnfree = true; };
  };

  # nix wizardry <]:) <-- a little guy with a wizard hat
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    # Enable the good shit
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters =
        [ "https://webcord.cachix.org" "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Filesystem stuff [*_*]
  fileSystems."/".options = [ "compress=zstd" ]; # zstd compression :)

  # We need git for nix-rebuild to work
  programs.git.enable = true;

  # Other root packages
  programs.zsh.enable = true;
  environment.systemPackages = [ pkgs.pciutils ];

  # Internationalization stuff (#) <--- maybe it is sitelen pona ma?
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "colemak";

  # Printing stuff [#] <--- idk like a document or some shit
  services.printing.enable = true;

  # Sound 0^0 <--- its like a headphones or maybe an owl face
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable opengl
  hardware.opengl.enable = true;

  # Enable at-spi2-core
  services.gnome.at-spi2-core.enable = true;
  programs.dconf.enable = true;

  # Networking :/
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Bootloader and kernel :0
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      timeout = 0;
    };
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
  };

  # Silent getty
  services.getty.extraArgs =
    [ "--skip-login" "--nonewline" "--noissue" "--noclear" ];

  # Users \O/ \O/ \O/ <--- imagine these as lots of people
  users.users = {
    lily = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.fish;
    };
  };

  # Automatic login :DDDDD
  services.getty.autologinUser = "lily";

  # No sudo password
  security.sudo.wheelNeedsPassword = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
