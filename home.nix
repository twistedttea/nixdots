{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "petergrosskurth";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    kitty
    tealdeer
    adwaita-icon-theme
    fish
    graphviz
    imagemagick
    mermaid-cli
    yt-dlp
    mpv
    mu
    tree-sitter
    pandoc
    tree
    pass
    p7zip
    starship
    stow
    tmux
    zoxide
    zsh
    texlab
    texliveFull
    pyright
    ripgrep
    ghostty-bin
    pfetch
    eza
    neovim
    neomutt
    python313
    go
    nodejs
    jdk
    rustup
    docker
    dotnet-sdk
    git
    btop
    eza
    bat
    fd
    fzf
    aerc
    notmuch
    aria2
    ffmpeg
  ];

  programs.starship
  home.file = {
    # ".screenrc".source = dotfiles/screenrc;

    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/petergrosskurth/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
