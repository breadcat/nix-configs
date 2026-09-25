{ pkgs, ... }:

let
  hyprland-alt-toggle = pkgs.writeShellScriptBin "hyprland-alt-toggle" ''
    set -euo pipefail

    STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/hyprland-alt-toggle.state"

    DRAG_KEYS="ALT + mouse:272"
    RESIZE_KEYS="ALT + mouse:273"

    hl_eval() {
        # Runs a Lua expression via hyprctl eval and surfaces errors.
        local expr="$1"
        local out
        if ! out="$(hyprctl eval "$expr" 2>&1)"; then
            echo "Error running: $expr" >&2
            echo "$out" >&2
            exit 1
        fi
        if [[ "$out" != "ok" ]]; then
            echo "Warning: unexpected response for: $expr" >&2
            echo "$out" >&2
        fi
    }

    do_unbind() {
        echo "Unbinding $DRAG_KEYS (drag) and $RESIZE_KEYS (resize)..."
        hl_eval "hl.unbind('$DRAG_KEYS')"
        hl_eval "hl.unbind('$RESIZE_KEYS')"
        touch "$STATE_FILE"
        echo "Done. Alt+Click is now free for other apps."
    }

    do_rebind() {
        echo "Rebinding $DRAG_KEYS to window.drag and $RESIZE_KEYS to window.resize..."
        hl_eval "hl.bind('$DRAG_KEYS', hl.dsp.window.drag(), { mouse = true })"
        hl_eval "hl.bind('$RESIZE_KEYS', hl.dsp.window.resize(), { mouse = true })"
        rm -f "$STATE_FILE"
        echo "Done. Hyprland's Alt+Click window drag/resize is restored."
    }

    case "''${1:-toggle}" in
        unbind)
            do_unbind
            ;;
        rebind)
            do_rebind
            ;;
        toggle)
            if [[ -f "$STATE_FILE" ]]; then
                do_rebind
            else
                do_unbind
            fi
            ;;
        *)
            echo "Usage: $0 [unbind|rebind|toggle]" >&2
            exit 1
            ;;
    esac
  '';
in
{
  environment.systemPackages = [ hyprland-alt-toggle ];
}
