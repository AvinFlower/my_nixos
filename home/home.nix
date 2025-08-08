{ config, pkgs, ... }:

{
  home.username = "vanish";
  home.homeDirectory = "/home/vanish";
  home.stateVersion = "25.05";

  # Копируем конфиги из папки configs — абсолютно все, что нужно приложениям
  home.file = {
    ".config/Code/User/settings.json".source = ./configs/vscode-settings.json;
    ".config/Code/User/keybindings.json".source = ./configs/vscode-keybindings.json;
    ".config/MangoHud/MangoHud.conf".source = ./configs/mangohud.conf;
    # ".config/qbittorrent/qbittorrent.conf".source = ./configs/qbittorrent.conf;
    # Добавляй сюда остальные конфиги по мере необходимости

  ".config/mimeapps.list".text = ''
    [Default Applications]
    text/plain=code.desktop
    text/csv=code.desktop
    text/x-log=code.desktop
    text/x-ini=code.desktop
    application/x-msdos-program=code.desktop
    application/rtf=code.desktop
    text/html=code.desktop
    text/xml=code.desktop
    application/json=code.desktop
    text/x-yaml=code.desktop
    text/x-sql=code.desktop
    application/javascript=code.desktop
    text/x-vbscript=code.desktop
    text/x-php=code.desktop
    text/x-python=code.desktop
    application/x-sh=code.desktop
    application/x-shellscript=code.desktop
    application/x-powershell=code.desktop
    text/x-tex=code.desktop
    text/x-nix=code.desktop
    text/plain=code.desktop
    text/x-conf=code.desktop
    text/x-lock=code.desktop
  '';
  };

  

  # Системные переменные окружения
  home.sessionVariables = {
    EDITOR = "code";
    LANG = "en_US.UTF-8";
  };

  # Системные команды, автозапуск, хоткеи
  # home.activation.setxkbmap = hm.lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   ${pkgs.xkbutils}/bin/setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"
  # '';


  # Программы, которые хочешь активировать через Home Manager
  # programs.vscode.enable = true;
  # programs.git.enable = true;
  # programs.zsh.enable = true;
}
