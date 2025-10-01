# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
let
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = lib.flatten [
    inputs.home-manager.${platformModules}.home-manager
    #inputs.sops-nix.${platformModules}.sops
    #inputs.nix-index-database.${platformModules}.nix-index
    #{ programs.nix-index-database.comma.enable = true; }

    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/hosts/common"
      "modules/hosts/${platform}"

      "hosts/common/core/${platform}.nix"
      "hosts/common/core/keyd.nix"
      "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      "hosts/common/core/ssh.nix"

      "hosts/common/users/"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    primaryUsername = "grifter";
    username = "grifter";
    handle = "petergrosskurth";
    # inherit (inputs.nix-secrets)
    #   domain
    #   email
    #   userFullName
    #   networking
    #   ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = [ pkgs.openssh ];

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

  #
  # ========== Overlays ==========
  #
  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  #
  # ========== Basic Shell Enablement ==========
  #
  # On darwin it's important this is outside home-manager
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };
}
