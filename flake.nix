
# TODO: Do I need to add a central configuration file that i import this flake into on nix-darwin?

{
  description = "Current Nix declaritive configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # TODO: add home manager
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      ...
    }:

    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;
          # TODO: please move this into subfiles, organize by dependencies or type when possible
          environment.systemPackages = [
            pkgs.nixfmt-rfc-style
            pkgs.nixd
            pkgs.kitty
            pkgs.libpng
            pkgs.glib
            pkgs.cairo
            pkgs.harfbuzz
            pkgs.pango
            pkgs.librsvg
            pkgs.adwaita-icon-theme
            pkgs.cacert
            pkgs.openssl
            pkgs.libevent
            pkgs.nghttp2
            pkgs.gnutls
            pkgs.gnupg
            pkgs.gpgme
            pkgs.gmime
            pkgs.notmuch
            pkgs.aerc
            pkgs.antigen
            pkgs.brotli
            pkgs.libavif
            pkgs.apr
            pkgs.aprutil
            pkgs.aria2
            pkgs.aribb24
            pkgs.aspell
            pkgs.dbus
            pkgs.at-spi2-core
            pkgs.autoconf
            pkgs.automake
            pkgs.ncurses
            pkgs.bat
            pkgs.db
            pkgs.biber
            pkgs.c-ares
            pkgs.libretls
            pkgs.gcc
            pkgs.pmix
            pkgs.openmpi
            pkgs.cava
            pkgs.python313Packages.certifi
            pkgs.cjson
            pkgs.clisp
            pkgs.cmake
            pkgs.cocoapods
            pkgs.coreutils
            pkgs.curl
            pkgs.dav1d
            pkgs.emacs
            pkgs.desktop-file-utils
            pkgs.docker
            pkgs.docker-compose
            pkgs.dotnet-sdk
            pkgs.eza
            pkgs.fd
            pkgs.libass
            pkgs.tesseract
            pkgs.ffmpeg
            pkgs.ffmpegthumbnailer
            pkgs.figlet
            pkgs.fish
            pkgs.fzf
            pkgs.gawk
            pkgs.gd
            pkgs.gh
            pkgs.git
            pkgs.gnused
            pkgs.gnutar
            pkgs.go
            pkgs.graphviz
            pkgs.gnugrep
            pkgs.gsettings-desktop-schemas
            pkgs.gtk3
            pkgs.htop
            pkgs.libheif
            pkgs.python313
            pkgs.imagemagick
            pkgs.ispell
            pkgs.isync
            pkgs.lazygit
            pkgs.lf
            pkgs.libgccjit
            pkgs.postgresql
            pkgs.pkg-config
            pkgs.librsync
            pkgs.lua
            pkgs.luarocks
            pkgs.nodejs
            pkgs.mermaid-cli
            pkgs.meson
            pkgs.vapoursynth
            pkgs.yt-dlp
            pkgs.mpv
            pkgs.msmtp
            pkgs.mu
            pkgs.neomutt
            pkgs.tree-sitter
            pkgs.neovim
            pkgs.jdk
            pkgs.pandoc
            pkgs.tree
            pkgs.pass
            pkgs.pfetch
            pkgs.eza
            pkgs.php
            pkgs.poppler
            pkgs.python313Packages.pygments
            pkgs.ripgrep
            pkgs.rustup
            pkgs.p7zip
            pkgs.slides
            pkgs.sphinx
            pkgs.starship
            pkgs.stow
            pkgs.swiftformat
            # pkgs.syncthing
            pkgs.texlab
            pkgs.texliveFull
            pkgs.tmux
            pkgs.virtualenv
            pkgs.wget
            pkgs.wimlib
            pkgs.zlib
            pkgs.zoxide
            pkgs.zsh

          ];

          nix.settings.experimental-features = "nix-command flakes";
          nix.enable = false;
          system.primaryUser = "petergrosskurth";

          security.pam.services.sudo_local.touchIdAuth = true;
          programs.fish.enable = true;
          users.users.petergrosskurth = {
            # TODO: this is not setting my login shell, need to fix that
            shell = pkgs.fish;
          };
          # services.dbus.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    
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
                name ="syncthing";
                start_service = true;
                }

              ];

            };

          }
        ];
      };
    };
}
