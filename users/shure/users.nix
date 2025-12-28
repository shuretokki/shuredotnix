{ pkgs, vars, ... }: {
  users.users.${vars.username} = {
    isNormalUser = true; 
    description = vars.username;
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "video" "audio" "ydotool" ];
    shell = pkgs.bash;
  };

  programs.bash.enable = true;
}