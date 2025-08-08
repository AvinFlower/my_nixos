{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
  ];
    
  system.stateVersion = "25.05";
  
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    # kernelParams = [
    #   "intel_iommu=on"
    #   "iommu=pt"
    #   "vfio-pci.ids=10de:2520,10de:228e"
    # ];
  
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
      #kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    };

    #blacklistedKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "nouveau" ];
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
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = false;
      nvidiaSettings = true;
      prime = {
        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    bluetooth.enable = false;
  };
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
  };
        
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      # videoDrivers = [ "intel" ];
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
      excludePackages = with pkgs; [ xterm ];
      xkb.layout = "us,ru";
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
  
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  security.rtkit.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [ pkgs.OVMF.fd ];
    qemu.package = pkgs.qemu_kvm; # или qemu_full, если нужен весь функционал
  };

  users.users.vanish = {
    isNormalUser = true;
    extraGroups = [ "libvirtd" "networkmanager" "wheel" "audio" "docker" ];
    initialPassword = "oxi-action";
  };
  
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [
      {
        users = [ "vanish" ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  }; 
  
  programs = {
    #zen-browser.enable = true;
    #nano.enable = false;
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
      vscode
      v2rayn 
      onlyoffice-bin
      telegram-desktop
      file-roller
      unrar
      anydesk
      popsicle
      qbittorrent

      virt-manager
      virt-viewer
      OVMF
      qemu

      neofetch
      blackbox-terminal
      autorandr
      pavucontrol
      wget 
      nix-search-cli 
      git
      python3Full
      samba

      mangohud
      protonup
      lutris
      bottles
      wine
      heroic
      mangojuice
    
      gnomeExtensions.appindicator
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
    
    variables = {
      VK_ICD_FILENAMES = "/nix/store/8pdixnksig7hy76dhc727mblw329cx7q-nvidia-x11-570.153.02-6.16/share/vulkan/icd.d/nvidia_icd.x86_64.json";
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

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
      };
    };
  };
  
  # 1) Автоматический GC Nix store и оптимизация
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "";
  };

  # 2) Автообновления системы
  system.autoUpgrade = {
    # Включить сервис auto-upgrade
    enable = true;
    # Как часто проверять и обновлять: daily, weekly или monthly
    dates = "weekly";
  };

  # 3) Очистка временных директорий через tmpfiles
  systemd.tmpfiles.rules = [
    # /tmp: удалять файлы старше 1 дня
    "d /tmp 1777 root root 1d"
    # /var/tmp: удалять файлы старше 7 дней
    "d /var/tmp 1777 root root 7d"
  ];

}
