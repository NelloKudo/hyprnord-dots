#!/usr/bin/env bash
# Rofi-based PowerMenu config by NelloKudo

# Power menu options with icons
shutdown="⏻  Shutdown"
reboot="  Reboot"
lock="  Lock"
suspend="⏾  Suspend"
logout="󰍃  Logout"
cancel="  Cancel"

# Rofi configuration
theme="$HOME/.config/rofi/config.rasi"
menu_title=" "

# Show menu and get selection
selected=$(printf "%s\n%s\n%s\n%s\n%s\n%s" \
    "$shutdown" \
    "$reboot" \
    "$lock" \
    "$suspend" \
    "$logout" \
    "$cancel" | rofi -dmenu -p "$menu_title" -theme "$theme")

# Handle selection
case "$selected" in
    "$shutdown")  systemctl poweroff ;;
    "$reboot")    systemctl reboot ;;
    "$lock")      hyprlock ;;
    "$suspend")   systemctl suspend ;;
    "$logout")    hyprctl dispatch exit ;;
    "$cancel"|*)  exit 0 ;;
esac