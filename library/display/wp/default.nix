{ vars, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = ["/home/${vars.username}/${vars.wallpaperDir}/001.jpg"];
      wallpaper = [",/home/${vars.username}/${vars.wallpaperDir}/001.jpg"];
    };
  };
}