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
      # sort:start
      "--disable-features=AiModeOmniboxEntryPoint"
      "--disable-features=HideAimEntrypointOnUserInput"
      "--disable-features=Translate"
      "--enable-feature=WebUIDarkMode"
      "--force-dark-mode"
      "--homepage=https://breadcat.github.io/startpage/"
      "--no-default-browser-check"
      # sort:end
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
