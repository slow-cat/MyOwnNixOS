# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  config,
  pkgs,
  ...
}:

let
  host =
    if builtins.pathExists ./modules/host.nix then import ./modules/host.nix else { isQemu = false; };

  cliPackages = with pkgs; [
    wget
    wget2
    aria2
    curl

    file
    tree
    lsof
    pciutils
    usbutils
    inetutils
    zip
    unzip

    nix-zsh-completions
    nix-index
    nix-tree
    nix-doc
    nix-output-monitor
    nix-direnv
    nh

    fd
    sd
    ripgrep
    dash
  ];
  hardwarePackages = with pkgs; [
    acpi
    brightnessctl
    fastfetch
    evtest
    alsa-utils
  ];
  webPackages = with pkgs; [
    chawan
    w3m-full
    monolith

  ];
  mediaPackages = with pkgs; [
    ffmpeg
    lilypond
    fluidsynth
    soundfont-fluid
    (pkgs.writeScriptBin "fluids" ''
      exec ${pkgs.fluidsynth}/bin/fluidsynth "$@" ${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM*.sf2
    '')
    typst
  ];
  lspPackages = with pkgs; [
    nixd
    clang-tools
    jdt-language-server
    ruff
    ty
    typos-lsp
    texlab
    tinymist
    taplo
  ];
  developmentPackages = with pkgs; [
    nixfmt
    uv
    rustup
    strace
  ];
  officePackages = with pkgs; [
    himalaya
    wf-wf-recorder
    wl-wl-mirror
    apostrophe
    pympress
    freerdp
  ];
  educationalPackages = with pkgs; [
    proverif
    spin
    silicon
  ];
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/stylix.nix
    ./modules/ironbar.nix
    ./modules/niri.nix
    ./modules/vale.nix
    ./home/home.nix
  ];

  # Use then GRUB 2 boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = if host.isQemu then [ "console=ttyS0,115200n8" ] else [ ];
    loader.timeout = if host.isQemu then 0 else 5;
    loader.grub = {
      enable = true;
      efiSupport = false;
      devices = [ "/dev/sda" ];
    };
  };
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true;
  };
  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-p24b";
    packages = [ pkgs.terminus_font ];
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver.xkb.layout = "jp";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = config.services.pipewire.enable;
  };
  hardware.alsa.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moamoa = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "audio"
    ]; # Enable ‘sudo’ for the user.
    initialPassword = "moamoa";
    shell = pkgs.zsh;
  };


  environment.systemPackages =
    (cliPackages ++ hardwarePackages ++ webPackages ++ mediaPackages ++ lspPackages)
    ++ lib.optionals (!host.isQemu) (developmentPackages ++ officePackages ++ educationalPackages);

  # Keep Zsh registered as a valid login shell. User configuration is in Home Manager.
  programs.zsh = {
    enable = true;
    # Set this in /etc/zshenv, before Zsh searches for the user's startup files.
    shellInit = ''
      if [[ $USER == moamoa ]]; then
        export ZDOTDIR="$HOME/.config/zsh"
      fi
    '';
  };

  zramSwap = {
    enable = !host.isQemu;
    memoryPercent = 100;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # QEMU user networking forwards host port 60022 to this SSH service.
  services.openssh = {
    enable = host.isQemu;
    openFirewall = host.isQemu;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

  fileSystems."/etc/nixos" = lib.mkIf host.isQemu{
    device = "nixos";
    fsType = "9p";
    options = [
      "trans=virtio"
      "rw"
    ];
  };

}
