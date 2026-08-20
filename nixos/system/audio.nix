{ config, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = config.services.pipewire.enable;
  };

  hardware.alsa.enable = false;
}
