{ inputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  nixWallpaperFromScheme = import ./wallpaperclean.nix { inherit pkgs; };
  nixWallpaperFromSchemeDetailed = import ./wallpaper.nix { inherit pkgs; };
  summercamp-desaturated = {
    name = "Summercamp Desaturated";
    slug = "summercamp-desaturated";
    author = "zoe firi (modified by Id405";
    colors = {
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
  terminalEmulator = "kitty";
in {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule

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
      (final: prev: {
        waybar = prev.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
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
    username = "lily";
    homeDirectory = "/home/lily";
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
    eza
    nixfmt
    rustup
    libqalculate
    killall
    yt-dlp

    # gui
    pavucontrol
    spotify
    cinnamon.nemo
    slurp
    grim
    sway-contrib.grimshot
    libreoffice
    swww
    texlive.combined.scheme-full
    inkscape
    blueberry
    blender
    gimp
    libreoffice
    musescore

    # Audio Production
    reaper
    vital
    helm
    lsp-plugins
    yabridge
    yabridgectl
    mooSpace
    dragonfly-reverb
    hybridreverb2
    aether-lv2

    # wine
    winetricks
    wineWowPackages.waylandFull
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
              bindm=SUPER,mouse:273,movewindow

              # status bar
              exec-once="waybar"

              # wallpaper
              exec-once=bash -c "swww init && sleep 0.1 && swww img --transition-type wipe --transition-angle 170 --transition-duration 3 ${
                nixWallpaperFromSchemeDetailed {
                  scheme = config.colorscheme;
                  width = 2256;
                  height = 1504;
                  logoScale = 5.0;
                  fontName = "Inter";
                  versionText = inputs.nixpkgs.lib.version;
                }
              } && sleep 10 && swww img --transition-type wipe --transition-angle 30 ${
                nixWallpaperFromScheme {
                  scheme = config.colorscheme;
                  width = 2256;
                  height = 1504;
                  logoScale = 5.0;
                  fontName = "Inter";
                  versionText = inputs.nixpkgs.lib.version;
                }
              }"

              # animations
              animation=global,1,2,default

              general {
                border_size = 0
                col.inactive_border = rgba(${config.colorscheme.colors.base00}ff)
                col.active_border = rgba(${config.colorscheme.colors.base08}ff)
                gaps_in = 12
                gaps_out = 12
                cursor_inactive_timeout = 30
              }
                    
              misc {
                disable_hyprland_logo = true
                enable_swallow = true
                swallow_regex = '^(kitty)$'
              }

              decoration {
                rounding = 12
              }

              gestures {
                workspace_swipe = true
                workspace_swipe_invert = false
              }

              input {
                kb_layout = us
                kb_variant = colemak

                touchpad {
                  disable_while_typing=false
                }
              }
    '';
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "battery" "clock" ];

      "hyprland/workspaces" = {
        all-outputs = true;
        format = "{name}";
      };

      "clock" = { format = "{:%I:%M %p}"; };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: Inter;
        font-size: ${toString fontSizeSmall}pt;
        background-color: #${config.colorScheme.colors.base00};
        color: #fff;
        padding-left: 5px;
        padding-right: 5px;
      }

      #workspaces button.active {
        color: #fff;
      }
    '';
  };

  # rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#${config.colorScheme.colors.base00}";
        foreground-color = mkLiteral "#${config.colorScheme.colors.base07}";
        text-color = mkLiteral "#${config.colorScheme.colors.base07}";
        font = "Inter ${toString fontSize}";
        border-radius = mkLiteral "0.25em";
      };

      "element-text" = {
        vertical-align = mkLiteral "0.5";
        background-color = mkLiteral "inherit";
      };

      "window" = {
        fullscreen = true;
        padding = mkLiteral "1em 75% 1em 1em";
      };

      "prompt" = { enabled = false; };

      "entry" = { placeholder = "launch..."; };

      "selected" = {
        background-color = mkLiteral "#${config.colorScheme.colors.base08}";
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

  # Fonts
  fonts.fontconfig.enable = true;

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      size = fontSize;
    };

    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 12;
      foreground = "#${config.colorScheme.colors.base05}";
      background = "#${config.colorScheme.colors.base00}";
      selection_background = "#${config.colorScheme.colors.base08}";
      selection_foreground = "#${config.colorScheme.colors.base00}";
      url_color = "#${config.colorScheme.colors.base0D}";
      cursor = "#${config.colorScheme.colors.base07}";
      color0 = "#${config.colorScheme.colors.base00}";
      color1 = "#${config.colorScheme.colors.base08}";
      color2 = "#${config.colorScheme.colors.base0B}";
      color3 = "#${config.colorScheme.colors.base0A}";
      color4 = "#${config.colorScheme.colors.base0D}";
      color5 = "#${config.colorScheme.colors.base0E}";
      color6 = "#${config.colorScheme.colors.base0C}";
      color7 = "#${config.colorScheme.colors.base05}";
      color8 = "#${config.colorScheme.colors.base03}";
      color9 = "#${config.colorScheme.colors.base08}";
      color10 = "#${config.colorScheme.colors.base0B}";
      color11 = "#${config.colorScheme.colors.base0A}";
      color12 = "#${config.colorScheme.colors.base0D}";
      color13 = "#${config.colorScheme.colors.base0E}";
      color14 = "#${config.colorScheme.colors.base0C}";
      color15 = "#${config.colorScheme.colors.base07}";
      color16 = "#${config.colorScheme.colors.base09}";
      color17 = "#${config.colorScheme.colors.base0F}";
      color18 = "#${config.colorScheme.colors.base01}";
      color19 = "#${config.colorScheme.colors.base02}";
      color20 = "#${config.colorScheme.colors.base04}";
      color21 = "#${config.colorScheme.colors.base06}";
      linux_display_server = "wayland";
    };
  };

  # Gtk
  gtk = {
    enable = true;
    font = {
      name = "Inter";
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
        colors = config.colorScheme.colors;
        fontSize = fontSize;
        fontSizeSmall = fontSizeSmall;
      };
      userContent = import ./firefox/userContent.nix {
        colors = config.colorScheme.colors;
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  # Discocss
  programs.discocss = {
    enable = true;
    css = ''
      .theme-dark {
        --saturation-factor: 0;
        --background-primary: ${config.colorScheme.colors.base00};
        --background-primary-alt: ${config.colorScheme.colors.base01};
        --background-secondary: ${config.colorScheme.colors.base00};
        --background-secondary-alt: ${config.colorScheme.colors.base01};
      }
    '';
  };

  # Zathura
  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#${config.colorScheme.colors.base00}";
      default-fg = "#${config.colorScheme.colors.base07}";
      inputbar-bg = "#${config.colorScheme.colors.base00}";
      inputbar-fg = "#${config.colorScheme.colors.base07}";
      statusbar-bg = "#${config.colorScheme.colors.base00}";
      statusbar-fg = "#${config.colorScheme.colors.base07}";
      recolor-lightcolor = "#${config.colorScheme.colors.base00}";
      recolor-darkcolor = "#${config.colorScheme.colors.base07}";
      recolor = true;
      guioptions = "none";
    };
  };

  # Vscode
  programs.vscode = {
    enable = true;
    extensions = [ pkgs.vscode-extensions.james-yu.latex-workshop ];
    userSettings = {
      "keyboard.dispatch" = "keyCode";
      "window.menuBarVisibility" = "hidden";
    };
  };

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

  # Helix
  programs.helix = {
    enable = true;
    settings = { theme = "system"; };
    themes = {
      system = let
        transparent = "none";
        gray = "#${config.colorScheme.colors.base05}";
        dark-gray = "#${config.colorScheme.colors.base00}";
        white = "#${config.colorScheme.colors.base07}";
        black = "#${config.colorScheme.colors.base00}";
        red = "#${config.colorScheme.colors.base08}";
        green = "#${config.colorScheme.colors.base0B}";
        yellow = "#${config.colorScheme.colors.base0A}";
        orange = "#${config.colorScheme.colors.base09}";
        blue = "#${config.colorScheme.colors.base0D}";
        magenta = "#${config.colorScheme.colors.base0E}";
        cyan = "#${config.colorScheme.colors.base0C}";
      in {
        "ui.menu" = transparent;
        "ui.menu.selected" = { modifiers = [ "reversed" ]; };
        "ui.linenr" = {
          fg = gray;
          bg = dark-gray;
        };
        "ui.popup" = { modifiers = [ "reversed" ]; };
        "ui.linenr.selected" = {
          fg = white;
          bg = black;
          modifiers = [ "bold" ];
        };
        "ui.selection" = {
          fg = black;
          bg = blue;
        };
        "ui.selection.primary" = { modifiers = [ "reversed" ]; };
        "comment" = { fg = gray; };
        "ui.statusline" = {
          fg = white;
          bg = dark-gray;
        };
        "ui.statusline.inactive" = {
          fg = dark-gray;
          bg = white;
        };
        "ui.help" = {
          fg = dark-gray;
          bg = white;
        };
        "ui.cursor" = { modifiers = [ "reversed" ]; };
        "variable" = red;
        "variable.builtin" = orange;
        "constant.numeric" = orange;
        "constant" = orange;
        "attributes" = yellow;
        "type" = yellow;
        "ui.cursor.match" = {
          fg = yellow;
          modifiers = [ "underlined" ];
        };
        "string" = green;
        "variable.other.member" = red;
        "constant.character.escape" = cyan;
        "function" = blue;
        "constructor" = blue;
        "special" = blue;
        "keyword" = magenta;
        "label" = magenta;
        "namespace" = blue;
        "diff.plus" = green;
        "diff.delta" = yellow;
        "diff.minus" = red;
        "diagnostic" = { modifiers = [ "underlined" ]; };
        "ui.gutter" = { bg = black; };
        "info" = blue;
        "hint" = dark-gray;
        "debug" = dark-gray;
        "warning" = yellow;
        "error" = red;
      };
    };
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
    shellAliases = { ls = "eza"; };
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
