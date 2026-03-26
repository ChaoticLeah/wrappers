{
  config,
  lib,
  wlib,
  ...
}:

let
  kvFmt = config.pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
  };
in
{
  _class = "wrapper";
  options = {
    settings = lib.mkOption {
      type = kvFmt.type;
      default = { };
      description = ''
        Configuration for MangoWM (mangowc).
        See <https://github.com/mangowm/mango/wiki/basics>
      '';
      example = {
        "border-width" = 1;
        gaps = 5;
        "exec-once" = "waybar";
      };
    };
    "config.conf" = lib.mkOption {
      type = wlib.types.file config.pkgs;
      default.path = kvFmt.generate "config.conf" config.settings;
      description = ''
        Raw configuration file for mangowc
      '';
    };
  };

  config.flags = {
    "-c" = toString config."config.conf".path;
  };

  config.package = config.pkgs.mangowc;
  config.meta.maintainers = [
    {
      name = "ChaoticLeah";
      github = "ChaoticLeah";
      githubId = 45321184;
    }
  ];
  config.meta.platforms = lib.platforms.linux;
}