{ pkgs, vars, ... }: {
  users.users.${vars.username} = {
    uid = 1000;
    isNormalUser = true;
    description = vars.username;
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ];
    shell = pkgs.bash;
  };
}
