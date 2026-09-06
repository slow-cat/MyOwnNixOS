{ pkgs, ... }:
{
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    # intel-ocl
    intel-compute-runtime-legacy1
  ];
  environment.systemPackages = with pkgs; [
    clinfo
    vulkan-tools
    intel-gpu-tools
  ];
}
