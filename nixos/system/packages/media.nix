{ pkgs, ... }:

let
  fluids = pkgs.writeScriptBin "fluids" ''
    exec ${pkgs.fluidsynth}/bin/fluidsynth "$@" ${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM*.sf2
  '';
in
{
  environment.systemPackages = with pkgs; [
    ffmpeg
    lilypond
    fluidsynth
    soundfont-fluid
    fluids
    inkscape
    aseprite
    krita
  ];
}
