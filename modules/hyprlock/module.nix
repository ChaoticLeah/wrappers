{
  config,
  lib,
  wlib,
  ...
}:

let
  hyprlockkeyValueFormat = config.pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
  };
in
{
  _class = "wrapper";
  options = {
    settings = lib.mkOption {
      type = hyprlockkeyValueFormat.type;
      default = { };
      description = ''
        Configuration for hyprlock.
        See <https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock>
      '';
    };

    extraSettings = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra lines appended to the config file.
        This can be used to maintain order for settings.
      '';
    };

    "hyprlock.conf" = lib.mkOption {
      type = wlib.types.file config.pkgs;
      default.path =
        let
          fileName = "hyprlock.conf";
          base = hyprlockkeyValueFormat.generate fileName config.settings;
        in
        if config.extraSettings != "" then
          config.pkgs.concatText fileName [
            base
            (config.pkgs.writeText "extraSettings" config.extraSettings)
          ]
        else
          base;
      description = ''
        Raw configuration for hyprlock.
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable verbose logging.
      '';
    };

    quiet = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable logging.
      '';
    };

    display = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Specify the wayland display to connect to.
      '';
    };

    grace = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        Set grace period in seconds before requiring authentication.
      '';
    };

    immediateRender = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Do not wait for resources before drawing the background.
      '';
    };

    noFadeIn = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable the fade-in animation when the lock screen appears.
      '';
    };
  };

  config.flags = {
    "--config" = toString config."hyprlock.conf".path;
  };

  config.meta.maintainers = [
    {
      name = "ChaoticLeah";
      github = "ChaoticLeah";
      githubId = 45321184;
    }
  ];

  config.package = config.pkgs.hyprlock;
}
