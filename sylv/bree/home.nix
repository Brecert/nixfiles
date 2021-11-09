{ config, pkgs, ... }: {

  imports = [
    ./config.nix
    ./packages.nix
    ./programs.nix
  ];

  home = {
    username = "bree";
    homeDirectory = "/home/bree";

    # link in the manpages and documentation outputs from installed packages
    # temporarily disabled due to increasing build time by a bit without providing much benefit
    # extraOutputsToInstall = [ "man" "doc" ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
