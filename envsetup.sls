{% import slspath+"/env.jinja" as env %}

include:
  - {{slspath}}.pkg

/var/tmp/catalyst/snapshots/portage-latest.tar.xz:
  file.managed:
    - source: {{ env.catalyst.mirror_url }}/snapshots/portage-latest.tar.xz
    - source_hash: {{ env.catalyst.mirror_url }}/releases/snapshots/current/portage-latest.tar.xz.md5sum
    - makedirs: True
    - require:
      - pkg: dev-util/catalyst

/var/tmp/catalyst/builds/hardened/{{ env.stage3_tarball_name }}:
  file.managed:
    - source: {{ env.catalyst.mirror_url }}/releases/amd64/autobuilds/{{ env.stage3_local_path }}
    - source_hash: {{ env.catalyst.mirror_url }}/releases/amd64/autobuilds/{{ env.stage3_local_path }}.DIGESTS
    - makedirs: True
    - require:
      - pkg: dev-util/catalyst

/var/tmp/catalyst/salt/config/catalystrc:
  file.managed:
    - source: salt://{{ slspath }}/files/config/catalystrc
    - template: jinja

/var/tmp/catalyst/salt/config/catalyst.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/config/catalyst.conf

/var/tmp/catalyst/salt/overlay:
  git.latest:
    - name: {{ env.catalyst.overlay_url }}
    - target: /var/tmp/catalyst/salt/overlay
    - depth: 1
    - rev: master
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - force_checkout: True

/var/tmp/catalyst/salt/kconfig:
  file.recurse:
    - source: salt://{{ slspath }}/files/kconfig

/var/tmp/catalyst/salt/portage:
  file.recurse:
    - source: salt://{{ slspath }}/files/portage
    - makedirs: True
    - clean: True

/var/tmp/catalyst/salt/scripts:
  file.recurse:
    - source: salt://{{ slspath }}/files/scripts
    - makedirs: True
    - clean: True
