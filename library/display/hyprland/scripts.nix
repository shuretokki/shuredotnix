# custom scripts added to environment.systemPackages.
# toggle-gaps: toggles gaps on/off for current workspace.

{ pkgs, ... }:
let
  toggle-gaps = pkgs.writeShellScriptBin "toggle-gaps" ''
    workspace_id=$(hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r .id)
    gaps=$(hyprctl workspacerules -j | ${pkgs.jq}/bin/jq -r ".[] | select(.workspaceString==\"$workspace_id\") | .gapsOut[0] // 0")
    if [[ $gaps == "0" ]]; then
      hyprctl keyword "workspace $workspace_id, gapsout:12, gapsin:4, bordersize:1"
    else
      hyprctl keyword "workspace $workspace_id, gapsout:0, gapsin:0, bordersize:0"
    fi
  '';
in
[
  toggle-gaps
]
