{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    # package = pkgs.ungoogled-chromium;

    dictionaries = [ pkgs.hunspellDictsChromium.en_GB ];

    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "lfjnnkckddkopjfgmbcpdiolnmfobflj"; } # custom new tab
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
    ];

    commandLineArgs = [
      "--homepage=https://breadcat.github.io/startpage/"
      "--force-dark-mode"
      "--no-default-browser-check"
      "--enable-feature=WebUIDarkMode"
      "--disable-features=Translate"
    ];
  };

  home.sessionVariables = {
    BROWSER = "chromium";
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["chromium.desktop"];
    "text/xml" = ["chromium.desktop"];
    "x-scheme-handler/http" = ["chromium.desktop"];
    "x-scheme-handler/https" = ["chromium.desktop"];
  };
}
