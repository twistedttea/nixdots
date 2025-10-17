{
  inputs,
  lib,
  ...
}:
let
in

  imports = [
    #
    # ========== hardware ==========
    #
    #
    #./hardware-configuration.nix
    #inputs.hardware.nixosmodules.common-cpu-amd
    #inputs.hardware.nixosmodules.common-cpu-intel
    #inputs.hardware.nixosmodules.common-gpu-nvidia
    #inputs.hardware.nixosmodules.common-gpu-intel
    #inputs.hardware.nixosmodules.common-pc-ssd

    #
    # ========== disk layout ==========
    #
    #inputs.disko.nixosmodules.disko

    #
    # ========== misc inputs ==========
    #

    (map lib.custom.relativetoroot [
      #
      # ========== required configs ==========
      #
      "hosts/common/core"

      #
      # ========== non-primary users to create ==========
      #

      #
      # ========== optional configs ==========
      #
    ])
  ];

  #
  # ========== host specification ==========
  #

            configuration
            # ./darwin/yabai.nix
            # ./darwin/skhd.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.petergrosskurth = import ./home.nix;
            }

              homebrew = {
                enable = true;
                # Cleanup any non-declarative packages.
                # onActivation.cleanup = "zap";

                taps = [
                  "cmacrae/formulae"
                  "felixkratz/formulae"
                  "homebrew/autoupdate"
                  "koekeishiya/formulae"
                  "nikitabobko/tap"
                  "d12frosted/emacs-plus"
                  "romkatv/powerlevel10k"
                  "zegervdv/zathura"

                ];

                brews = [
                  "berkeley-db@5"
                  "libretls"
                  "cocoapods"
                  {
                    name = "emacs-plus@31";
                    link = true;
                  }
                  "docker-completion"
                  "Gtk-mac-integration"
                  "reattach-to-user-namespace"
                  "terminal-notifier"
                  "xdg-ninja"
                  {
                    name = "syncthing";
                    start_service = true;
                  }
                ];

                casks = [
                  "colemak-dh"
                ];
              };
  # hostSpec = {
  #   hostName = "foo";
  #   useYubikey = lib.mkForce true;
  #   scaling = lib.mkForce "1";
  # };

  #https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
