# https://github.com/nix-community/home-manager/blob/master/modules/programs/btop.nix

{
  lib,
  config,
  ...
}:
let
  c = config.lib.stylix.colors;
in
{
  programs.btop = {
    enable = lib.mkDefault true;

    settings = {
      color_theme = "sync";
      theme_background = false;
      truecolor = true;
      force_tty = false;
      vim_keys = false;
      rounded_corners = false;
      graph_symbol = "braille";
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = true;
      net_iface = "";
      show_battery = true;
      log_level = "WARNING";
    };

    themes = {
      stylix = ''
        theme[main_bg]="#${c.base00}"
        theme[main_fg]="#${c.base05}"
        theme[title]="#${c.base05}"
        theme[hi_fg]="#${c.base0D}"
        theme[selected_bg]="#${c.base02}"
        theme[selected_fg]="#${c.base05}"
        theme[inactive_fg]="#${c.base03}"
        theme[graph_text]="#${c.base05}"
        theme[meter_bg]="#${c.base02}"
        theme[proc_misc]="#${c.base0E}"
        theme[cpu_box]="#${c.base0E}"
        theme[mem_box]="#${c.base0B}"
        theme[net_box]="#${c.base08}"
        theme[proc_box]="#${c.base0C}"
        theme[div_line]="#${c.base02}"
        theme[temp_start]="#${c.base0B}"
        theme[temp_mid]="#${c.base0A}"
        theme[temp_end]="#${c.base08}"
        theme[cpu_start]="#${c.base0B}"
        theme[cpu_mid]="#${c.base0A}"
        theme[cpu_end]="#${c.base08}"
        theme[free_start]="#${c.base0B}"
        theme[free_mid]="#${c.base0A}"
        theme[free_end]="#${c.base08}"
        theme[cached_start]="#${c.base0C}"
        theme[cached_mid]="#${c.base0D}"
        theme[cached_end]="#${c.base0E}"
        theme[available_start]="#${c.base0B}"
        theme[available_mid]="#${c.base0A}"
        theme[available_end]="#${c.base09}"
        theme[used_start]="#${c.base0B}"
        theme[used_mid]="#${c.base0A}"
        theme[used_end]="#${c.base08}"
        theme[download_start]="#${c.base0B}"
        theme[download_mid]="#${c.base0C}"
        theme[download_end]="#${c.base0D}"
        theme[upload_start]="#${c.base0E}"
        theme[upload_mid]="#${c.base08}"
        theme[upload_end]="#${c.base09}"
        theme[process_start]="#${c.base0B}"
        theme[process_mid]="#${c.base0A}"
        theme[process_end]="#${c.base03}"
      '';
    };

    extraConfig = "";
  };
}
