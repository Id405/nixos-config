{ inputs, lib, config, pkgs, ... }: {
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
  programs.kakoune.enable = true;
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
	firefox
	cinnamon.nemo
  ];

  # Color scheme
  colorScheme = {
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

  # Hyprland
  wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
      # Programs
      bind=SUPER,Return,exec,alacritty
      bind=SUPER,Space,exec,rofi -show run -show-icons -icon-theme yaru

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

      # animations
      animation=global,1,2,default

      general {
          border_size = 0
      }
      
      misc {
          disable_hyprland_logo = true
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
              font = "Inter 14";
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

  # Alacritty
  programs.alacritty = {
      enable = true;
      settings.font = {
        size = 14;
	normal = {
    		family = "Fira Code";
    		style = "Regular";
	};
	bold = {
    		family = "Fira Code";
    		style = "Bold";
	};
	italic = {
    		family = "Fira Code";
    		style = "Italic";
	};
      };
  };

  # Gtk
  gtk = {
      enable = true;
      font = {
          name = "Inter";
          size = 14;
      };
      iconTheme = {
          package = pkgs.yaru-theme;
          name = "yaru";
      };
  };

  # Gtk
  gtk.theme = let lib-contrib = inputs.nix-colors.lib-contrib {inherit pkgs; }; in {
      name = "${config.colorScheme.slug}";
      package = lib-contrib.gtkThemeFromScheme {
          scheme = config.colorScheme;
      };
  };


  # Better command not found
  programs.command-not-found.enable = false;
  programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
  };

  # Fish  
  programs.fish = {
      enable = true;
      loginShellInit = ''
	if test (tty) = "/dev/tty1"
	  exec Hyprland &> /dev/null
	end
      '';
      functions = {
	hoed = "eval $EDITOR /etc/nixos/home-manager/home.nix; and env -C /etc/nixos/ /etc/nixos/build.sh";
	sysed = "eval $EDITOR /etc/nixos/nixos/configuration.nix; and env -C /etc/nixos /etc/nixos/build.sh";
      };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
