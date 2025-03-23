#!/bin/bash
checks() {
  set -e
  # shellcheck disable=SC1091
  # shellcheck disable=SC2154
  # shellcheck disable=SC1090
  # shellcheck disable=SC1073
  clear
  #
  red
  echo "> $(white)Core$(nocolor)"
  #
  cyan
  echo -e OS_RELEASE="$(grep PRETTY_NAME /etc/os-release | grep -o -P '(?<=").*(?=")')"
  nocolor
  cyan
  echo -e UP_TIME="$(uptime -p)"
  nocolor
  cyan
  echo -e SHELL_VERSION="$($SHELL --version)"
  nocolor
  echo ""
  if command -v apt &>/dev/null; then
    green
    echo "This system uses APT (Debian/Ubuntu-based)."
    nocolor
  elif command -v dnf &>/dev/null; then
    green
    echo "This system uses DNF (Fedora-based)."
    nocolor
  elif command -v yum &>/dev/null; then
    green
    echo "This system uses YUM (RHEL-based)."
    nocolor
  elif command -v pacman &>/dev/null; then
    green
    echo "This system uses PACMAN (Arch-based)."
    nocolor
  else
    red
    echo "No recognized package manager found."
    nocolor
  fi
  echo ""
  #
  red
  echo "> $(white)Additional system configs: $(nocolor)"
  # cups
  if [ "$(dpkg -l cups 2>/dev/null | grep -i "ii" | awk '{ printf $2}')" = "cups" ]; then
    yellow
    echo "cups found"
    nocolor
  else
    green
    echo "cups not found"
    nocolor
  fi
  #
  # IPv6
  if [ "$(ifconfig -a | grep -i inet6 | head -1 | awk '{ printf $1}')" = "inet6" ]; then
    yellow
    echo "inet6 found"
    nocolor
  else
    green
    echo "inet6 not found"
    nocolor
  fi
  #
  # snapd
  if [ "$(dpkg -l snapd 2>/dev/null | grep -i "ii" | awk '{ printf $2}')" = "snapd" ]; then
    yellow
    echo "snapd found"
    nocolor
  else
    green
    echo "snapd not found"
    nocolor
  fi
  #
  # rsyslog
  if [ "$(dpkg -l rsyslog 2>/dev/null | grep -i "ii" | awk '{ printf $2}')" = "rsyslog" ]; then
    green
    echo "rsyslog found"
    nocolor
  else
    yellow
    echo "rsyslog not found"
    nocolor
  fi
  #
  # bash-completion
  if [ "$(dpkg -l bash-completion 2>/dev/null | grep -i "ii" | awk '{ printf $2}')" = "bash-completion" ]; then
    green
    echo "bash-completion found"
    nocolor
  else
    red
    echo "bash-completion not found"
    nocolor
  fi
  #
  # Shells
  contenido=$(wc -l /etc/shells | awk '{printf $1}')
  resultado=$((contenido - 1))
  cyan
  echo "$resultado" "shell(s) available"
  nocolor
  echo ""
  red
  echo "> $(white)Required system packages: $(nocolor)"
  # git
  if ! command -v git &>/dev/null; then
    red
    echo "git not found"
    nocolor
  else
    green
    echo "git found"
    nocolor
  fi
  #
  # powershell
  if ! command -v pwsh &>/dev/null; then
    red
    echo "pwsh not found"
    nocolor
  else
    green
    echo "pwsh found"
    nocolor
  fi
  #
  # openssl
  if ! command -v openssl &>/dev/null; then
    red
    echo "openssl not found"
    nocolor
  else
    green
    echo "openssl found"
    nocolor
  fi
  #
  # curl
  if ! command -v curl &>/dev/null; then
    red
    echo "curl not found"
    nocolor
  else
    green
    echo "curl found"
    nocolor
  fi
  # ca-certificates
  if command -v apt &>/dev/null; then
    if dpkg -l | grep -q ca-certificates; then
      green
      echo "ca-certificates found"
      nocolor
    else
      red
      echo "ca-certificates not found"
      nocolor
    fi
  elif command -v dnf &>/dev/null; then
    if dnf list installed ca-certificates &>/dev/null; then
      green
      echo "ca-certificates found"
      nocolor
    else
      red
      echo "ca-certificates not found"
      nocolor
    fi
  elif command -v yum &>/dev/null; then
    if yum list installed ca-certificates &>/dev/null; then
      green
      echo "ca-certificates found"
      nocolor
    else
      red
      echo "ca-certificates not found"
      nocolor
    fi
  elif command -v pacman &>/dev/null; then
    if pacman -Q ca-certificates &>/dev/null; then
      green
      echo "ca-certificates found"
      nocolor
    else
      red
      echo "ca-certificates not found"
      nocolor
    fi
  else
    red
    echo "Package manager not found. This script supports apt, dnf, yum, and pacman."
    nocolor
  fi
  # build-essential
  if command -v apt &>/dev/null; then
    if dpkg -l | grep -q build-essential; then
      green
      echo "build-essential found"
      nocolor
    else
      red
      echo "build-essential not found"
      nocolor
    fi
  elif command -v dnf &>/dev/null; then
    if dnf group list installed "Development Tools" | grep -q "Development Tools"; then
      green
      echo "build-essential found"
      nocolor
    else
      red
      echo "build-essential not found"
      nocolor
    fi
  elif command -v yum &>/dev/null; then
    if yum group list installed "Development Tools" | grep -q "Development Tools"; then
      green
      echo "build-essential found"
      nocolor
    else
      red
      echo "build-essential not found"
      nocolor
    fi
  elif command -v pacman &>/dev/null; then
    if pacman -Q build-essential &>/dev/null; then
      green
      echo "build-essential found"
      nocolor
    else
      red
      echo "build-essential not found"
      nocolor
    fi
  else
    red
    echo "No recognized package manager found."
    nocolor
  fi
  #
  echo ""
  red
  echo "> $(white)Automated install: $(nocolor)"
  # brew
  if [ "$(basename "$(which brew)")" = "brew" ]; then
    green
    echo "brew found"
    nocolor
  else
    red
    echo "brew not found"
    nocolor
  fi
  #
  # aws
  if ! command -v aws &>/dev/null; then
    red
    echo "aws not found"
    nocolor
  else
    green
    echo "aws found"
    nocolor
  fi
  #
  # gcloud
  if ! command -v gcloud &>/dev/null; then
    red
    echo "gcloud not found"
    nocolor
  else
    green
    echo "gcloud found"
    nocolor
  fi
  #
  # pip
  if ! command -v pip &>/dev/null; then
    red
    echo "pip not found"
    nocolor
  else
    green
    echo "pip found"
    nocolor
  fi
  #
  # bw
  if [ -f "$HOME/.bitwarden/bw" ]; then
    green
    echo "bw found"
    nocolor
  else
    red
    echo "bw not found"
    nocolor
  fi
  #
  echo ""
  red
  echo ">" "$(white)" "Brew packages:" "$(nocolor)"
  if ! command -v shellcheck &>/dev/null; then
    red
    echo "shellcheck not found"
    nocolor
  else
    green
    echo "shellcheck found"
    nocolor
  fi
  # yamlfmt
  if ! command -v yamlfmt &>/dev/null; then
    red
    echo "yamlfmt not found"
    nocolor
  else
    green
    echo "yamlfmt found"
    nocolor
  fi
  # hadolint
  if ! command -v hadolint &>/dev/null; then
    red
    echo "hadolint not found"
    nocolor
  else
    green
    echo "hadolint found"
    nocolor
  fi
  # dos2unix
  if ! command -v dos2unix &>/dev/null; then
    red
    echo "dos2unix not found"
    nocolor
  else
    green
    echo "dos2unix found"
    nocolor
  fi
  # shfmt
  if ! command -v shfmt &>/dev/null; then
    red
    echo "shfmt not found"
    nocolor
  else
    green
    echo "shfmt found"
    nocolor
  fi
  # gh
  if ! command -v gh &>/dev/null; then
    red
    echo "gh not found"
    nocolor
  else
    green
    echo "gh found"
    nocolor
  fi
  #
  # unzip
  if ! command -v unzip &>/dev/null; then
    red
    echo "unzip not found"
    nocolor
  else
    green
    echo "unzip found"
    nocolor
  fi
  #
  # kubectl
  if ! command -v kubectl &>/dev/null; then
    red
    echo "kubectl not found"
    nocolor
  else
    green
    echo "kubectl found"
    nocolor
  fi
  #
  # python-tk
  if [ "$(brew list | grep python-tk | awk -F@ '{print $1}' 2>/dev/null)" = "python-tk" ]; then
    green
    echo "python-tk found"
    nocolor
  else
    red
    echo "python-tk not found"
    nocolor
  fi
  #
  # pyenv
  if [ "$(brew list | grep -m 1 -o pyenv 2>/dev/null)" = "pyenv" ]; then
    green
    echo "pyenv found"
    nocolor
  else
    red
    echo "pyenv not found"
    nocolor
  fi
  # pyenv-virtualenv
  if [ "$(brew list | grep pyenv-virtualenv 2>/dev/null)" = "pyenv-virtualenv" ]; then
    green
    echo "pyenv-virtualenv found"
    nocolor
  else
    red
    echo "pyenv-virtualenv not found"
    nocolor
  fi
  #
  # docker
  if ! command -v docker &>/dev/null; then
    red
    echo "docker not found"
    nocolor
  else
    green
    echo "docker found"
    nocolor
  fi
  #
  # yq
  if ! command -v yq &>/dev/null; then
    red
    echo "yq not found"
    nocolor
  else
    green
    echo "yq found"
    nocolor
  fi
  #
  # jq
  if ! command -v jq &>/dev/null; then
    red
    echo "jq not found"
    nocolor
  else
    green
    echo "jq found"
    nocolor
  fi
  #
  # john
  if ! command -v john &>/dev/null; then
    red
    echo "john not found"
    nocolor
  else
    green
    echo "john found"
    nocolor
  fi
  #
  # terraform
  if ! command -v terraform &>/dev/null; then
    red
    echo "terraform not found"
    nocolor
  else
    green
    echo "terraform found"
    nocolor
  fi
  #
  # terraformer
  if ! command -v terraformer &>/dev/null; then
    red
    echo "terraformer not found"
    nocolor
  else
    green
    echo "terraformer found"
    nocolor
  fi
  #
  # az
  if ! command -v az &>/dev/null; then
    red
    echo "az not found"
    nocolor
  else
    green
    echo "az found"
    nocolor
  fi
  #
  # yt-dlp
  if ! command -v yt-dlp &>/dev/null; then
    cyan
    echo "yt-dlp not found"
    nocolor
  else
    green
    echo "yt-dlp found"
    nocolor
  fi
}
export checks