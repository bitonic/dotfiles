#!/bin/bash

session_manager=
swapcaps=
trackpoint_scroll=yes
xflux=
xscreensaver=
dell_profile=yes
gnome=yes
xfce=
menu_rctrl=
altgr_alt=
altgr_super=
nobeep=yes
trackpoint_accel=yes
redshift=

case "$session_manager" in
    gnome)
        gnome-session-manager &
        ;;
    xfce)
        xfsettingsd &
        xfce4-power-manager &
        ;;
esac

if [ -n "$trackpoint_scroll" ]; then
    device="DualPoint Stick"
    xinput set-int-prop "$device" "Evdev Wheel Emulation" 8 1
    xinput set-int-prop "$device" "Evdev Wheel Emulation Button" 8 2
    xinput set-int-prop "$device" "Evdev Wheel Emulation Axes" 8 6 7 4 5
fi

if [ -n "$xflux" ]; then
    xflux -l 51.493088 -g -0.222805
fi

if [ -n "$swapcaps" ]; then
    setxkbmap -option ctrl:swapcaps
fi

if [ -n "$xscreensaver" ]; then
    xscreensaver -no-splash &
fi

if [ -n "$dell_profile" ]; then
    xcalib `dirname $0`/dellE6410nv.icc
fi

if [ -n "$gnome" ]; then
    gnome-settings-daemon &
    /usr/lib/notification-daemon/notification-daemon &
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

    # gnome-keyring-daemon --daemonize --login --components=gpg,pkcs11,secrets,ssh &
    gnome-keyring-daemon --daemonize --login &
    export SSH_AUTH_SOCK
    export GPG_AGENT_INFO
    export GNOME_KEYRING_CONTROL
    export GNOME_KEYRING_PID

    start-pulseaudio-x11

    gnome-sound-applet &
    nm-applet &
    # bluetooth-applet &

    /usr/lib/at-spi2-core/at-spi-bus-launcher --launch-immediately &

    gnome-screensaver &

    /usr/lib/gnome-settings-daemon/gnome-fallback-mount-helper &
    # /usr/lib/gnome-disk-utility/gdu-notification-daemon &
fi

if [ -n "$xfce" ]; then
    xfce4-settings-helper &
    xfce4-power-manager &
fi

if [ -n "$menu_rctrl" ]; then
    setxkbmap -option ctrl:menu_rctrl
fi

if [ -n "$altgr_alt" ]; then
    xmodmap -e "keycode 108 = Alt_R"
fi

if [ -n "$altgr_super" ]; then
    xmodmap -e "keycode 108 = Super_R"
fi

if [ -n "$nobeep" ]; then
    xset b off
fi

if [ -n "$trackpoint_accel" ]; then
    xinput set-prop "DualPoint Stick" "Device Accel Profile" 6
    xinput set-prop "DualPoint Stick" "Device Accel Constant Deceleration" 2
fi

if [ -n "$redshift" ]; then
    redshift -l 51.5171:0.1062 -m randr &
fi