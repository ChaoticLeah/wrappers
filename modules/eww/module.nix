{
  config,
  wlib,
  lib,
  ...
}:
{
  _class = "wrapper";
  options = {
    "eww.yuck" = lib.mkOption {
      type = wlib.types.file config.pkgs;
      default.content = "";
      description = ''
        Main eww widget configuration file.
        See <https://elkowar.github.io/eww/configuration.html>
      '';
    };

    "eww.scss" = lib.mkOption {
      type = wlib.types.file config.pkgs;
      default.content = "";
      description = ''
        Main eww stylesheet.
        See <https://elkowar.github.io/eww/configuration.html>
      '';
    };

    files = lib.mkOption {
      type = lib.types.attrsOf (wlib.types.file config.pkgs);
      default = {
        "eww.yuck" = config."eww.yuck";
        "eww.scss" = config."eww.scss";
      };
      description = ''
        Additional files to include in the eww config directory.
        Attribute names become relative file paths under the config directory.
      '';
      example = {
        "eww.yuck".content = ''
          (defwindow bar
            :geometry (geometry :x "0%" :y "0%" :width "100%" :height "32px")
            (box :class "bar"))
        '';
        "eww.scss".content = ''
          .bar {
            background: #1f2430;
          }
        '';
        "scripts/volume.sh".content = ''
          #!/usr/bin/env sh
          echo 42
        '';
      };
    };
  };

  config = {
    package = config.pkgs.eww;

    env = {
      EWW_CONFIG_DIR = toString (
        config.pkgs.linkFarm "eww-config" (
          lib.mapAttrsToList (name: file: {
            inherit name;
            path = file.path;
          }) config.files
        )
      );
    };

    flags = {
      "--config" = config.env.EWW_CONFIG_DIR;
    };

    meta = {
      maintainers = [
        {
          name = "ChaoticLeah";
          github = "ChaoticLeah";
          githubId = 45321184;
        }
      ];
      platforms = lib.platforms.linux;
    };
  };
}
