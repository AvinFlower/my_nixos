{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
  ];
    
  system.stateVersion = "25.05";
  
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Moscow";
    
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    bluetooth.enable = false;
  };
        
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
      excludePackages = with pkgs; [ xterm ];
      xkb.layout = "us,ru";
      xkb.options = "grp:win_alt_toggle";
    };
    
    displayManager.autoLogin = {
      enable = true;
      user = "vanish";
    };
    
    printing.enable = true;
    
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      audio.enable = true;
    };
  };  
  
  security.rtkit.enable = true;
  virtualisation.libvirtd.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  users.users.vanish = {
    isNormalUser = true;
    extraGroups = [ "libvirtd" "networkmanager" "wheel" "audio" "docker" ];
    initialPassword = "oxi-action";
  };
  
  security.sudo.extraRules = [
    { 
      users = [ "vanish" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];
  
  programs = {
    firefox.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = false;
    };
    gamemode.enable = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "freeimage-3.18.0-unstable-2024-04-18"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      wget 
      nix-search-cli 
      git 
      vscode
      v2rayn 
      onlyoffice-bin
      telegram-desktop
      p7zip 
      anydesk
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
      #gnomeExtensions.gsconnect
      gnomeExtensions.soft-brightness-plus
      gnomeExtensions.translate-clipboard
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.arcmenu
      gnomeExtensions.compiz-windows-effect
      gnomeExtensions.burn-my-windows
      gnomeExtensions.desktop-cube
      gnomeExtensions.just-perfection
      gnomeExtensions.paperwm
      gnomeExtensions.translate-clipboard
      gnomeExtensions.vitals
      gnomeExtensions.unblank
    ];
    
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
    
    gnome.excludePackages = with pkgs; [
      cheese
      eog
      epiphany
      simple-scan
      totem
      yelp
      evince
      file-roller
      geary
      seahorse
      gnome-tour
      gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-photos
      gnome-weather
      gnome-connections
    ];
  };
}
