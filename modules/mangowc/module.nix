{
  config,
  lib,
  wlib,
  ...
}:
{
  _class = "wrapper";
  options = {
    configFile = lib.mkOption {
      type = wlib.types.file config.pkgs;
      default.content = "";
      description = ''
        MangoWM (mangowc) configuration.
      '';
    };
  };

  config.flags = {
    "-c" = toString config.configFile.path;
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