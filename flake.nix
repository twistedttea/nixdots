# TODO: Do I need to add a central configuration file that i import this flake into on nix-darwin?

{
  description = "Current Nix declaritive configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    Home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # TODO: add home manager

  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.environment.systemPackages = with pkgs; [
            nixfmt-rfc-style
            nixd
            gcc
            cmake
            git
            curl
            wget
            fzf
            coreutilS
            automake
            libtool
            pkg-config
            mesa
            autoconf
            automake

          ];
          nix.settings.experimental-features = "nix-command flakes";
          nix.enable = false;
          nix.System.primaryUser = "petergrosskurth";
          security.pam.services.sudo_local.touchIdAuth = true;
          programs.fish.enable = true;
          users.users.petergrosskurth = {
            # TODO: this is not setting my login shell, need to fix that
            home = "/Users/petergrosskurth";
            shell = pkgs.fish;
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Stable or unstable ?
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {

      # Build darwin flake using:
      # $ sudo darwin-rebuild build --flake ~/.dotfiles-nix/.#Acerola
      darwinConfigurations = {
        "Acerola" = nix-darwin.lib.darwinSystem {

          modules = [
            configuration
            ./darwin/yabai.nix
            ./darwin/skhd.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.petergrosskurth = import ./home.nix;
            }

            {

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
            }
          ];
        };
      };
    };
}
