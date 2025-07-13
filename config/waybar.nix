{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        output = "AOC U34G2G4R3 0x0000A6BB";
        layer = "top";
        position = "top";
        modules-left = [ "custom/launcher" "cpu" "memory" "hyprland/workspaces" "tray" ];
        modules-center = [ "clock" "custom/weather" ];
        modules-right = [ "pulseaudio" "network" "custom/power" ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          format = if clock24h == true then '' {:L%H:%M}'' else '' {:L%I:%M %p}'';
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 10;
          icon-size = 18;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/weather" = {
            "format" = "{}";
            "tooltip" = true;
            "interval" = 900;
            "exec" = "~/zaneyos/config/wttr.py";
            "return-type" = "json";
            };
        "custom/media" = {
            "interval" = 30;
            "format" = "{icon} {}";
            "return-type" = "json";
            "max-length" = 20;
            "format-icons" = {
                "spotify" = " ";
                "default" = "󰝚 ";
            };
            "escape" = true;
            "on-click" = "playerctl play-pause";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          # exec = "rofi -show drun";
          on-click = "sleep 0.1 && rofi-launcher";
        };
        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-hypr-bindings";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
      {
        output = "Lenovo Group Limited T24m-29 V90CP2GT";
        layer = "top";
        position = "top";
        modules-left = [];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
      }
    ];
    style = concatStrings [
      ''
        * {
             	border: none;
             	border-radius: 10;
              font-family: "JetbrainsMono Nerd Font" ;
             	font-size: 15px;
             	min-height: 10px;
                      }

                      window#waybar {
             	background: transparent;
                      }

                      window#waybar.hidden {
             	opacity: 0.2;
                      }

                      #window {
             	margin-top: 6px;
             	padding-left: 10px;
             	padding-right: 10px;
             	border-radius: 10px;
             	transition: none;
                          color: transparent;
             	background: transparent;
                      }
                      #tags {
             	margin-top: 6px;
             	margin-left: 12px;
             	font-size: 4px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	background: #161320;
             	transition: none;
                      }

                      #tags button {
             	transition: none;
             	color: #B5E8E0;
             	background: transparent;
             	font-size: 16px;
             	border-radius: 2px;
                      }

                      #tags button.occupied {
             	transition: none;
             	color: #F28FAD;
             	background: transparent;
             	font-size: 4px;
                      }

                      #tags button.focused {
             	color: #ABE9B3;
                          border-top: 2px solid #ABE9B3;
                          border-bottom: 2px solid #ABE9B3;
                      }

                      #tags button:hover {
             	transition: none;
             	box-shadow: inherit;
             	text-shadow: inherit;
             	color: #FAE3B0;
                          border-color: #E8A2AF;
                          color: #E8A2AF;
                      }

                      #tags button.focused:hover {
                          color: #E8A2AF;
                      }

                      #network {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #bd93f9;
                      }

                      #pulseaudio {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #1A1826;
             	background: #FAE3B0;
                      }

                      #battery {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #B5E8E0;
                      }

                      #battery.charging, #battery.plugged {
             	color: #161320;
                          background-color: #B5E8E0;
                      }

                      #battery.critical:not(.charging) {
                          background-color: #B5E8E0;
                          color: #161320;
                          animation-name: blink;
                          animation-duration: 0.5s;
                          animation-timing-function: linear;
                          animation-iteration-count: infinite;
                          animation-direction: alternate;
                      }

                      @keyframes blink {
                          to {
                              background-color: #BF616A;
                              color: #B5E8E0;
                          }
                      }

                      #backlight {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #F8BD96;
                      }

                      #clock {
                          padding-left: 16px;
                          padding-right: 16px;
                          border-radius: 10px 0px 0px 10px;
                          transition: none;
                          color: #ffffff;
                          background: #383c4a;
                      }

                      #custom-weather {
                          padding-right: 16px;
                          border-radius: 0px 10px 10px 0px;
                          transition: none;
                          color: #ffffff;
                          background: #383c4a;
                      }

                      #memory {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	margin-bottom: 0px;
             	padding-right: 10px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #DDB6F2;
                      }
                      #cpu {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	margin-bottom: 0px;
             	padding-right: 10px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #96CDFB;
                      }

                      #tray {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	margin-bottom: 0px;
             	padding-right: 10px;
             	border-radius: 10px;
             	transition: none;
             	color: #B5E8E0;
             	background: #161320;
                      }

                      #custom-launcher {
             	font-size: 24px;
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 5px;
             	border-radius: 10px;
             	transition: none;
                          color: #89DCEB;
                          background: #161320;
                      }

                      #custom-power {
             	font-size: 20px;
             	margin-top: 6px;
             	margin-left: 8px;
             	margin-right: 8px;
             	padding-left: 10px;
             	padding-right: 5px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #F28FAD;
                      }

                      #custom-updates {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #E8A2AF;
                      }

                      #custom-media {
             	margin-top: 6px;
             	margin-left: 8px;
             	padding-left: 10px;
             	padding-right: 10px;
             	margin-bottom: 0px;
             	border-radius: 10px;
             	transition: none;
             	color: #161320;
             	background: #F2CDCD;
                      }
      ''
    ];
  };
}
