{% set catalyst = pillar['catalyst'] %}
{% set stage3_line_path = salt['cp']['get_file_str'](catalyst.mirror_url+'/releases/amd64/autobuilds/latest-stage3-amd64'+catalyst.stage3_suffix+'-hardened.txt').split('\n')|max %}
{% set stage3_local_path = stage3_line_path.split(' ')|first|string %}
{% set stage3_tarball_name = stage3_local_path.split('/')|last|string %}
{% set stage3_stamp = stage3_tarball_name.split('-')|last|truncate(8, True, '') %}

include:
  - {{slspath}}.pkg

/var/tmp/catalyst/snapshots/portage-latest.tar.xz:
  file.managed:
    - source: {{ catalyst.mirror_url }}/snapshots/portage-latest.tar.xz
    - source_hash: {{ catalyst.mirror_url }}/releases/snapshots/current/portage-latest.tar.xz.md5sum
    - makedirs: True
    - require:
      - pkg: dev-util/catalyst

/var/tmp/catalyst/builds/hardened/{{ stage3_tarball_name }}:
  file.managed:
    - source: {{ catalyst.mirror_url }}/releases/amd64/autobuilds/{{ stage3_local_path }}
    - source_hash: {{ catalyst.mirror_url }}/releases/amd64/autobuilds/{{ stage3_local_path }}.DIGESTS
    - makedirs: True
    - require:
      - pkg: dev-util/catalyst

{% for stage_number in ['1','2'] %}
/var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage{{ stage_number }}.spec:
  file.managed:
    - source: salt://{{ slspath }}/files/specs/admincd-stage{{ stage_number }}.spec
    - template: jinja
    - defaults:
        stage3_stamp: {{ stage3_stamp }}
        snapshot_stamp: latest
        profile: {{ catalyst.profile }}
        stage3: {{ stage3_tarball_name }}
        stage3_suffix: {{ catalyst.stage3_suffix }}
    - makedirs: True
{% endfor %}

/var/tmp/catalyst/salt/config/catalystrc:
  file.managed:
    - source: salt://{{ slspath }}/files/config/catalystrc
    - template: jinja

/var/tmp/catalyst/salt/config/catalyst.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/config/catalyst.conf

/var/tmp/catalyst/salt/overlay:
  file.recurse:
    - source: salt://{{ slspath }}/files/overlay
    - makedirs: True
    - clean: True

/var/tmp/catalyst/salt/kconfig:
  file.recurse:
    - source: salt://{{ slspath }}/files/kconfig

catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run:
    - require:
      - file: /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec
      - file: /var/tmp/catalyst/salt/portage/isos
      - pkg: dev-util/catalyst
      - pkg: stage1-pkgs

catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage2.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run:
    - require:
      - pkg: stage2-pkgs
      - cmd: catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec -c /var/tmp/catalyst/salt/config/catalyst.conf

/var/tmp/catalyst/salt/portage/isos:
  file.recurse:
    - source: salt://{{ slspath }}/files/portage/isos
    - makedirs: True
    - clean: True
