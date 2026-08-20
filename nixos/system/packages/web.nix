{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chawan
    w3m-full
    monolith
  ];
}
