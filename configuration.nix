  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru,ge";
    xkbVariant = "";
    xkbOptions = "grp:caps_toggle";
    # run the following command and restart Gnome to bring xkbOptions to it:
    # $ gsettings get org.gnome.desktop.input-sources xkb-options
  };

  # Define extra file systems and mount points
  fileSystems."/store" = {
    device = "/dev/sdb1";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user1 = {
    isNormalUser = true;
    uid = 1000;
    description = "Name";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      jetbrains.idea-community
      thunderbird
      tdesktop
      zoom-us
      krita
      libreoffice
      write_stylus
      gitg
      #rawtherapee
      #darktable
      #shotcut
      #transmission-gtk
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
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in [
      vim
      git
      htop
      imagemagick
      ffmpeg
      pdftk
      python310Packages.markdown
      libertine
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
      stack
      jdk
      sbt
      scala
      openmpi
      hdf5
      doxygen
    ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;

  # List services that you want to enable:
  services.dbus.packages = [ pkgs.networkmanager pkgs.strongswanNM ];
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager_strongswan ];
  };

