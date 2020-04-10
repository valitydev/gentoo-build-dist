# gentoo-build-dist

Build latest version of admin ISO and stage4.

### Differences from official admin ISO:

- `SaltStack`, `Stratis storage` packages included.
- `sshd`, `stratisd`, `dbus` services added to default runlevel.

### Stage4 differences from official stage3:
- `dev-libs/openssl` replaced with `dev-libs/libressl`;
- Removed `dev-lang/python:2.7`
- Included some commonly used packages like: `SaltStack`, `Stratis storage`.

