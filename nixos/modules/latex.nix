{ pkgs, ... }:
let
  path = "/nix/store/4pad57scismgr0hx8ja42cihbsg7a31f-texlive_2026.lz4hc.erofs";
  mountPoint = "/opt/texlive-2026";
  binDir = "bin/x86_64-linux";
  # Cache only the command inventory, not the extracted executable files.
  inventory =
    pkgs.runCommand "texlive-2026-inventory"
      {
        nativeBuildInputs = [
          pkgs.erofs-utils
          pkgs.file
        ];
        image = builtins.storePath path;
        # Update this hash when changing the image or inventory format.
        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = "378459db06666080ddb533cb92635da2ff9f0f9f8abb4b3c1d6ff47ba336fe8f";
      }
      ''
        fsck.erofs --extract="$TMPDIR/texlive-bin" --path=/${binDir} "$image"
        for executable in "$TMPDIR/texlive-bin/"*; do
          name=$(basename "$executable")
          if file --brief --dereference "$executable" | grep -q '^ELF '; then
            printf 'elf %s\n' "$name"
          else
            printf 'script %s\n' "$name"
          fi
        done > "$out"
      '';
  loader = "${pkgs.glibc}/lib64/ld-linux-x86-64.so.2";
  libraryPath = pkgs.lib.makeLibraryPath [
    pkgs.glibc
    pkgs.stdenv.cc.cc.lib
    pkgs.libxcrypt-legacy
    pkgs.zlib
    pkgs.fontconfig
    pkgs.freetype
    pkgs.libGL
    pkgs.freeglut
    pkgs.libice
    pkgs.libsm
    pkgs.libx11
    pkgs.libxaw
    pkgs.libxext
    pkgs.libxmu
    pkgs.libxpm
    pkgs.libxt
  ];
in
if builtins.pathExists path then
  {
    fileSystems.${mountPoint} = {
      device = path;
      fsType = "erofs";
      options = [
        "loop"
        "ro"
      ];
    };
    environment.systemPackages = [
      (pkgs.runCommand "texlive-2026" { } ''
        mkdir -p "$out/bin"
        while read -r kind name; do
          if [ "$kind" = elf ]; then
            cat > "$out/bin/$name" <<WRAPPER
        #!${pkgs.runtimeShell}
        export PATH="$out/bin:\$PATH"
        exec ${loader} --library-path ${libraryPath} --argv0 "${mountPoint}/${binDir}/$name" "${mountPoint}/${binDir}/$name" "\$@"
        WRAPPER
            chmod +x "$out/bin/$name"
          else
            ln -s "${mountPoint}/${binDir}/$name" "$out/bin/$name"
          fi
        done < ${inventory}
      '')
    ];
  }
else
  { }
