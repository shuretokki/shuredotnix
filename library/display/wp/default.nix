{ vars, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = ["/home/${vars.username}/shure-wp/001.jpg"];
      wallpaper = [",/home/${vars.username}/shure-wp/001.jpg"];
    };
  };
}