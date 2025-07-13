{
  pkgs,
  username,
  host,
  inputs,
  lib,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
  hyprlock-blur = pkgs.writeShellScriptBin "hyprlock-blur" ''
      grim -o DP-8 -l 0 /tmp/screenshot1.png &
      grim -o DP-4 -l 0 /tmp/screenshot2.png &
      wait &&
      hyprlock
    '';
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/fastfetch
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
    ../../config/fastfetch
    # ../../config/hyprpanel.nix
    #inputs.ghostty-hm.homeModules.default
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
  # Error: cannot find the source dir?b
  #home.file.".config/xfce4" = {
  #  source = ../../config/xfce;
  #  recursive = true;
  #};

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
  stylix.targets.hyprlock.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    # style.name = "adwaita-dark";
    # platformTheme.name = "gtk3";
  };


  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
    hyprlock-blur
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock-blur";
          };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock-blur";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            monitor = "AOC U34G2G4R3 0x0000A6BB";
            path = "/tmp/screenshot1.png";
            blur_passes = 2; # 0 disables blurring
            blur_size = 7;
            noise = 1.17e-2;
          }
          {
            monitor = "Lenovo Group Limited T24m-29 V90CP2GT";
            path = "/tmp/screenshot2.png";
            blur_passes = 2; # 0 disables blurring
            blur_size = 7;
            noise = 1.17e-2;
          }
        ];
        label = [
          {
            monitor = "AOC U34G2G4R3 0x0000A6BB";
            text = "$TIME";
            color = "a9b1d6";
            font_size = 95;
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "AOC U34G2G4R3 0x0000A6BB";
            text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
            color = "a9b1d6";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = {
          monitor = "AOC U34G2G4R3 0x0000A6BB";
          size = "200,50";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "a9b1d6";
          inner_color = "a9b1d6";
          font_color = "1a1b26";
          fade_on_empty = false;
          rounding = -1;
          check_color = "393552";
          placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
          hide_input = false;
          position = "0, -100";
          halign = "center";
          valign = "center";
        };
      };
    };
    # hypridle.enable = true;
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = false;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
     starship = {
            enable = true;
            package = pkgs.starship;
     };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/zaneyos";
        fu = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
        zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
      };
    };
    #ghostty = {
    #  enable = true;
    #  settings = {
    #    theme = "tokyonight";
    #    background-opacity = 0.2;
    #    background-blur-radius = 0;
    #  };
    #};
  };
}
