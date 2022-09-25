  # Configure keymap in X11
  services.xserver.layout = "us,ru";
  services.xserver.xkbOptions = "grp:caps_toggle,ctrl:menu_rctrl";

  # List packages installed in system profile.
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
      htop
      git
      gcc
      gdb
      rustc
      cargo
      python-with-my-packages
      stack
      texlive.combined.scheme-full
      gnumake
      cmake
      openmpi
      hdf5
      doxygen
      python38Packages.markdown
      jetbrains.idea-community
      jdk
      kotlin
      sbt
      clang
      gradle
      libertine
      gitg
      firefox
      #torbrowser
      thunderbird
      tdesktop
      zoom-us
      libreoffice
      transmission-gtk
      ntfs3g
      write_stylus
      krita
      rawtherapee
      imagemagick
      pdftk
      darktable
      ffmpeg
      shotcut
    ];

  # List services that you want to enable:
  services.dbus.packages = [ pkgs.networkmanager pkgs.strongswanNM ];
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager_strongswan ];
  };

