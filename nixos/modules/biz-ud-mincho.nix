{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "biz-ud-mincho";
  version = "1.06";
  src = fetchzip {
    url = "https://github.com/googlefonts/morisawa-biz-ud-mincho/releases/download/v${finalAttrs.version}/morisawa-biz-ud-mincho-fonts.zip";
    hash = "sha256-TuNYguBCHkln8jbker/HxTNZS8cI1vJDRrT1PGmNSqE=";
  };
  sourceRoot = "${finalAttrs.src.name}/fonts";
  nativeBuildInputs = [ installFonts ];
  passthru = {
    updateScript = nix-update-script { };
  };
  meta = {
    description = "Universal Design Japanese Mincho font";
    homepage = "https://github.com/googlefonts/morisawa-biz-ud-mincho";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
