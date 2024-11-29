Name:           Fruitendo
Version:        1.19.1
Release:        v1.19.1
Summary:        Official reference frontend for libretro

Group:          Applications/Emulators
License:        GPLv3+
URL:            https://www.libretro.com/

BuildRequires:  mesa-llvmpipe-libwayland-egl-devel
BuildRequires:  pulseaudio-devel
BuildRequires:  OpenAL-devel
BuildRequires:  libxkbcommon-devel
BuildRequires:  zlib-devel
BuildRequires:  freetype-devel
#BuildRequires:  ffmpeg-devel
BuildRequires:  SDL2-devel
BuildRequires:  SDL2_image-devel
#Requires libusb 1.0.16
#BuildRequires:  libusb-devel

%description
Fruitendo is the official reference frontend for the libretro API.
Libretro is a simple but powerful development interface that allows for the
easy creation of emulators, games and multimedia applications that can plug
straight into any libretro-compatible frontend. This development interface
is open to others so that they can run these pluggable emulator and game
cores also in their own programs or devices.

%build
# No autotools, custom configure script
%ifarch armv7hl
./configure --prefix=%{_prefix} --enable-opengles --enable-neon --enable-egl --enable-wayland
%else
./configure --prefix=%{_prefix} --enable-opengles
%endif
make %{?_smp_mflags}


%install
make install DESTDIR=%{buildroot}
# Configuration changes
sed -i \
  's|^# libretro_directory =.*|libretro_directory = "~/.config/Fruitendo/cores/"|;
   s|^# libretro_info_path =.*|libretro_info_path = "~/.config/Fruitendo/cores/"|;
   s|^# joypad_autoconfig_dir =.*|joypad_autoconfig_dir = "/etc/Fruitendo/joypad"|;
   s|^# video_fullscreen =.*|video_fullscreen = "true"|;
   s|^# menu_driver =.*|menu_driver = "glui"|;
   s|^# menu_pointer_enable =.*|menu_pointer_enable = "true"|;
   s|^# input_driver =.*|input_driver = "wayland"|' \
  %{buildroot}/etc/Fruitendo.cfg

%ifarch armv7hl
sed -i \
  's|^# core_updater_buildbot_url =.*|core_updater_buildbot_url = "http://buildbot.libretro.com/nightly/linux/armhf/latest/"|;' \
  %{buildroot}/etc/Fruitendo.cfg
%endif

#Disabling audio till it's fixed
sed -i \
   's|^# audio_enable.*|audio_enable = "false"|' \
  %{buildroot}/etc/Fruitendo.cfg

sed -i \
  's|^Exec=Fruitendo|Exec=Fruitendo --menu|' \
  %{buildroot}/usr/share/applications/com.libretro.Fruitendo.desktop

  # Install icon file in the correct place
  mkdir -p %{buildroot}/usr/share/icons/hicolor/86x86/apps
  install -m 644 "./media/Fruitendo-96x96.png" "%{buildroot}/usr/share/icons/hicolor/86x86/apps/Fruitendo.png"
  rm "%{buildroot}/usr/share/pixmaps/com.libretro.Fruitendo.svg"
  rmdir "%{buildroot}/usr/share/pixmaps"

%files
%doc README.md
%config /etc/Fruitendo.cfg
%{_prefix}/bin/Fruitendo
%{_prefix}/share/applications/com.libretro.Fruitendo.desktop
%{_prefix}/share/man/man6/*.6*
%{_prefix}/share/icons/hicolor/86x86/apps/Fruitendo.*
%{_prefix}/share/doc/Fruitendo/*
%changelog
