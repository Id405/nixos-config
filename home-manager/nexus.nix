{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
    inputs.webcord.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "nexus";
    homeDirectory = "/home/nexus";
    sessionVariables = {
      EDITOR = "kak";
      NIXOS_OZONE_WL = "1";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  programs.home-manager.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [
    # Fonts
    pkgs.fira-code
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    nerdfonts
    inter

    # Daemons
    wl-clipboard

    # cli
    unzip
    exa
    nixfmt
    rustup

    # gui
    pavucontrol
    spotify
    slurp
    grim
    sway-contrib.grimshot
    libreoffice
    swaybg
    texlive.combined.scheme-full
    inkscape
    blueberry
    firefox
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  # Better command not found
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Webcord
  programs.webcord = { enable = true; };

  # fzf
  programs.fzf = { enable = true; };

  # zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Kakoune (TODO fix colorscheme to use same as desktop)
  programs.kakoune = {
    enable = true;
    config = {
      colorScheme = "default";
      autoInfo = null;
      ui.assistant = "none";
      keyMappings = [
        {
          key = "q";
          effect = "b";
          mode = "normal";
        }

        {
          key = "Q";
          effect = "B";
          mode = "normal";
        }

        {
          key = "<a-q>";
          effect = "<a-b>";
          mode = "normal";
        }

        {
          key = "<a-Q>";
          effect = "<a-B>";
          mode = "normal";
        }

        {
          key = "b";
          effect = ":enter-buffers-mode<ret>";
          mode = "normal";
          docstring = "buffers...";
        }

        {
          key = "B";
          effect = ":enter-user-mode -lock buffers<ret>";
          mode = "normal";
          docstring = "buffers (lock)...";
        }
      ];
      hooks = [
        { # Enable kakboard
          commands = "kakboard-enable";
          name = "WinCreate";
          option = ".*";
        }

        { # customize colors, modeline
          commands = ''
            set-face window MenuBackground default,default
            set-face window MenuForeground black,red
            set-face window Information default,default
          '';
          name = "WinCreate";
          option = ".*";
        }

        {
          commands = ''
            lsp-enable-window
            lsp-auto-hover-enable
          '';
          name = "WinSetOption";
          option = "filetype=(rust)";
        }

        {
          commands = "set-option buffer formatcmd 'nixfmt'";
          name = "BufSetOption";
          option = "filetype=nix";
        }

        {
          commands = "set-option buffer formatcmd 'rustfmt'";
          name = "BufSetOption";
          option = "filetype=rust";
        }
      ];
    };
    plugins = with pkgs.kakounePlugins; [ kakboard kak-lsp kakoune-buffers ];
    extraConfig = ''
      eval %sh{kak-lsp --kakoune -s $kak_session}

      hook global WinDisplay .* info-buffers

      alias global bd delete-buffer
      alias global bf buffer-first
      alias global bl buffer-last
      alias global bo buffer-only
      alias global bo! buffer-only-force
    '';
  };

  # Fish  
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec Hyprland &> /dev/null
      end
    '';
    interactiveShellInit = ''
      set fish_greeting
    '';
    functions = {
      hoed =
        "eval $EDITOR /etc/nixos/home-manager/home.nix; and env -C /etc/nixos/ /etc/nixos/build.sh";
      sysed =
        "eval $EDITOR /etc/nixos/nixos/configuration.nix; and env -C /etc/nixos /etc/nixos/build.sh";
    };
    shellAliases = {
      cd = "z";
      ls = "exa";
    };
    plugins = [{
      name = "hydro";
      src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "hydro";
        rev = "d4c107a2c99d1066950a09f605bffea61fc0efab";
        sha256 = "1ajh6klw1rkn2mqk4rdghflxlk6ykc3wxgwp2pzfnjd58ba161ki";
      };
    }];
  };

  # btop
  programs.btop = {
    enable = true;
    settings.color_theme = "TTY";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
