# Build the latest openSUSE Tumbleweed image
FROM opensuse:tumbleweed

# prefer the packages from the libyui devel project
RUN zypper ar -f -p 50 http://download.opensuse.org/repositories/devel:/libraries:/libyui/openSUSE_Factory/ libyui
RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  boost-devel \
  cmake \
  doxygen \
  fontconfig-devel \
  gcc-c++ \
  git \
  gtk3-devel \
  libyui-devel \
  libyui-ncurses-devel \
  libyui-qt-devel \
  libzypp-devel \
  obs-service-source_validator \
  pkg-config \
  'pkgconfig(Qt5Core)' \
  'pkgconfig(Qt5Gui)' \
  'pkgconfig(Qt5Svg)' \
  'pkgconfig(Qt5Widgets)' \
  'pkgconfig(Qt5X11Extras)' \
  'rubygem(libyui-rake)' \
  rpm-build \
  ruby \
  which \
  && zypper clean -a

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY libyui-travis /usr/local/bin
