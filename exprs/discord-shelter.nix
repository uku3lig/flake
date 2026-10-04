{
  asar,
  discord,
  openasar,
  writeText,
}:
let
  updaterHook = writeText "updater-hook.js" ''
    "use strict";

    if (globalThis.__nixpkgsDiscordUpdaterHook) {
      return;
    }
    globalThis.__nixpkgsDiscordUpdaterHook = true;

    const Module = require("module");
    const origCompile = Module.prototype._compile;
    const official = "https://updates.discord.com/";

    Module.prototype._compile = function (content, filename) {
      if (typeof content !== "string") {
        return origCompile.call(this, content, filename);
      }

      if (
        !content.includes("getRootPath") &&
        !content.includes("startCurrentVersion")
      ) {
        return origCompile.call(this, content, filename);
      }

      content = content
        .replace(
          /rootPath=([\w$]+)\.getRootPath\(\),userDataPath=\1\.getUserData\(\);if\(null==rootPath\)return!1;/,
          `rootPath=$1.getRootPath()??(repositoryUrl!=="''${official}"?$1.getUserData():null),userDataPath=$1.getUserData();if(null==rootPath)return!1;`,
        )
        .replace(
          /await ([\w$]+)\.startCurrentVersion\(([\w$]+)\)(?!\s*\{)/,
          `await $1.startCurrentVersion($2,{allowObsoleteHost:bootstrapConstants.NEW_UPDATE_ENDPOINT!=="''${official}"&&appSettings.getSettings()?.get("SKIP_HOST_UPDATE")})`,
        )
        .replace(
          "const root_path = paths.getRootPath();",
          `const root_path = paths.getRootPath() ?? (repository_url !== "''${official}" ? paths.getUserData() : null);`,
        )
        .replace(
          "await inst.startCurrentVersion({});",
          `await inst.startCurrentVersion({}, { allowObsoleteHost: require("../Constants").NEW_UPDATE_ENDPOINT !== "''${official}" && settings.get("SKIP_HOST_UPDATE") });`,
        );

      return origCompile.call(this, content, filename);
    };
  '';

  updaterMain = writeText "updater-main.js" ''
    "use strict";
    require("./updater-hook.js");
    require("./bundle.js");
  '';

  injectHook = ''
    resources=""
    for d in "$out"/opt/*/resources; do
      if [ -d "$d" ]; then
        resources="$d"
        break
      fi
    done

    host_asar=""
    if [ -n "$resources" ] && [ -f "$resources/_app.asar" ]; then
      host_asar="$resources/_app.asar"
    elif [ -n "$resources" ] && [ -f "$resources/app.asar" ]; then
      host_asar="$resources/app.asar"
    fi

    if [ -z "$host_asar" ]; then
      echo "custom-updater: no packed app.asar; skipping"
    else
      unpack=app.asar.unpacked
      rm -rf "$unpack"
      ${asar}/bin/asar extract "$host_asar" "$unpack"
      if [ ! -f "$unpack/bundle.js" ]; then
        echo "custom-updater: asar has no bundle.js (OpenASAR?); skipping hook inject"
      else
        cp ${updaterHook} "$unpack/updater-hook.js"
        cp ${updaterMain} "$unpack/updater-main.js"
        substituteInPlace "$unpack/package.json" \
          --replace-fail '"main": "bundle.js"' '"main": "updater-main.js"'
        rm -f "$host_asar"
        ${asar}/bin/asar pack "$unpack" "$host_asar"
        echo "custom-updater: injected updater hook into $host_asar"
      fi
      rm -rf "$unpack"
    fi
  '';

  patchedOpenasar = openasar.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace ./src/updater/updater.js \
        --replace-fail \
          "const root_path = paths.getRootPath();" \
          "const root_path = paths.getRootPath() ?? (repository_url !== 'https://updates.discord.com/' ? paths.getUserData() : null);"
      substituteInPlace ./src/splash/index.js \
        --replace-fail \
          "await inst.startCurrentVersion({});" \
          "await inst.startCurrentVersion({}, { allowObsoleteHost: require('../Constants').NEW_UPDATE_ENDPOINT !== 'https://updates.discord.com/' && settings.get('SKIP_HOST_UPDATE') });"
    '';
  });
in
discord.override {
  disableUpdates = false;
  withOpenASAR = true;
  openasar = patchedOpenasar;
  unwrappedDiscord = discord.unwrappedDiscord.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ asar ];
    postInstall = (old.postInstall or "") + injectHook;
  });
}
