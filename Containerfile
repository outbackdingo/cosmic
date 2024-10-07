ARG SOURCE_IMAGE="${SOURCE_IMAGE:-base-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ghcr.io/ublue-os}"
ARG BASE_IMAGE="${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

# Build in one step
RUN if [[ "${FEDORA_MAJOR_VERSION}" == "rawhide" ]]; then \
        curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
            https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-rawhide/ryanabx-cosmic-epoch-fedora-rawhide.repo \
    ; else curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
            https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo \
           && curl -Lo /etc/yum.repos.d/cloudflared-ascii.repo \
            https://pkg.cloudflare.com/cloudflared-ascii.repo \
    ; fi && \
    rpm-ostree install \
        cosmic-desktop \
        power-profiles-daemon gnome-keyring NetworkManager-tui NetworkManager-openvpn fontawesome-fonts powerline vim-powerline tmux-powerline powerline-fonts zsh \
        fish elvish lsd mc restic fastfetch telegram-desktop openvpn wireguard-tools kubernetes-client go rust nmap cloudflared bzip2 gcc gcc-c++ make ncurses-devel && \
    rpm-ostree install \
         minicom patch npm minicom rsync tar unzip wget which diffutils python3 && \
    rpm-ostree install \
        fontawesome-fonts powerline vim-powerline tmux-powerline powerline-fonts zsh mc restic fastfetch openvpn wireguard-tools kubernetes-client go rust nmap && \
   # rpm-ostree install \
   #     bzip2 gcc gcc-c++ make ncurses-devel patch rsync tar unzip wget which diffutils python3 perl-base re2c libreoffice nodejs npm minicom && \
   # libreoffice virt-viewer virt-manager virt-install nodejs npm minicom && \
    systemctl disable gdm || true && \
    systemctl disable sddm || true && \
    systemctl enable cosmic-greeter && \
    systemctl enable power-profiles-daemon && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
