{ pkgs, ... }:
{
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    # intel-ocl
    intel-compute-runtime-legacy1
  ];
  # hardware.graphics.enable = true;
  # hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    clinfo
    vulkan-tools
    intel-gpu-tools
  ];
}
