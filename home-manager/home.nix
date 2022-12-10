{ inputs, lib, config, pkgs, ... }:
let
    inherit (inputs.nix-colors) colorSchemes;
    inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme nixWallpaperFromScheme;
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
    fontSize = 13;
    fontSizeSmall = 12;
    terminalEmulator = "kitty";
in
{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
    inputs.hyprland.homeManagerModules.default

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
              mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
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
	
	# Programs
	cinnamon.nemo
	slurp
	grim
	sway-contrib.grimshot
	zathura
	libreoffice
	swaybg
	texlive.combined.scheme-full
  ];

  # Color scheme
  colorScheme = summercamp-desaturated;
  # Hyprland
  wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
      # Monitors
      monitor=eDP-1,2256x1504@60,0x0,1.3
      
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
      bind=SUPER,t,cyclenext
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
      exec-once=swaybg --color "##${config.colorScheme.colors.base00}"

      # animations
      animation=global,1,2,default

      general {
          border_size = 2
          col.inactive_border = rgba(${config.colorscheme.colors.base00}ff)
          col.active_border = rgba(${config.colorscheme.colors.base08}ff)
          gaps_in = 12
          gaps_out = 12
          cursor_inactive_timeout = 30
      }
      
      misc {
          disable_hyprland_logo = true
      }

      decoration {
	rounding = 12;
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
	modules-left = [ "wlr/workspaces" ];
	modules-right = [ "battery" "clock"];

	"wlr/workspaces" = {
    	  all-outputs = true;
    	  format = "{name}";
	};
      };
      style = ''
	* {
    	  border: none;
    	  border-radius: 0;
    	  font-family: Inter;
    	  font-size: ${toString fontSizeSmall}pt;
    	  background-color: #${config.colorScheme.colors.base00};
    	  color: #fff;
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
      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
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

          "prompt" = {
              enabled = false;
          };

          "entry" = {
              placeholder = "launch...";
          };

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
      package = gtkThemeFromScheme {
          scheme = config.colorScheme;
      };
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
  }

  # Vscode
  programs.vscode = {
      enable = true;
      extensions = [ pkgs.vscode-extensions.james-yu.latex-workshop ];
      userSettings = {
          "keyboard.dispatch" = "keyCode";
      };
  };

  # Kakoune (TODO fix colorscheme to use same as desktop)
  programs.kakoune = {
      enable = true;
      config = {
          colorScheme = "default";
          ui.assistant = "none";
          ui.enableMouse = true;
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
	hoed = "eval $EDITOR /etc/nixos/home-manager/home.nix; and env -C /etc/nixos/ /etc/nixos/build.sh";
	sysed = "eval $EDITOR /etc/nixos/nixos/configuration.nix; and env -C /etc/nixos /etc/nixos/build.sh";
      };
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
