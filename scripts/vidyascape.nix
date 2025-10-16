{ pkgs, ... }:

let
  vidyascape = pkgs.writeShellScriptBin "vidyascape" ''

# variables
launcher_uri="https://vidyascape.org/files/vidyascape_launcher.jar"
config_file="$HOME/.vscape2/settings.ini"
declare -a configs=(
	"dropPosition=2"
	"enabled=true"
	"hideAfter=3"
	"legacyNpcs=false"
	"legacyObjects=true"
	"loginMusic=false"
	"lowDetail=false"
	"modernRendering=true"
	"orbsOnRight=false"
	"pixelScaling=1"
	"preferredWorld=2"
	"rememberCredentials=true"
	"rememberWorld=true"
	"sizeMode=RESIZABLE"
	)

# launcher binary
if [ -f "/tmp/$(basename $launcher_uri)" ]; then
   echo "Launcher exists, skipping"
else
   echo "Launcher doesn't exist, downloading."
   curl -s -o "/tmp/$(basename $launcher_uri)" "$launcher_uri"
fi

# config file
if [ -f "$config_file" ]; then
	for kv in "''${configs[@]}"; do
	  key=''${kv%%=*}
	  value=''${kv#*=}
	  # Replace key value if exists
	  sed -i -E "s|^([[:space:]]*$key[[:space:]]*=[[:space:]]*).*|\1$value|" "$config_file"
	done
else
	echo "Config doesn't exist so will not be patched until next run."
fi

# launch game
echo "Launching game..."
${pkgs.jre8}/bin/java -jar "/tmp/$(basename $launcher_uri)"
  '';

in {
  environment.systemPackages = [ vidyascape ];
}