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

  # Настройки NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    prime = {
      #offload.enable = false;
      sync.enable = true;
      #allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "vanish";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  
  programs.firefox.enable = true;
  programs.steam.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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
  ];
}
