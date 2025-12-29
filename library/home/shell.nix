{ pkgs, ... }: {
    programs.bash = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake .";
            optimise = "sudo nix-store --optimise";
            eza = "eza --icons";
        };
        bashrcExtra = ''
            # Usage: list gen, list sizes, list real
            list() {
                case "$1" in
                    gen) sudo nix-env --list-generations -p /nix/var/nix/profiles/system ;;
                    sizes) nix path-info -Sh /nix/var/nix/profiles/system-*-link ;;
                    real) du -sh /nix/store ;;
                    *) echo "Usage: list [gen|sizes|real]" ;;
                esac
            }

            # Usage: delete old gen [days]
            delete() {
                if [ "$1" = "old" ] && [ "$2" = "gen" ]; then
                    if [ -z "$3" ]; then
                        sudo nix-collect-garbage -d
                    else
                        sudo nix-collect-garbage --delete-older-than "''${3}d"
                    fi
                else
                    echo "Usage: delete old gen [days]"
                fi
            }
        '';
        profileExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec uwsm start hyprland-uwsm.desktop
            fi
        '';
    };
}
