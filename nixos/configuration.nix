{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "10";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in
{
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.musnix.nixosModules.musnix
    inputs.lix-module.nixosModules.default
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

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
  };

  # nix wizardry <]:) <-- a little guy with a wizard hat
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Enable the good shit
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "builder";
        system = "x86_64-linux";
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
    ];
    # buildMachines = [
    #   { hostName = "eu.nixbuild.net";
    #     system = "x86_64-linux";
    #     maxJobs = 100;
    #     supportedFeatures = [ "benchmark" "big-parallel" ];
    #   }
    # ];
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
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true; # enable bluetooth
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  musnix.enable = true;

  # Enable opengl
  hardware.opengl.enable = true;

  # Install steam
  programs.steam.enable = true;

  # Enable at-spi2-core
  services.gnome.at-spi2-core.enable = true;
  programs.dconf.enable = true;

  # Networking :/
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.tailscale.enable = true;

  # Bootloader and kernel :0
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      timeout = lib.mkDefault 0; # mkDefault so live cd isn't affected
    };
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "mem_sleep_default=deep" # sleep to ram instead of s2idle
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
  };

  # disable wait online for networkmanager, this saves 4 seconds on boot
  # this should be rectified to instead changing any targets which depend
  # on online for boot.
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # Power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  systemd.services."awake-after-suspend-for-a-time" = {
    description = "Sets up the suspend so that it'll wake for hibernation only if not on AC power";
    wantedBy = [ "suspend.target" ];
    before = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      if [ $(cat /sys/class/power_supply/AC/online) -eq 0 ]; then
        curtime=$(date +%s)
        echo "$curtime $1" >> /tmp/autohibernate.log
        echo "$curtime" > $HIBERNATE_LOCK
        ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
      else
        echo "System is on AC power, skipping wake-up scheduling for hibernation." >> /tmp/autohibernate.log
      fi
    '';
    serviceConfig.Type = "simple";
  };

  systemd.services."hibernate-after-recovery" = {
    description = "Hibernates after a suspend recovery due to timeout";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      curtime=$(date +%s)
      sustime=$(cat $HIBERNATE_LOCK)
      rm $HIBERNATE_LOCK
      if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
      else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      fi
    '';
    serviceConfig.Type = "simple";
  };

  # Backlight
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 10";
      }
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 10";
      }
    ];
  };

  # Silent getty
  services.getty.extraArgs = [
    "--skip-login"
    "--nonewline"
    "--noissue"
    "--noclear"
  ];

  # Users \O/ \O/ \O/ <--- imagine these as lots of people
  users.users = {
    lily = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "input"
        "dialout"
      ];
      shell = pkgs.fish;
    };
  };

  programs.fish.enable = true;

  programs.hyprland.enable = true;

  security.polkit.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Automatic login :DDDDD
  services.getty.autologinUser = "lily";

  # KDE
  # services.xserver.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.session = [{
  #    manage = "window";
  #    name = "Hyprland";
  #    start = ''
  #    exec Hyprland &> /dev/null
  #    waitPID=$!
  #    '';
  # }];

  # No sudo password
  security.sudo.wheelNeedsPassword = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
