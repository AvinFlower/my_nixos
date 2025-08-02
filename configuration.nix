{ config, lib, pkgs, ... }:

{
  imports = [ 
  ./hardware-configuration.nix 
  ];
    
  system.stateVersion = "25.05";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  # Включаем GNOME и X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "us,ru";
    xkb.options = "grp:win_alt_toggle";
  };
    
  hardware = {
    # Включаем графику (ранее opengl)
    graphics = {
      enable    = true;
      enable32Bit = true;
    };

    # Настройки NVIDIA
    nvidia = {
      modesetting.enable     = true;
      powerManagement.enable = true;
      open                   = false;
      nvidiaSettings         = true;
      prime = {
        sync.enable      = true;
        nvidiaBusId      = "PCI:1:0:0";
        intelBusId       = "PCI:0:2:0";
      };
    };

    # Отключаем Bluetooth
    bluetooth.enable = false;
  };
        

  # Остальные настройки...
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    audio.enable = true;
  };
  
  virtualisation.libvirtd.enable = true;

  users.users.vanish = {
    isNormalUser = true;
    extraGroups = [ "libvirtd" "networkmanager" "wheel" "audio" "docker" ];
    initialPassword = "oxi-action";
  };
  
  security.sudo = {
    extraRules = [
      { 
        users = [ "vanish" ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }  # Разрешить все команды
        ];
      }
    ];
  };

  services.displayManager.autoLogin = {
    enable = true;
    user   = "vanish";
  };
  
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  
  programs = {
    firefox.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  # Разрешаем insecure-пакеты (freeimage требуется некоторым расширениям)
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-3.18.0-unstable-2024-04-18"
  ];

  environment.systemPackages = with pkgs; [
    wget 
    nix-search-cli 
    git 
    vscode 
    python3 
    v2rayn 
    onlyoffice-bin
    telegram-desktop
    p7zip 
    anydesk 
    xterm 
    popsicle
    pavucontrol
    virt-manager
    autorandr
    python3Full
    neofetch
    mangohud
    protonup
    lutris
    bottles
    
    
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.translate-clipboard
    gnomeExtensions.brightness-control-using-ddcutil
    
    gnomeExtensions.dock-from-dash
    gnomeExtensions.blur-my-shell
    gnomeExtensions.panel-corners
    gnomeExtensions.arcmenu
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.burn-my-windows
    gnomeExtensions.desktop-cube
    gnomeExtensions.just-perfection
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.forge
    gnomeExtensions.pop-shell  
  ];
  
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
  
  environment.gnome.excludePackages = with pkgs; [
    #baobab      # disk usage analyzer
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    #gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    file-roller # archive manager
    geary       # email client
    seahorse    # password manager
    gnome-tour

    # these should be self explanatory
    gnome-calendar gnome-characters gnome-contacts
    gnome-maps gnome-music gnome-photos
    gnome-weather pkgs.gnome-connections
  ];
}
