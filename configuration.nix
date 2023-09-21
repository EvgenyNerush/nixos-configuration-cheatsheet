  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru,ge";
    xkbVariant = "";
    xkbOptions = "grp:caps_toggle,ctrl:menu_rctrl";
    # run the following command and restart Gnome to bring xkbOptions to it:
    # $ gsettings get org.gnome.desktop.input-sources xkb-options
  };

  # Define extra file systems and mount points
  fileSystems."/store" = {
    device = "/dev/sdb1";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user1 = {
    isNormalUser = true;
    uid = 1000;
    description = "Name";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      #chromium
      jetbrains.idea-community
      #visualvm
      vscode
      thunderbird
      tdesktop
      #zoom-us
      #slack
      krita
      libreoffice
      write_stylus
      gitg
      #rawtherapee
      #darktable
      #shotcut
      #transmission-gtk
      lean
      elan
      (import ./vim.nix)
    ];
  };
  users.users.user2 = {
    isNormalUser = true;
    uid = 1001;
    description = "Name";
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      my-python-packages = python-packages: with python-packages; [
        numpy
        matplotlib
        ipython
        pandas
        plotly
        scipy
        markdown
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in [
      vim
      git
      htop
      imagemagick
      ffmpeg
      pdftk
      ntfs3g
      texlive.combined.scheme-full
      python-with-my-packages
      gcc
      gdb
      gnumake
      cmake
      clang
      rustc
      cargo
      zig
      jdk
      sbt
      scala
      clojure
      ghc
      stack
      cabal-install
      #openmpi
      #hdf5
      #doxygen
      #gnomeExtensions.wireguard-vpn-extension
    ];

    fonts.fonts = with pkgs; [
      libertine
      fira-code
      jetbrains-mono
      martian-mono
    ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  # for wireguard
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  services.dbus.packages = [ pkgs.networkmanager pkgs.strongswanNM ];
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager_strongswan ];
  };

