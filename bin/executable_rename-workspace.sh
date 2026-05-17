#!/bin/bash

NUM=$(i3-msg -t get_workspaces | jq -r ".[] | select(.focused) | .num")
NAME=$(rofi -dmenu -p "New name:" -lines 0)
[ -z "$NAME" ] && exit 0

# Substitute known names with Nerd Font icons
case "$NAME" in
  code) NAME=$'\U000F0A1E ' ;;
  kernel) NAME=$'\UF31A ' ;;
  project) NAME=$'\Uefce ' ;;
  *) NAME=" $NAME" ;;
esac

i3-msg "rename workspace to \"$NUM:$NAME\""
