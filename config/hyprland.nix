{
  lib,
  username,
  host,
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # pkgs.hyprlandPlugins.hyprtrails
      # pkgs.hyprlandPlugins.hyprexpo
    ];
    extraConfig =
      let
        modifier = "SUPER";
        mainMod = "SUPER";
      in
      concatStrings [
        ''
          env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1
          exec-once = dbus-update-activation-environment --systemd --all
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = killall -q waybar;sleep .5 && waybar
          # exec-once = hyprpanel
          exec-once = killall -q swww-daemon;sleep .5 && swww-daemon
          #exec-once = killall -q swaync;sleep .5 && swaync
          exec-once = nm-applet --indicator
          exec-once = lxqt-policykit-agent
          exec-once = sleep 1.5 && swww img /home/${username}/Pictures/live_wallpapers/contours.png
          exec-once = mailspring --password-store="gnome-libsecret" %U --background
          monitor=desc:Lenovo Group Limited T24m-29 V90CP2GT,1920x1080@60.0,840x0,1.0
          monitor=desc:Lenovo Group Limited T24m-29 V90CP2GT,transform,1
          monitor=desc:AOC U34G2G4R3 0x0000A6BB,3440x1440@99.98,1920x105,1.0
          general {
            border_size = 3
            no_border_on_floating = false
            gaps_in = 2
            gaps_out = 2
            col.active_border = rgba(8ccf7edd) rgba(8ccf7edd) 45deg
            col.inactive_border = rgba(232a2dee)
            layout = dwindle
            extend_border_grab_area = true
            hover_icon_on_border = true
          }
          input {
            kb_layout = gb
            kb_options = grp:alt_shift_toggle
            kb_options = caps:super
            follow_mouse = 1
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }
          # windowrule = noborder, ^(wofi)$
          # windowrule = center, ^(wofi)$
          # windowrule = center, ^(steam)$
          windowrulev2 = float, class:^(nm-connection-editor)$
          windowrulev2 = float, title:^(blueman-manager)$
          # windowrule = float, swayimg|vlc|Viewnior|pavucontrol
          # windowrule = float, nwg-look|qt5ct|mpv
          # windowrule = float, zoom
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
          windowrulev2 = opacity 0.9 0.7, class:^(thunar)$

          windowrulev2 = suppressevent [activatefocus], class:^(OrcaSlicer)$

          debug {
            disable_logs=false
            enable_stdout_logs = true
          }

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }
          misc {
            initial_workspace_tracking = 0
            disable_hyprland_logo = true
            disable_splash_rendering = true
            vrr = 0
            mouse_move_enables_dpms = true
            key_press_enables_dpms = true
            layers_hog_keyboard_focus = true
            focus_on_activate = true
            mouse_move_focuses_monitor = true
          }
          animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
          }
          decoration {
            rounding = 5
            #drop_shadow = true
            #shadow_range = 4
            #shadow_render_power = 3
            #col.shadow = rgba(1a1a1aee)
            blur {
                enabled = true
                size = 5
                passes = 3
                new_optimizations = on
                ignore_opacity = off
            }
          }
          plugin {
            hyprtrails {
              color = rgb(229, 199, 107)
            }
          }
          plugin {
            hyprexpo {
              columns = 2
              gap_size = 5
              bg_col = rgba(232a2dee)
              workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

              enable_gesture = true # laptop touchpad
              gesture_fingers = 3  # 3 or 4
              gesture_distance = 300 # how far is the "max"
              gesture_positive = true # positive = swipe down. Negative = swipe up.
            }
          }
          dwindle {
            pseudotile = true
            preserve_split = true
          }
          windowrulev2 = float,class:(qalculate-gtk)
          windowrulev2 = workspace special:calculator,class:(qalculate-gtk)
          bind = ${modifier}SHIFT, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &

          windowrulev2 = float,class:(wasistlos)
          windowrulev2 = workspace special:whatsapp,class:(wasistlos)
          bind = ${modifier}SHIFT, W, exec, pgrep wasistlos && hyprctl dispatch togglespecialworkspace whatsapp || wasistlos &

          # bind = SUPER, escape, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enable
          bind = ${modifier},Return,exec,${terminal}
          bind = ${modifier},F1,exec,rofi-launcher
          # bind = ${modifier}SHIFT,W,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier},C,exec,${browser}
          bind = ${modifier},E,exec,geany
          bind = ${modifier},S,exec,screenshootin
          bind = ${modifier}SHIFT,G,exec,godot4
          bind = ${modifier},F,exec,thunar
          bind = ${modifier},M,exec,spotify
          bind = ${modifier},Q,killactive,
          bindr= ${modifier}CONTROL, R, exec, pkill waybar && waybar
          bind = ${modifier}SHIFT, C, exec, hyprctl reload      # reload Hyprland
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,I,togglesplit,
          bind = ${modifier}CONTROL,F,fullscreen,
          bind = ${modifier}SHIFT,F,togglefloating,
          bind = ${modifier}, I, pin
          bind = ${modifier},X,exec, wlogout
          bind = ${modifier}, L, exec, hyprlock-blur
          bind = ${modifier} SHIFT, B, movetoworkspace, special
          bind = ${modifier}, B, togglespecialworkspace
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          # bind = ${modifier},h,movefocus,l
          # bind = ${modifier},l,movefocus,r
          # bind = ${modifier},k,movefocus,u
          # bind = ${modifier},j,movefocus,d
          bind = ${modifier},1,workspace,1
          bind = ${modifier},2,workspace,2
          bind = ${modifier},3,workspace,3
          bind = ${modifier},4,workspace,4
          bind = ${modifier},5,workspace,5
          bind = ${modifier},6,workspace,6
          bind = ${modifier},7,workspace,7
          bind = ${modifier},8,workspace,8
          bind = ${modifier},9,workspace,9
          bind = ${modifier},0,workspace,10
          bind = ${modifier}SHIFT,1,movetoworkspace,1
          bind = ${modifier}SHIFT,2,movetoworkspace,2
          bind = ${modifier}SHIFT,3,movetoworkspace,3
          bind = ${modifier}SHIFT,4,movetoworkspace,4
          bind = ${modifier}SHIFT,5,movetoworkspace,5
          bind = ${modifier}SHIFT,6,movetoworkspace,6
          bind = ${modifier}SHIFT,7,movetoworkspace,7
          bind = ${modifier}SHIFT,8,movetoworkspace,8
          bind = ${modifier}SHIFT,9,movetoworkspace,9
          bind = ${modifier}SHIFT,0,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
        ''
      ];
  };
}
