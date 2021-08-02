{ config, lib, pkgs, ... }:

let
  /*
    * flattenTree & rakeLeaves were stolen from divinx/digga
    * https://github.com/divnix/digga/blob/13958d2b97263356e5661b9e2958e1e4730e12fd/src/importers.nix
  */

  flattenTree =
    tree:
    let
      op = sum: path: val:
        let
          pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
        in
        if builtins.isPath val then
          (sum // {
            "${pathStr}" = val;
          })
        else if builtins.isAttrs val then
          (recurse sum path val)
        else
          sum
      ;

      recurse = sum: path: val:
        builtins.foldl'
          (sum: key: op sum (path ++ [ key ]) val.${key})
          sum
          (builtins.attrNames val)
      ;
    in
    recurse { } [ ] tree;

  rakeLeaves =
    dirPath:
    let
      seive = file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory")
      ;

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if (type == "regular")
            || (type == "directory" && builtins.pathExists (path + "/default.nix"))
          then path
          # recurse on directories that don't contain a `default.nix`
          else rakeLeaves path;
      };

      files = lib.filterAttrs seive (builtins.readDir dirPath);
    in
    lib.filterAttrs (n: v: v != { }) (lib.mapAttrs' collect files);

  defsAttr = lib.mapAttrs' (name: value: lib.nameValuePair (builtins.replaceStrings [ "." ] [ "-" ] name) (value)) (flattenTree (rakeLeaves ./definitions));
  defs = lib.forEach
    (
      lib.mapAttrsToList (n: v: n) defsAttr
    )
    (x:
      ''<def name="${x}">
    ${(import defsAttr.${x} { lib = lib; pkgs = pkgs; }).def}
    </def>''
    );
  sysCheck = pkgs.writeScriptBin "sysCheck" ''
        #!${pkgs.stdenv.shell}
        case $1 in
      up) # deals with uptime less than a minute, where the command `uptime` doesn't work
        time="$(uptime -p )"
        time="''${time/up }"
        time="''${time/ day,/d}"
        time="''${time/ days,/d}"
        time="''${time/ hours,/h}"
        time="''${time/ minutes/m}"
        echo ''${time:-'less than a minute'}
        ;;
      cpuavg) # avg cpu load since the cpu started
        grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' ;;
      disk) # disk space of the root partition
        percent_used="$(df -h /persist | tail -n -1 | awk '{ print $4 "\t" }')"
        df -h /persist | tail -n -1 | awk '{ print $4" / "$3 }'
        ;;
      mem) # source: https://github.com/KittyKatt/screenFetch/issues/386#issuecomment-249312716
        while IFS=":" read -r a b; do
              case $a in
                "MemTotal") ((mem_used+=''${b/kB})); mem_total="''${b/kB}" ;;
                "Shmem") ((mem_used+=''${b/kB}))  ;;
                "MemFree" | "Buffers" | "Cached" | "SReclaimable")
                mem_used="$((mem_used-=''${b/kB}))"
              ;;
              esac
        done < /proc/meminfo

            echo "$((mem_used / 1024))kb / $((mem_total / 1024))kb"
        ;;
    esac
  '';

  barHeight = "13px";
in
{
  config = {
    home = {
      file.".cache/face.png" = {
        source = ./face.png;
      };
      packages = [
        pkgs.tiramisu
        pkgs.SFMono-nerdfont
      ];
    };
    fonts.fontconfig.enable = true;
    services.eww = {
      enable = true;
      isWayland = true;
      style = ./eww.scss;
      config = {
        definitions = defs;
        variables = {
          script-vars = {

            time = {
              text = ''date "+%H:%M"'';
              interval = {
                quantity = 15;
                units = "s";
              };
            };

            networking = {
              text = "nmcli -p -g {connection} | grep -e 'connected to' | sed -e 's/ .* //' -e 's/.*://'";
              interval = {
                quantity = 60;
                units = "s";
              };
            };

            /*
              * Date
            */
            day_num = {
              text = ''date "+%d"'';
              interval = {
                quantity = 2;
                units = "h";
              };
            };
            month = {
              text = ''date "+%b"'';
              interval = {
                quantity = 12;
                units = "h";
              };
            };
            weekday = {
              text = ''date "+%a"'';
              interval = {
                quantity = 2;
                units = "h";
              };
            };
            min = {
              text = ''date "+%M"'';
              interval = {
                quantity = 10;
                units = "s";
              };
            };
            hour = {
              text = ''date "+%I"'';
              interval = {
                quantity = 25;
                units = "s";
              };
            };
            ampm = {
              text = ''date "+%P"'';
              interval = {
                quantity = 1;
                units = "h";
              };
            };

            /*
              * Sidebar
            */
            uptime = {
              text = ''bash -c "${sysCheck}/bin/sysCheck up"'';
              interval = {
                quantity = 60;
                units = "s";
              };
            };
            cpuavg = {
              text = ''bash -c "${sysCheck}/bin/sysCheck cpuavg"'';
              interval = {
                quantity = 60;
                units = "s";
              };
            };
            disk = {
              text = ''bash -c "${sysCheck}/bin/sysCheck disk"'';
              interval = {
                quantity = 1;
                units = "h";
              };
            };
            mem = {
              text = ''bash -c "${sysCheck}/bin/sysCheck mem"'';
              interval = {
                quantity = 30;
                units = "s";
              };
            };

          };
          vars = {
            homedir = "${config.home.homeDirectory}";
            usernm = "${config.home.username}";
            hostnm = "tardis";
            notificationBool = "false";
            notificationsContent = "";
          };
        };
        windows = {
          bar = {
            stacking = "bt";
            focusable = false;
            exclusive = true;
            geometry = {
              anchor = "top center";
              x = "0px";
              y = "0px";
              width = "100%";
              height = barHeight;
            };
            widget = "bar";
          };
          sidebar = {
            geometry = {
              anchor = "top right";
              x = "0px";
              y = barHeight;
              width = "500px";
              height = "100%";
            };
            widget = "sidebar";
          };
          notification = {
            geometry = {
              anchor = "top right";
              x = "0px";
              y = barHeight;
              width = "400px";
              height = "0px";
            };
            stacking = "fg";
            widget = "notifications-widget";
          };
        };
      };
    };
  };
}
