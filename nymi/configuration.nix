{ pkgs, specialArgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the nix configuration
      ./nix-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_9;
  boot.kernelParams = [
    "nvidia-drm.modset=1"
    "initcall_blacklist=simpledrm_platform_driver_init"
  ];

  hardware.bluetooth.enable = false;
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];

  networking.hostName = "nymi";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  networking.interfaces.enp42s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  # networking.wireless.extraConfig = "
  #   freq_list=2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484
  # ";

  # Enable .local
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = false;
  };


  services.libinput.mouse.accelProfile = "flat";

  # Enable the Pantheon Desktop Enviroment.
  services.xserver.displayManager.lightdm.enable = true;  
  services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
  
  services.pantheon.apps.enable = true;
  services.pantheon.contractor.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.pantheon.xdg-desktop-portal-pantheon ];
  xdg.portal.config.common.default = "*";
  
  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.displayManager.sddm.enable = true;
  # services.desktopManager.lomiri.enable = true;
  # xdg.portal.enable = true;

  # Enable the KDE Desktop Enviroment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  
  # enable for appindicator support
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Enable sound.
  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   audio.enable = true;
  #   pulse.enable = true;
  #   alsa.enable = true;
  #   jack.enable = true;
  #   wireplumber.enable = true;
  # };

  services.earlyoom = {
      enable = true;
      freeSwapThreshold = 3;
      freeMemThreshold = 3;
      extraArgs = [
          "-g" "--avoid '^(X|plasma\.*|\.gnome*)$'"
          "--prefer '^(Tower\.exe|Resonite\.exe)$'"
      ];
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
  home-manager.extraSpecialArgs = specialArgs;

  environment.systemPackages = with pkgs; [
    micro
    neofetch
  ];

  services.flatpak.enable = true;

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      inter
      # fira-code
      # fira-code-symbols
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
  
  # needed to be enabled for default shell
  programs.fish.enable = true;

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
