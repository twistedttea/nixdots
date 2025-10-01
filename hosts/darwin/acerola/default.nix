{
  inputs,
  lib,
  ...
}:
let
in
{
  imports = [
    #
    # ========== Hardware ==========
    #
    # ./hardware-configuration.nix
    #inputs.hardware.nixosModules.common-cpu-amd
    #inputs.hardware.nixosModules.common-cpu-intel
    #inputs.hardware.nixosModules.common-gpu-nvidia
    #inputs.hardware.nixosModules.common-gpu-intel
    #inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    #inputs.disko.nixosModules.disko

    #
    # ========== Misc Inputs ==========
    #

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Non-Primary Users to Create ==========
      #

      #
      # ========== Optional Configs ==========
      #
      ./hosts/common/optional/emacs.nix
      ./hosts/common/optional/python.nix
      ./hosts/common/optional/mullvad.nix
      ./hosts/common/optional/vlc.nix
      ./hosts/darwin/optional/yabai.nix
      ./hosts/darwin/optional/skhd.nix
      ./
    ])
  ];

  #
  # ========== Host Specification ==========
  #

   hostSpec = {
     hostName = "acerola";
  #   useYubikey = lib.mkForce true;
  #   scaling = lib.mkForce "1";
   };

  # networking = {
  #   networkmanager.enable = true;
  #   enableIPv6 = false;
  # };

  # boot.loader = {
  #   systemd-boot = {
  #     enable = true;
  #   };
  #   efi.canTouchEfiVariables = true;
  #   timeout = 3;
  # };

  # boot.initrd = {
  #   systemd.enable = true;
  # };

  system.stateVersion = 6;
}
