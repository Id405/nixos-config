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
    # inputs.lix-module.nixosModules.default
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
    #registry = lib.mapAttrs (_: value: { flake = hyprland.org/value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    #nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Enable the good shit
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["lily" "root" "@wheel"];
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
  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  services.beesd.filesystems = {
    root = {
      spec = "/";
      hashTableSizeMB = 2048;
      verbosity = "crit";
      extraOptions = [ "--loadavg-target" "5.0" ];
    };
  };

  # We need git for nix-rebuild to work
  programs.git.enable = true;

  # Other root packages
  programs.zsh.enable = true;
  environment.systemPackages = [ pkgs.pciutils ];

  # Internationalization stuff (#) <--- maybe it is sitelen pona ma?
  time.timeZone = "America/Los_Angeles";
  #i18n.defaultLocale = "en_US.utf8";
  #i18n.supportedLocales = [
  #  "en_US.UTF-8/UTF-8"
  #  "de_DE.UTF-8/UTF-8"
  #];

  services.kanata = {
    enable = true;
  
    keyboards = {
      kanata = {
       devices = [ "/dev/input/event0" ];
       extraDefCfg = "process-unmapped-keys yes";
  
  	config = ''
	(defsrc
	    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
	    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
	    caps a    s    d    f    g    h    j    k    l    ;    '    ret
	    lsft z    x    c    v    b    n    m    ,    .    /    rsft
	    lctl lmet lalt           spc            ralt rctrl
  	)

	(defalias mgc
	    (switch
		((key-history l 1)) t break
		((and (key-history o 2) (key-history u 1))) r break ;; preserve our 3-roll
		((key-history u 1)) i break
		((key-history t 1)) l break
		((key-history o 1)) a break
		((key-history p 1)) h break
		((key-history e 1)) e break
		() rpt break
	    )
	)

	(defalias qu
	    (switch
		((key-history w 1)) q break
		() (fork 
		    (tap-dance 200 (
			(fork (macro q u) (macro S-q (unshift u)) (lsft rsft)) 
			q
		    ))
		    q
		    (lctl lmet lalt ralt rctl)
		)  break
	    )
	)

  	(deflayer default
	    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
	    tab  j    o    u    @mgc @qu  f    d    l    b    g    [    ]    \
	    bspc e    a    i    n    x    y    h    t    s    c    '    ret
	    lsft /    .    ,    z    ;    k    p    m    v    w    rsft
	    lctl lmet lalt           spc            r    rctrl 
  	)
	'';

	# # # # (defzippy-experimental
	# # # #     ${builtins.toFile "zippy" ''
	# # # # 	th	the
	# # # # 	 a	a
	# # # # 	 an	an
	# # # #
	# # # 	an	and
	# # # 	as	as
	# # # 	or	or
	# # # 	bu	but
	# # # 	 i	if
	# # # 	so	so
	# # # 	tn	then
	# # # 	bc	because
	# # #
	# # 	to	to
	# # 	of	of
	# # 	in	in
	# # 	 r	for
	# # 	 w	with
	# # 	on	on
	# # 	at	at
	# # 	rm	from
	# # 	by	by
	# # 	ab	about
	# # 	up	up
	# # 	io	into
	# # 	ov	over
	# # 	ar	after
	# # 	wo	without
	# # 	 i	I
	# # 	me	me
	# # 	 m	my
	# # 	ou	you
	# # 	ur	your
	# # 	he	he
	# # 	hi	him
	# # 	his	his
	# # 	sh	she
	# # 	hr	her
	# # 	it	it
	# # 	ts	its
	# # 	we	we
	# # 	us	us
	# # 	our	our
	# # 	ty	they
	# # 	tr	their
	# # 	hm	them
	# #     }
	# #
	#     smart-space full
	#     smart-space-punctuation (? ! . , ; :)
	#     output-character-mappings (
	# 	;; This should work for US international.
	# 	! S-1
	# 	? S-/
	# 	% S-5
	# 	"(" S-9
	# 	")" S-0
	# 	: S-;
	# 	< S-,
	# 	> S-.
	# 	r#"""# S-'
	# 	| S-\
	# 	_ S--
	# 	® AG-r
	# 	’ (no-erase `)
	# 	é (single-output ' e)
	#     )
	# )
       };
     };
   };
    
  
  services.flatpak.enable = true;
	#
  # Printing stuff [#] <--- idk like a document or some shit
  services.printing = {
    enable = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [
	gutenprint
	gutenprint-bin
	cups-filters
	cups-browsed
	epson-escpr2
	epson-escpr
    ];
  };

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

  # Docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  # Enable opengl
  #nixpkgs.config.packageOverrides = pkgs: {
  #  intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  #};
  hardware.graphics = { # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
  #    intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  # Install steam
  programs.steam.enable = true;

  # Enable at-spi2-core
  services.gnome.at-spi2-core.enable = true;
  programs.dconf.enable = true;
  
  #steam fix?
  programs.steam.gamescopeSession.enable = true;


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
    openFirewall = true;
  };

  services.tailscale.enable = true;

  services.resolved.enable = true;

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
	"docker"
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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    inter
    scientifica
    cozette
    newcomputermodern
    linja-sike
  ];
}
