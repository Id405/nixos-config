{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  nixWallpaperFromScheme = import ./wallpaperclean.nix { inherit pkgs; };
  nixWallpaperFromSchemeDetailed = import ./wallpaper.nix { inherit pkgs; };
  summercamp-desaturated = {
    name = "Summercamp Desaturated";
    slug = "summercamp-desaturated";
    author = "zoe firi (modified by Id405";
    palette = {
      base00 = "1c1c1c";
      base01 = "282828";
      base02 = "3a3a3a";
      base03 = "4f4f4f";
      base04 = "5e5e5e";
      base05 = "727272";
      base06 = "bababa";
      base07 = "f7f7f7";
      base08 = "e35142";
      base09 = "fba11b";
      base0A = "f2ff27";
      base0B = "5ceb5a";
      base0C = "5aebbc";
      base0D = "489bf0";
      base0E = "FF8080";
      base0F = "F69BE7";
    };
  };
  fontSize = 10;
  fontSizeSmall = 9;
  uiFont = "Inter";
  programmingFont = "FiraCode Nerd Font";
  terminalEmulator = "kitty";
in
{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
    # inputs.lix-module.nixosModules.default

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
      # (final: prev: {
      #   waybar = prev.waybar.overrideAttrs (oldAttrs: {
      #     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      #   });
      # })

      # (final: prev:
      #   let
      #     nixpkgs-wine94 = import (prev.fetchFromGitHub {
      #       owner = "NixOS";
      #       repo = "nixpkgs";
      #       rev =
      #         "59322d8a3603ef35a0b5564b00109f4a6436923e"; # wineWow64Packages.unstable: 9.3 -> 9.4
      #       sha256 = "Ln3mD5t96hz5MoDwa8NxHFq76B+V2BOppYf1tnwFBIc=";
      #     }) { system = "x86_64-linux"; };
      #   in { inherit (nixpkgs-wine94) yabridge yabridgectl; })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [ "electron-28.3.3" "python-2.7.18.8-env" "python-2.7.18.8"   ];
    };
  };

  home = {
    username = "lily";
    homeDirectory = "/home/lily";
    sessionVariables = {
      EDITOR = "vi";
      NIXOS_OZONE_WL = "1";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  programs.home-manager.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [
    # Daemons
    wl-clipboard
    polkit_gnome
    leptosfmt
    python312Packages.python-lsp-server

    # cli
    unzip
    zip
    eza
    rustup
    libqalculate
    killall
    yt-dlp
    gnupg
    gcc
    pre-commit
    wasm-pack
    #nodePackages.npm
    #nodePackages.typescript-language-server
    nodejs
    trunk
    dart-sass
    exiv2
    black
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.numpy
      python-pkgs.transformers
      python-pkgs.torch
      python-pkgs.accelerate
      python-pkgs.pyaudio
    ]))
    pylint
    rclone
    typst
    zola
    docker-compose
    pandoc
    smassh
    flatpak
    python3Packages.virtualenv

    # gui
    pavucontrol
    spotify
    nemo
    slurp
    grim
    sway-contrib.grimshot
    swww
    texlive.combined.scheme-full
    blueberry
    gimp
    obsidian
    mpv
    feh
    prismlauncher
    # darktable
    # mathematica
    scrcpy
    wineWowPackages.waylandFull
    dxvk
    vesktop
    # cura
    ugs
    fontforge-gtk
    inkscape
    system-config-printer
    inputs.zen-browser.packages."${system}".default
    kicad
    networkmanagerapplet
    slipstream
    shotcut
    vial
    #inputs.ftlman.packages."${system}".default
    easyeffects
    gamescope
    protontricks
    nm-applet

    # Audio Production
    reaper
    vital
    # helm
    lsp-plugins
    #yabridge
    #yabridgectl
    mooSpace
    dragonfly-reverb
    hybridreverb2
    aether-lv2
    zenity
    musescore
    yabridgectl
    yabridge

    # Dependencies for unmanaged programs
    zulu
    openal
    alsa-oss
  ];
  
  # Color scheme
  colorScheme = summercamp-desaturated;
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
              # Monitors
              monitor=eDP-1,2256x1504@60,0x0,1.333333
      	      monitor=,highres,auto,1
      	
              # HiDPI XWayland
              exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
                    
              # Programs
              bind=SUPER,Return,exec,${terminalEmulator}
              bind=SUPER,Space,exec,rofi -show drun -show-icons -icon-theme yaru
              bind=SUPER,b,exec,grimshot copy area

              # Wm controls
              bind=SUPER,c,killactive
              bind=SUPER,bracketright,workspace,+1
              bind=SUPER,bracketleft,workspace,-1
              bind=SUPERSHIFT,bracketright,movetoworkspace,+1
              bind=SUPERSHIFT,bracketleft,movetoworkspace,-1
              bind=SUPER,f,togglefloating
              bind=SUPERSHIFT,f,fullscreen
              bind=SUPER,Tab,cyclenext
              bind=SUPERSHIFT,t,cyclenext,prev
              bind=SUPERSHIFT,q,exit

              # Mouse bindings
              bindm=SUPER,v,movewindow
              bindm=SUPERALT,v,resizewindow
              bindm=SUPER,mouse:272,movewindow
              bindm=SUPER,mouse:273,resizewindow

              # status bar
              exec-once="waybar"

              # mouse
              device {
                name = glorious-model-o
                sensitivity = -2
              }

	      debug {
		disable_logs = false
	      }

              # wallpaper
              exec-once=bash -c "swww init && sleep 0.1 && swww img --transition-type wipe --transition-angle 170 --transition-duration 3 ${
                nixWallpaperFromSchemeDetailed {
                  scheme = config.colorscheme;
                  width = 2256;
                  height = 1504;
                  logoScale = 5.0;
                  fontName = uiFont;
                  versionText = inputs.nixpkgs.lib.version;
                }
              } && sleep 10 && swww img --transition-type wipe --transition-angle 30 ${
                nixWallpaperFromScheme {
                  scheme = config.colorscheme;
                  width = 2256;
                  height = 1504;
                  logoScale = 5.0;
                  fontName = uiFont;
                  versionText = inputs.nixpkgs.lib.version;
                }
              }"

              # polkit
              exec-once="${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

              # animations

              bezier = overshot, 0.05, 0.9, 0.1, 1.05
              bezier = smoothOut, 0.36, 0, 0.66, -0.56
              bezier = smoothIn, 0.25, 1, 0.5, 1

              animation = windows, 1, 3, overshot, slide
              animation = windowsOut, 1, 3, smoothOut, slide
              animation = windowsMove, 1, 3, default
              animation = border, 1, 3, default
              animation = fade, 1, 3, smoothIn
              animation = fadeDim, 1, 3, smoothIn
              animation = workspaces, 1, 3, default
              
              general {
                border_size = 0
                col.inactive_border = rgba(${config.colorscheme.palette.base00}ff)
                col.active_border = rgba(${config.colorscheme.palette.base08}ff)
                gaps_in = 12
                gaps_out = 12
              }
                    
              misc {
                disable_hyprland_logo = true
                enable_swallow = true
                swallow_regex = '^(kitty)$'
              }

              decoration {
                rounding = 12
                shadow {
                  enabled = true
                  color = 0x22000000
                  range = 12
                }
                dim_inactive = true
                dim_strength = 0.05
              }

              gestures {
                workspace_swipe = true
                workspace_swipe_invert = false
              }

              input {
                kb_layout = us
                #kb_variant = colemak

                touchpad {
                  disable_while_typing=false
                }
              }

	    # Rusty Retirement Game Overlay
	    windowrulev2 = tag +rtr, title:(Rusty's Retirement)
	    windowrulev2 = float, tag:rtr

	    # Remove this if you don't want rtr to appear in all workspaces
	    windowrulev2 = pin, tag:rtr

	    windowrulev2 = size 100% 411, tag:rtr

	    # Move rtr to buttom of the screen
	    windowrulev2 = move 0 715, tag:rtr

	    windowrulev2 = noblur, tag:rtr
	    windowrulev2 = noshadow, tag:rtr
	    windowrulev2 = noborder, tag:rtr
	    windowrulev2 = opacity 1 override, tag:rtr
    '';
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "top";
      exclusive = true;
      mode = "dock";
      layer = "top";
      height = 30;
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [
        "battery"
        "clock"
      ];

      "hyprland/workspaces" = {
        all-outputs = true;
        format = "{name}:  {windows}";
	format-window-seperator = " ";
	window-rewrite-default = "";
	window-rewrite = {
	   "title<.*youtube.*>" = "";
	   "class<firefox>" = "";
	   "class<firefox> title<.*github.*>" = ""; 
	   "kitty" = ""; 
	   "code" = "󰨞";
	   "vesktop" = "󰙯";
	   "steam" = "";
	   "blender" = "󰂫";
	};
      };

      "clock" = {
	format = "{:%I:%M %p}";
      };

      "pulseaudio/slider" = {
	min = 0;
	max = 100;
	orientation = "horizontal";
      }; 
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${uiFont};
        font-size: ${toString fontSizeSmall}pt;
        background-color: #${config.colorScheme.palette.base00};
        color: #fff;
        padding-left: 5px;
        padding-right: 5px;
      }

      #workspaces button.active {
        color: #fff;
      }

      #pulseaudio-slider trough, #backlight-slider trough {
	min-height: 10px;
	min-width: 80px;
      }

    '';
  };

  # rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background-color = mkLiteral "#${config.colorScheme.palette.base00}";
          foreground-color = mkLiteral "#${config.colorScheme.palette.base07}";
          text-color = mkLiteral "#${config.colorScheme.palette.base07}";
          font = "${uiFont} ${toString fontSize}";
          border-radius = mkLiteral "0.25em";
        };

        "element-text" = {
          vertical-align = mkLiteral "0.5";
          background-color = mkLiteral "inherit";
        };

        "window" = {
          #width = mkLiteral "20em";
          #anchor = mkLiteral "north";
          #location = mkLiteral "north";
          padding = mkLiteral "1em 75% 1em 1em";
          fullscreen = true;
          children = map mkLiteral [
            "inputbar"
            "listview"
          ];
        };

        "prompt" = {
          enabled = false;
        };

        "entry" = {
          placeholder = "launch...";
        };

        "selected" = {
          background-color = mkLiteral "#${config.colorScheme.palette.base08}";
        };

        "element-icon" = {
          size = mkLiteral "1em";
          margin = mkLiteral "0.25em";
          background-color = mkLiteral "inherit";
        };
      };
  };

  # mako
  services.mako.enable = true;

  services.syncthing.enable = true;

  # Fonts
  fonts.fontconfig.enable = true;

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      name = programmingFont;
      size = fontSize;
    };

    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 12;
      foreground = "#${config.colorScheme.palette.base05}";
      background = "#${config.colorScheme.palette.base00}";
      selection_background = "#${config.colorScheme.palette.base08}";
      selection_foreground = "#${config.colorScheme.palette.base00}";
      url_color = "#${config.colorScheme.palette.base0D}";
      cursor = "#${config.colorScheme.palette.base07}";
      color0 = "#${config.colorScheme.palette.base00}";
      color1 = "#${config.colorScheme.palette.base08}";
      color2 = "#${config.colorScheme.palette.base0B}";
      color3 = "#${config.colorScheme.palette.base0A}";
      color4 = "#${config.colorScheme.palette.base0D}";
      color5 = "#${config.colorScheme.palette.base0E}";
      color6 = "#${config.colorScheme.palette.base0C}";
      color7 = "#${config.colorScheme.palette.base05}";
      color8 = "#${config.colorScheme.palette.base03}";
      color9 = "#${config.colorScheme.palette.base08}";
      color10 = "#${config.colorScheme.palette.base0B}";
      color11 = "#${config.colorScheme.palette.base0A}";
      color12 = "#${config.colorScheme.palette.base0D}";
      color13 = "#${config.colorScheme.palette.base0E}";
      color14 = "#${config.colorScheme.palette.base0C}";
      color15 = "#${config.colorScheme.palette.base07}";
      color16 = "#${config.colorScheme.palette.base09}";
      color17 = "#${config.colorScheme.palette.base0F}";
      color18 = "#${config.colorScheme.palette.base01}";
      color19 = "#${config.colorScheme.palette.base02}";
      color20 = "#${config.colorScheme.palette.base04}";
      color21 = "#${config.colorScheme.palette.base06}";
      linux_display_server = "wayland";
    };
  };

  # programs.wezterm = {
  #   enable = true;
  #   colorSchemes.custom = {
  #     background = "#${config.colorScheme.palette.base00}";
  #     foreground = "#${config.colorScheme.palette.base05}";
  #     selection_bg = "#${config.colorScheme.palette.base08}";
  #     selection_fg = "#${config.colorScheme.palette.base00}";
  #     cursor_bg = "#${config.colorScheme.palette.base0D}";
  #     cursor_fg = "#${config.colorScheme.palette.base00}";
  #     ansi = [
  #       "#${config.colorScheme.palette.base00}"
  #       "#${config.colorScheme.palette.base08}"
  #       "#${config.colorScheme.palette.base0B}"
  #       "#${config.colorScheme.palette.base0A}"
  #       "#${config.colorScheme.palette.base0D}"
  #       "#${config.colorScheme.palette.base0E}"
  #       "#${config.colorScheme.palette.base0C}"
  #       "#${config.colorScheme.palette.base05}"
  #     ];
  #     brights = [
  #       "#${config.colorScheme.palette.base03}"
  #       "#${config.colorScheme.palette.base08}"
  #       "#${config.colorScheme.palette.base0B}"
  #       "#${config.colorScheme.palette.base0A}"
  #       "#${config.colorScheme.palette.base0D}"
  #       "#${config.colorScheme.palette.base0E}"
  #       "#${config.colorScheme.palette.base0C}"
  #       "#${config.colorScheme.palette.base07}"
  #     ];
  #   };
  #   extraConfig = ''
  #     local wezterm = require 'wezterm'
  #     local config = wezterm.config_builder()

  #     config.font = wezterm.font '${programmingFont}'
  #     config.color_scheme = 'custom'
  #     config.front_end = "WebGpu"
  #     config.enable_tab_bar = false
  #     config.font_size = ${toString fontSize}

  #     return config
  #   '';
  # };

  # Gtk
  gtk = {
    enable = true;
    font = {
      name = uiFont;
      size = fontSize;
    };
    iconTheme = {
      package = pkgs.yaru-theme;
      name = "yaru";
    };
  };

  # Gtk theme
  gtk.theme = {
    name = "${config.colorScheme.slug}";
    package = gtkThemeFromScheme { scheme = config.colorScheme; };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.ahrm.sioyek.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = [ "org.ahrm.sioyek.desktop" ];
      };
    };
  };

  # Cursor
  home.pointerCursor = {
    name = "Numix-Cursor-Light";
    package = pkgs.numix-cursor-theme;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  # Better command not found
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Firefox
  programs.firefox = {
    enable = true;
    profiles."default" = {
      userChrome = import ./firefox/userChrome.nix {
        colors = config.colorScheme.palette;
        fontSize = fontSize;
        fontSizeSmall = fontSizeSmall;
      };
      userContent = import ./firefox/userContent.nix {
        colors = config.colorScheme.palette;
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };


  # Zathura
  # programs.zathura = {
  #   enable = true;
  #   options = {
  #     default-bg = "#${config.colorScheme.palette.base00}";
  #     default-fg = "#${config.colorScheme.palette.base07}";
  #     inputbar-bg = "#${config.colorScheme.palette.base00}";
  #     inputbar-fg = "#${config.colorScheme.palette.base07}";
  #     statusbar-bg = "#${config.colorScheme.palette.base00}";
  #     statusbar-fg = "#${config.colorScheme.palette.base07}";
  #     recolor-lightcolor = "#${config.colorScheme.palette.base00}";
  #     recolor-darkcolor = "#${config.colorScheme.palette.base07}";
  #     recolor = true;
  #     guioptions = "none";
  #   };
  # };

  # sioyek
  programs.sioyek = {
    enable = true;
    #package = sioyek-developement;
    config = {
      "background_color" = "#${config.colorScheme.palette.base00}";
      "dark_mode_background_color" = "#${config.colorScheme.palette.base00}";
      "dark_mode_contrast" = "0.94";
      "text_highlight_color" = "#${config.colorScheme.palette.base0C}";
      "visual_mark_color" = "#${config.colorScheme.palette.base07}";
      "search_highlight_color" = "#${config.colorScheme.palette.base0B}";
      "link_highlight_color" = "#${config.colorScheme.palette.base0D}";
      "should_launch_new_window" = "1";
      "default_dark_mode" = "1";
      "ui_font" = uiFont;
      "status_bar_color" = "#${config.colorScheme.palette.base00}";
      "status_bar_text_color" = "#${config.colorScheme.palette.base07}";
      "status_bar_font_size" = "${toString fontSize}";
      "ui_background_color" = "#${config.colorScheme.palette.base00}";
      "ui_text_colors" = "#${config.colorScheme.palette.base06}";
      "ui_selected_background_color" = "#${config.colorScheme.palette.base0D}";
      "ui_selected_text_color" = "#${config.colorScheme.palette.base00}";
      "custom_background_color" = "#${config.colorScheme.palette.base00}";
      "custom_text_color" = "#${config.colorScheme.palette.base07}";
      "startup_commands" = "toggle_custom_color;toggle_statusbar;toggle_presentation_mode";
    };
    bindings = {
      "screen_down" = "<C-<pagedown>>";
      "screen_up" = "<C-<pageup>>";
      "next_page" = "<space>";
      "previous_page" = "<S-<space>>";
      "fit_to_page_width" = "<unbound>";
      "fit_to_page_height" = "<f9>";
      "fit_to_page_width_smart" = "<unbound>";
      "fit_to_page_height_smart" = "<f10>";
      "toggle_two_page_mode" = "a";
    };
  };

  # Vscode
  #programs.vscode = {
  #  enable = true;
  #  extensions = [ pkgs.vscode-extensions.james-yu.latex-workshop ];
  #  userSettings = {
  #    "keyboard.dispatch" = "keyCode";
  #    "window.menuBarVisibility" = "hidden";
  #  };
  #};

  # zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Kakoune (TODO fix colorscheme to use same as desktop)
  # programs.kakoune = {
  #   enable = true;
  #   config = {
  #     colorScheme = "default";
  #     autoInfo = null;
  #     ui.assistant = "none";
  #     keyMappings = [
  #       {
  #         key = "q";
  #         effect = "b";
  #         mode = "normal";
  #       }

  #       {
  #         key = "Q";
  #         effect = "B";
  #         mode = "normal";
  #       }

  #       {
  #         key = "<a-q>";
  #         effect = "<a-b>";
  #         mode = "normal";
  #       }

  #       {
  #         key = "<a-Q>";
  #         effect = "<a-B>";
  #         mode = "normal";
  #       }

  #       {
  #         key = "b";
  #         effect = ":enter-buffers-mode<ret>";
  #         mode = "normal";
  #         docstring = "buffers...";
  #       }

  #       {
  #         key = "B";
  #         effect = ":enter-user-mode -lock buffers<ret>";
  #         mode = "normal";
  #         docstring = "buffers (lock)...";
  #       }
  #     ];
  #     hooks = [
  #       { # Enable kakboard
  #         commands = "kakboard-enable";
  #         name = "WinCreate";
  #         option = ".*";
  #       }

  #       { # customize colors, modeline
  #         commands = ''
  #           set-face window MenuBackground default,default
  #           set-face window MenuForeground black,red
  #           set-face window Information default,default
  #         '';
  #         name = "WinCreate";
  #         option = ".*";
  #       }

  #       {
  #         commands = ''
  #           lsp-enable-window
  #           lsp-auto-hover-enable
  #         '';
  #         name = "WinSetOption";
  #         option = "filetype=(rust)";
  #       }

  #       {
  #         commands = "set-option buffer formatcmd 'nixfmt'";
  #         name = "BufSetOption";
  #         option = "filetype=nix";
  #       }

  #       {
  #         commands = "set-option buffer formatcmd 'rustfmt'";
  #         name = "BufSetOption";
  #         option = "filetype=rust";
  #       }
  #     ];
  #   };
  #   plugins = with pkgs.kakounePlugins; [
  #     kakboard
  #     kakoune-lsp
  #     kakoune-buffers
  #   ];
  #   extraConfig = ''
  #     eval %sh{kak-lsp --kakoune -s $kak_session}

  #     hook global WinDisplay .* info-buffers

  #     alias global bd delete-buffer
  #     alias global bf buffer-first
  #     alias global bl buffer-last
  #     alias global bo buffer-only
  #     alias global bo! buffer-only-force
  #   '';
  # };

  # espanso
  # services.espanso = {
  #   enable = true;
  #   package = pkgs.espanso-wayland;
  #   configs = {
  #     default = {
  #       toggle_key = "LEFT_META";
  #       keyboard_layout = {
  #         layout = "us";
  #         variant = "colemak";
  #       };
  #     };
  #   };
  #
  #         {
  #           trigger = ":epsilon";
  #           replace = "ε";
  #         }
  #
  #         {
  #           trigger = ":theta";
  #           replace = "θ";
  #         }
  #
  #         {
  #           trigger = ":lambda";
  #           replace = "λ";
  #         }
  #
  #         {
  #           trigger = ":mu";
  #           replace = "μ";
  #         }
  #
  #         {
  #           trigger = ":pi";
  #           replace = "π";
  #         }
  #
  #         {
  #           trigger = ":sigma";
  #           replace = "σ";
  #         }
  #
  #         {
  #           trigger = ":partial";
  #           replace = "∂";
  #         }
  #
  #         {
  #           trigger = ":in";
  #           replace = "ϵ";
  #         }
  #
  #         {
  #           trigger = ":phi";
  #           replace = "ϕ";
  #         }
  #
  #         {
  #           trigger = ":real";
  #           replace = "ℝ";
  #         }
  #
  #         {
  #           trigger = ":rational";
  #           replace = "ℚ";
  #         }
  #
  #         {
  #           trigger = ":natural";
  #           replace = "ℕ";
  #         }
  #
  #         {
  #           trigger = ":integer";
  #           replace = "ℤ";
  #         }
  #
  #         {
  #           trigger = ":^0";
  #           replace = "⁰";
  #         }
  #
  #         {
  #           trigger = ":^1";
  #           replace = "¹";
  #         }
  #
  #         {
  #           trigger = ":^2";
  #           replace = "²";
  #         }
  #
  #         {
  #           trigger = ":^3";
  #           replace = "³";
  #         }
  #
  #         {
  #           trigger = ":^4";
  #           replace = "⁴";
  #         }
  #
  #         {
  #           trigger = ":^5";
  #           replace = "⁵";
  #         }
  #
  #         {
  #           trigger = ":^6";
  #           replace = "⁶";
  #         }
  #
  #         {
  #           trigger = ":^7";
  #           replace = "⁷";
  #         }
  #
  #         {
  #           trigger = ":^8";
  #           replace = "⁸";
  #         }
  #
  #         {
  #           trigger = ":^9";
  #           replace = "⁹";
  #         }
  #
  #         {
  #           trigger = ":^n";
  #           replace = "ⁿ";
  #         }
  #
  #         {
  #           trigger = ":^i";
  #           replace = "ⁱ";
  #         }
  #
  #         {
  #           trigger = ":^x";
  #           replace = "ˣ";
  #         }
  #
  #         {
  #           trigger = ":^-";
  #           replace = "⁻";
  #         }
  #
  #         {
  #           trigger = ":^+";
  #           replace = "⁺";
  #         }
  #
  #         {
  #           trigger = ":^(";
  #           replace = "⁽";
  #         }
  #
  #         {
  #           trigger = ":^)";
  #           replace = "⁾";
  #         }
  #
  #         {
  #           trigger = ":_0";
  #           replace = "₀";
  #         }
  #
  #         {
  #           trigger = ":_1";
  #           replace = "₁";
  #         }
  #
  #         {
  #           trigger = ":_2";
  #           replace = "₂";
  #         }
  #
  #         {
  #           trigger = ":_3";
  #           replace = "₃";
  #         }
  #
  #         {
  #           trigger = ":_4";
  #           replace = "₄";
  #         }
  #
  #         {
  #           trigger = ":_5";
  #           replace = "₅";
  #         }
  #
  #         {
  #           trigger = ":_6";
  #           replace = "₆";
  #         }
  #
  #         {
  #           trigger = ":_7";
  #           replace = "₇";
  #         }
  #
  #         {
  #           trigger = ":_8";
  #           replace = "₈";
  #         }
  #
  #         {
  #           trigger = ":_9";
  #           replace = "₉";
  #         }
  #
  #         {
  #           trigger = ":_+";
  #           replace = "₊";
  #         }
  #
  #         {
  #           trigger = ":_-";
  #           replace = "₋";
  #         }
  #
  #         {
  #           trigger = ":_(";
  #           replace = "₍";
  #         }
  #
  #         {
  #           trigger = ":_)";
  #           replace = "₎";
  #         }
  #
  #         {
  #           trigger = ":_n";
  #           replace = "ₙ";
  #         }
  #
  #         {
  #           trigger = ":_m";
  #           replace = "ₘ";
  #         }
  #
  #         {
  #           trigger = ":_k";
  #           replace = "ₖ";
  #         }
  #
  #         {
  #           trigger = ":/";
  #           replace = "⁄";
  #         }
  #
  #         {
  #           trigger = ":cdots";
  #           replace = "⋯";
  #         }
  #
  #         {
  #           trigger = "...";
  #           replace = "…";
  #         }
  #
  #         {
  #           trigger = "=>";
  #           replace = "⇒";
  #         }
  #       ];
  #     };
    # };
  # };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      lazy-lsp-nvim
      nvim-treesitter.withAllGrammars
      plenary-nvim
      nvim-cmp
      cmp-nvim-lsp
      mini-nvim
      nvim-treesitter-textobjects
      targets-vim
      nvim-surround
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      vim-fugitive
      vim-repeat
      vimtex
      base16-nvim
      which-key-nvim
      dropbar-nvim
      lualine-nvim
      noice-nvim
      nui-nvim
      typst-preview-nvim
      tiny-inline-diagnostic-nvim
      comment-nvim
    ];

    extraLuaConfig = ''
    require("lazy-lsp").setup {
      excluded_servers = {
	excluded_servers = {
	  "ccls",                            -- prefer clangd
	  "denols",                          -- prefer eslint and ts_ls
	  "docker_compose_language_service", -- yamlls should be enough?
	  "flow",                            -- prefer eslint and ts_ls
	  "quick_lint_js",                   -- prefer eslint and ts_ls
	  "scry",                            -- archived on Jun 1, 2023
	  "tailwindcss",                     -- associates with too many filetypes
	  "biome",                           -- not mature enough to be default
	},
      },
      preferred_servers = {
	markdown = {},
	python = { "pyright" },
	nix = { "nil" },
      },
      configs = {
	lua_ls = {
	  settings = {
	    Lua = {
	      diagnostics = {
		-- Get the language server to recognize the `vim` global
		globals = { "vim" },
	      },
	    },
	  },
	},
      },
    }

    -- Reserve a space in the gutter
    vim.opt.signcolumn = 'yes'

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lspconfig_defaults.capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    -- This is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
	local opts = {buffer = event.buf}

	vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
	vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end,
    })

    local cmp = require('cmp')

    cmp.setup({
      sources = {
	{name = 'nvim_lsp'},
      },
      snippet = {
	expand = function(args)
	  -- You need Neovim v0.10 to use vim.snippet
	  vim.snippet.expand(args.body)
	end,
      },
      mapping = cmp.mapping.preset.insert({}),
    }) 

    require('base16-colorscheme').setup({
      base00 = '#${config.colorScheme.palette.base00}',
      base01 = '#${config.colorScheme.palette.base01}',
      base02 = '#${config.colorScheme.palette.base02}',
      base03 = '#${config.colorScheme.palette.base03}',
      base04 = '#${config.colorScheme.palette.base04}',
      base05 = '#${config.colorScheme.palette.base05}',
      base06 = '#${config.colorScheme.palette.base06}',
      base07 = '#${config.colorScheme.palette.base07}',
      base08 = '#${config.colorScheme.palette.base08}',
      base09 = '#${config.colorScheme.palette.base09}',
      base0A = '#${config.colorScheme.palette.base0A}',
      base0B = '#${config.colorScheme.palette.base0B}',
      base0C = '#${config.colorScheme.palette.base0C}', 
      base0D = '#${config.colorScheme.palette.base0D}',
      base0E = '#${config.colorScheme.palette.base0E}',
      base0F = '#${config.colorScheme.palette.base0F}',
    })

    vim.cmd [[set conceallevel=2]]
    vim.cmd [[set concealcursor=nc]]
    vim.cmd [[set shiftwidth=4]]
    vim.cmd [[set clipboard=unnamedplus]]
    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

    local colors = {
      blue   = '#${config.colorScheme.palette.base0D}',
      cyan   = '#${config.colorScheme.palette.base0C}',
      black  = '#${config.colorScheme.palette.base00}',
      white  = '#${config.colorScheme.palette.base07}',
      red    = '#${config.colorScheme.palette.base08}',
      violet = '#${config.colorScheme.palette.base0E}',
      grey   = '#${config.colorScheme.palette.base00}',
    }

    local bubbles_theme = {
      normal = {
	a = { fg = colors.black, bg = colors.violet },
	b = { fg = colors.white, bg = colors.grey },
	c = { fg = colors.white },
      },

      insert = { a = { fg = colors.black, bg = colors.blue } },
      visual = { a = { fg = colors.black, bg = colors.cyan } },
      replace = { a = { fg = colors.black, bg = colors.red } },

      inactive = {
	a = { fg = colors.white, bg = colors.black },
	b = { fg = colors.white, bg = colors.black },
	c = { fg = colors.white },
      },
    }

    require('lualine').setup {
      options = {
	theme = bubbles_theme,
	component_separators = "",
	section_separators = { left = '', right = '' },
      },
      sections = {
	lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
	lualine_b = { 'filename', 'branch' },
	lualine_c = {
	  '%=', --[[ add your center compoentnts here in place of this comment ]]
	},
	lualine_x = {},
	lualine_y = { 'filetype', 'progress' },
	lualine_z = {
	  { 'location', separator = { right = '' }, left_padding = 2 },
	},
      },
      inactive_sections = {
	lualine_a = { 'filename' },
	lualine_b = {},
	lualine_c = {},
	lualine_x = {},
	lualine_y = {},
	lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }

    require("noice").setup({
      lsp = {
	-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	override = {
	  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	  ["vim.lsp.util.stylize_markdown"] = true,
	  ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
	},
      },
      -- you can enable a preset for easier configuration
      presets = {
	bottom_search = true, -- use a classic bottom cmdline for search
	command_palette = true, -- position the cmdline and popupmenu together
	long_message_to_split = true, -- long messages will be sent to a split
	inc_rename = false, -- enables an input dialog for inc-rename.nvim
	lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      views = {
	cmdline_popup={
	  border = {
	    style='none',
	  },
	},
      },
    })

    require("typst-preview").setup({
      dependencies_bin = {
	['tinymist'] = 'tinymist',
	['websocat'] = 'websocat',
      }
    })

    require('tiny-inline-diagnostic').setup({
	preset = "simple",
	options = {
	    multiple_diag_under_cursor = true,
	    multilines = true,
	    show_all_diags_on_cursorline = true,
	},
    })

    vim.diagnostic.config {
      virtual_text = false,
    }

    require('Comment').setup()

    require('nvim-surround').setup()

    require('telescope').setup()

    require('telescope').load_extension "file_browser"

    vim.keymap.set('n', '<space>f', '<Cmd>Telescope file_browser<CR>')

    local TelescopeColor = {
	    TelescopeMatching = { fg = '#${config.colorScheme.palette.base08}' },
	    TelescopeSelection = { fg = '#${config.colorScheme.palette.base07}', bg = '#${config.colorScheme.palette.base00}', bold = true },

	    TelescopePromptPrefix = { bg = '#${config.colorScheme.palette.base00}' },
	    TelescopePromptNormal = { bg = '#${config.colorScheme.palette.base00}' },
	    TelescopeResultsNormal = { bg = '#${config.colorScheme.palette.base00}' },
	    TelescopePreviewNormal = { bg = '#${config.colorScheme.palette.base00}' },
	    TelescopePromptBorder = { bg = '#${config.colorScheme.palette.base00}', fg = '#${config.colorScheme.palette.base00}'},
	    TelescopeResultsBorder = { bg = '#${config.colorScheme.palette.base00}', fg = '#${config.colorScheme.palette.base00}' },
	    TelescopePreviewBorder = { bg = '#${config.colorScheme.palette.base00}', fg = '#${config.colorScheme.palette.base00}' },
	    TelescopePromptTitle = { bg = '#${config.colorScheme.palette.base00}', fg = '#${config.colorScheme.palette.base00}' },
    }

    for hl, col in pairs(TelescopeColor) do
	    vim.api.nvim_set_hl(0, hl, col)
    end

    '';

    extraPackages = with pkgs; [
	tinymist
	websocat
    ];
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
      hoed = "eval $EDITOR /etc/nixos/home-manager/home.nix; and env -C /etc/nixos/ /etc/nixos/build.sh";
      sysed = "eval $EDITOR /etc/nixos/nixos/configuration.nix; and env -C /etc/nixos /etc/nixos/build.sh";
    };
    shellAliases = {
      ls = "eza";
    };
    plugins = [
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro;      
      }

      {
	name = "fzf";
	src = pkgs.fishPlugins.fzf-fish;
      }
    ];
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
