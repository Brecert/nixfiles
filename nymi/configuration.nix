{ nixpkgs, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_0;

  hardware.bluetooth.enable = true;

  networking.hostName = "nymi";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp42s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Enable .local
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.libinput.mouse.accelProfile = "flat";

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # enable for appindicator support
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bree = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bree = import ./bree/home.nix;


  nix = {
    # use the unstable version of nix
    package = pkgs.nixUnstable;

    # enable the flake feature
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    micro
    neofetch
  ];

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      inter
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    fontconfig = {
      antialias = true;
      useEmbeddedBitmaps = false;
      hinting.enable = true;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };

    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK JP"
        "Noto Sans Mono CJK KR"
        "Noto Sans Mono CJK HK"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK TC"
      ];
      sansSerif = [
        # "Inter"
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Sans CJK KR"
        "Noto Sans CJK HK"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
      ];
      serif = [
        "Noto Serif"
        "Noto Sans CJK JP"
        "Noto Sans CJK KR"
        "Noto Sans CJK HK"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
      ];
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
