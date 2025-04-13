#!/usr/bin/env bash

## Welcome to Hyprnord-dots installer!
## -----------------------------------
## The script should work on most distros,
## but the dependency handling is only done
## for Arch-based distros. Please refer to the
## README for which deps. to install!

## Script. dir:
SRCDIR="$PWD"

## Links:
ICONSLINK="https://github.com/MolassesLover/Nordzy-icon/releases/download/1.8.7/Nordzy-dark.tar.gz"
HYPRCURSORLINK="https://github.com/guillaumeboehm/Nordzy-cursors/releases/download/v2.4.0/Nordzy-hyprcursors.tar.gz"
CURSORLINK="https://github.com/guillaumeboehm/Nordzy-cursors/releases/download/v2.4.0/Nordzy-cursors.tar.gz"
CASCLINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip"
RECLINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Recursive.zip"

## Fundamental deps. check
deps=(curl unzip tar)
for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        echo "$dep is missing; please install it before running the script" && exit 1
    fi
done

echo "Welcome to Hyprnord-dots installer!"

## Dependencies install on Arch Linux
if command -v pacman >/dev/null 2>&1; then
    echo "Arch-based distro detected, installing deps.."
    sudo pacman -Sy --noconfirm btop dunst fastfetch fish nwg-look hyprland kitty micro \
    rofi-wayland waybar grim slurp jq wl-clipboard libnotify
fi

echo "Creating backups at: $HOME/.config/hyprnord-bak"
mkdir -p "$HOME/.config/hyprnord-bak"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.local/share/icons"
mkdir -p "$HOME/.local/share/themes"

## Installing configs.
confs=(btop dunst fastfetch fish gtk-3.0 hypr kitty micro rofi waybar)
for conf in "${confs[@]}"; do

    # Copy original confs. if they exist
    if [ -d "$HOME/.config/$conf" ]; then
        cp -r "$HOME/.config/$conf" "$HOME/.config/hyprnord-bak"
    fi

    cp -rf "$SRCDIR/config/$conf" "$HOME/.config"
done

## Downloading fonts, icons, gtk theme etc.
echo "Config done, now installing themes/icons/fonts.."
mkdir -p "$SRCDIR/.tmp"
cd "$SRCDIR/.tmp" || (echo "The directory's missing, something went wrong.." && exit 1)

links=("$ICONSLINK" "$HYPRCURSORLINK" "$CURSORLINK" "$CASCLINK" "$RECLINK")
for link in "${links[@]}"; do
    echo "Downloading from: $link"
    curl -O "$link" || (echo "Download failed, please try again.." && rm -rf "$SRCDIR/.tmp" && exit 1)
done

echo "Installing fonts.."
mkdir -p "$HOME/.local/share/fonts/Recursive"
mkdir -p "$HOME/.local/share/fonts/CascadiaCode"
unzip -d "$HOME/.local/share/fonts/Recursive" -q "Recursive.zip"
unzip -d "$HOME/.local/share/fonts/CascadiaCode" -q "CascadiaCode.zip"

echo "Installing icons.."
tar -xf "Nordzy-cursors.tar.gz" -C "$HOME/.local/share/icons"
tar -xf "Nordzy-hyprcursors.tar.gz" -C "$HOME/.local/share/icons"
tar -xf "Nordzy-dark.tar.gz" -C "$HOME/.local/share/icons"

echo "Installing theme.."
tar -xf "$SRCDIR/local/share/themes/NordArc-Theme.tar.gz" -C "$HOME/.local/share/themes"

# shellcheck disable=SC2164
cd "$SRCDIR"

## Setting gtk-theme with nwg-look only if installed.
## Some distros might be missing it: you can follow 
## https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland if so.
if command -v nwg-look >/dev/null 2>&1; then
    nwg-look -x
fi

echo "Installer finished! Please reload to see the effects."
echo "Enjoy hyprnord! o/"
