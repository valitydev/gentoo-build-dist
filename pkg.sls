dev-util/catalyst:
  pkg.installed

stage1-pkgs:
  pkg.installed:
    - pkgs:
      - app-arch/pixz

stage2-pkgs:
  pkg.installed:
    - pkgs:
      - sys-boot/grub
      - sys-boot/shim
