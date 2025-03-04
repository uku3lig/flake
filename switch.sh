#!/usr/bin/env bash
set -euo pipefail

bold=$(tput bold)
reset=$(tput sgr0)

flake="$1"

echo "${bold}Building configuration...$reset"
configuration=$(sudo nixos-rebuild dry-activate --flake "$flake" --keep-going "${@:2}")
echo "$configuration"

nix run "$flake#nixosConfigurations.$(hostname).pkgs.nvd" -- diff /run/current-system "$configuration"

read -n1 -rp "${bold}Activate new configuration? [y/N]$reset " answer
echo

if [[ $answer =~ ^[Yy]$ ]]; then
  sudo "$configuration/bin/switch-to-configuration" switch
else
  echo "${bold}Not activating :($reset"
  exit 1
fi
