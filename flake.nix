
{
  description = "Current Nix declaritive configuration";
  outputs =
      {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:

    let
      inherit( self ) outputs;

      # ========= Architectures ========= #
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # ========= Overlays ========= # 
      # Custom modifications/overrides to upstream packages
      # overlays = import ./overlays { inherit inputs; };

      # nixosConfigurations = builtins.listToAttrs (
      #   map (host: {
      #     name = host;
      #     value = nixpkgs.lib.nixosSystem {
      #       specialArgs = {
      #         inherit inputs outputs lib;
      #         isDarwin = false;
      #       };
      #       modules = [ ./hosts/nixos/${host} ];
      #     };
      #   }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      # );

      darwinConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs outputs lib;
              isDarwin = true;
            };
            modules = [ ./hosts/darwin/${host} ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/darwin))
      );

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget

        # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management
        devShells = forAllSystems (
          system:
          import ./shell.nix {
            pkgs = nixpkgs.legacyPackages.${system};
            checks = self.checks.${system};
          }
        );
          nix.settings.experimental-features = "nix-command flakes";
          nix.enable = false;
          system.primaryUser = "petergrosskurth";

          security.pam.services.sudo_local.touchIdAuth = true;
          programs.fish.enable = true;
          users.users.petergrosskurth = {
            # TODO: this is not setting my login shell, need to fix that
            shell = pkgs.fish;
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

         # nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ sudo darwin-rebuild build --flake .#Peters-Mac
      darwinConfigurations."Acerola" = nix-darwin.lib.darwinSystem {

        modules = [
          configuration
          ./darwin/yabai.nix
          ./darwin/skhd.nix
          {
            homebrew = {
              enable = true;

              taps = [
                "cmacrae/formulae"
                "felixkratz/formulae"
                "homebrew/autoupdate"
                "koekeishiya/formulae"
                "nikitabobko/tap"
                "romkatv/powerlevel10k"
                "zegervdv/zathura"

              ];

              brews = [
                "berkeley-db@5"
                "libretls"
                "cocoapods"
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
            };
          }
        ];
      };
    };
}

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix/release-25.05";
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # sops-nix = {
    #   url = "github:mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-secrets = {
    #   url = "git+ssh://git@gitlab.com/emergentmind/nix-s*crets.git?ref=main&shallow=1";
    #   inputs = { };
    # };
  };
