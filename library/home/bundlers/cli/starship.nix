# https://github.com/nix-community/home-manager/blob/master/modules/programs/starship.nix

{
  lib,
  config,
  ...
}:
let
  c = config.lib.stylix.colors.withHashtag;
in
{
  programs.starship = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;

    settings = {
      add_newline = true;
      scan_timeout = 10;
      command_timeout = 500;

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$nodejs"
        "$python"
        "$rust"
        "$golang"
        "$docker_context"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      right_format = "$time";

      username = {
        show_always = false;
        style_user = "bold ${c.base0B}";
        style_root = "bold ${c.base08}";
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = true;
        style = "bold ${c.base0D}";
        format = "[@$hostname]($style) ";
      };

      directory = {
        style = "bold ${c.base0A}";
        read_only = " 󰌾";
        read_only_style = "bold ${c.base08}";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        style = "bold ${c.base0B}";
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style = "bold ${c.base08}";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        conflicted = "=";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
        format = "([$all_status$ahead_behind]($style) )";
      };

      character = {
        success_symbol = "[❯](bold ${c.base0B})";
        error_symbol = "[❯](bold ${c.base08})";
        vimcmd_symbol = "[❮](bold ${c.base0B})";
      };

      cmd_duration = {
        style = "bold ${c.base0E}";
        min_time = 2000;
        show_milliseconds = false;
        format = "[$duration]($style) ";
      };

      nix_shell = {
        style = "bold ${c.base0D}";
        symbol = " ";
        impure_msg = "";
        pure_msg = "";
        format = "[$symbol$state]($style) ";
      };

      nodejs = {
        style = "bold ${c.base0B}";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
        detect_extensions = [ "js" "mjs" "cjs" "ts" "mts" "cts" ];
        detect_files = [ "package.json" ".node-version" ".nvmrc" ];
        detect_folders = [ "node_modules" ];
      };

      python = {
        style = "bold ${c.base0A}";
        symbol = " ";
        format = "[$symbol$pyenv_prefix($version)(\\($virtualenv\\))]($style) ";
        detect_extensions = [ "py" ];
        detect_files = [ "requirements.txt" "pyproject.toml" "Pipfile" ".python-version" ];
      };

      rust = {
        style = "bold ${c.base09}";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
        detect_extensions = [ "rs" ];
        detect_files = [ "Cargo.toml" ];
      };

      golang = {
        style = "bold ${c.base0C}";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
        detect_extensions = [ "go" ];
        detect_files = [ "go.mod" "go.sum" "go.work" ];
      };

      docker_context = {
        style = "bold ${c.base0D}";
        symbol = " ";
        format = "[$symbol$context]($style) ";
        only_with_files = true;
        detect_files = [ "docker-compose.yml" "docker-compose.yaml" "Dockerfile" ];
      };

      time = {
        disabled = false;
        style = "bold ${c.base03}";
        format = "[$time]($style)";
        time_format = "%H:%M";
      };

      battery = {
        disabled = true;
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        unknown_symbol = "󰁽 ";
        empty_symbol = "󰂎 ";
        display = [
          { threshold = 20; style = "bold ${c.base08}"; }
        ];
      };
    };
  };
}
