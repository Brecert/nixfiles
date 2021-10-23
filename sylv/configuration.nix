{ nixpkgs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # System configuration
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Hardware (soft) configuration
  hardware.opengl.driSupport32Bit = true;
  hardware.steam-hardware.enable = true;
  hardware.bluetooth.enable = true;

  ## Nvidia configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  ## XServer hardware (soft) configurations
  services.xserver = {
    # Enable wacom and generic tablet support.
    wacom.enable = true;
    # digimend.enable = true;
    modules = [ pkgs.xf86_input_wacom ];
  };
  # hardware.opentabletdriver.enable = true;
  # hardware.opentabletdriver.daemon.enable = true;


  # Networking configuration
  networking = {
    hostName = "sylv";
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      wlp59s0.useDHCP = true;
    };

    # nameservers =
    #   [ "155.138.240.237" "2001:19f0:6401:b3d:5400:2ff:fe5a:fb9f" ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  ## Enable an IDE for japanese 
  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # Fonts configuration
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

    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Fira Code"
        "Noto Sans Mono CJK JP"
        "Noto Sans Mono CJK KR"
        "Noto Sans Mono CJK HK"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK TC"
      ];
      sansSerif = [
        "Inter"
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

  # Desktop enviroment configuration
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  # services.xserver = {
  #   enable = true;
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma5.enable = true;
  # };

  # Sound configuration
  # TODO: switch to pipewire and enable the bridges
  sound.enable = true;

  # Just in case it's enabled elsewhere
  hardware.pulseaudio.enable = false;

  # enable rtkit to allow pipewire to gain realtime priority (not that it matters)
  security.rtkit.enable = true;

  # enable pipewire and configure it to provide a pulseaudio and alsa interface
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Nix configuration
  # Enable non-free packages.
  nixpkgs.config.allowUnfree = true;

  nix = {

    # use the unstable version of nix
    package = pkgs.nixUnstable;

    # enable the flake feature
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Programs and Services configuration
  environment.systemPackages = with pkgs; [
    micro
    httpie
    firefox
    sublime4

    libwacom
    wacomtablet
    xf86_input_wacom
    fceux
    wineWowPackages.stable

    gnomeExtensions.appindicator
  ];

  programs.fish.enable = true;

  users.users.bree = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  ## Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bree = import ./bree/home.nix;

  ## Enable flatpak for steam
  services.flatpak.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
