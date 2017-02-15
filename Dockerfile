# Build the latest openSUSE Tumbleweed image
FROM opensuse:tumbleweed

# prefer the packages from the libyui devel project
RUN zypper ar -f -p 50 http://download.opensuse.org/repositories/devel:/libraries:/libyui/openSUSE_Tumbleweed/ libyui

# we need to install Ruby first to define the %{rb_default_ruby_abi} RPM macro
# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#/build-cache
# why we need "zypper clean -a" at the end
RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  ruby && zypper clean -a

RUN RUBY_VERSION=`rpm --eval '%{rb_default_ruby_abi}'` \
  zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
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
  "rubygem($RUBY_VERSION:libyui-rake)" \
  rpm-build \
  which \
  && zypper clean -a

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY libyui-travis /usr/local/bin

# run some smoke tests to make sure there is no serious issue with the image
RUN c++ --version
RUN rake -r yast/rake -V
