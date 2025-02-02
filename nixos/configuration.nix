{ config, pkgs, lib, inputs, ... }:
let
  sources = import ./nix/sources.nix;
  lanzaboote = import inputs.lanzaboote;
in
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./packages.nix
      ./services.nix
      ./network.nix
      lanzaboote.nixosModules.lanzaboote
    ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Set your time zone.
  time.timeZone = "America/Anchorage";

  # Set nix Version
  system.stateVersion = "unstable";

  # Allow Unfree Software
  nixpkgs.config.allowUnfree = true;

}

