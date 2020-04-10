{% import slspath+"/env.jinja" as env %}

include:
  - {{slspath}}.envsetup

{% for stage_type in ['libressl-selinux-nomultilib-transitional','libressl-selinux-nomultilib-final'] %}
/var/tmp/catalyst/salt/specs/hardened/stage4-{{ stage_type }}.spec:
  file.managed:
    - source: salt://{{ slspath }}/files/specs/hardened/stage4-{{ stage_type }}.spec
    - template: jinja
    - defaults:
        stage3_stamp: {{ env.stage3_stamp }}
        snapshot_stamp: latest
        profile: {{ env.catalyst.profile }}
        stage3: {{ env.stage3_tarball_name }}
        stage3_suffix: {{ env.catalyst.stage3_suffix }}
    - makedirs: True
{% endfor %}


catalyst -f /var/tmp/catalyst/salt/specs/hardened/stage4-libressl-selinux-nomultilib-transitional.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run:
      - require:
          - file: /var/tmp/catalyst/salt/specs/hardened/stage4-libressl-selinux-nomultilib-transitional.spec
          - file: /var/tmp/catalyst/salt/portage
          - file: /var/tmp/catalyst/salt/scripts
          - git: /var/tmp/catalyst/salt/overlay
          - pkg: dev-util/catalyst

catalyst -f /var/tmp/catalyst/salt/specs/hardened/stage4-libressl-selinux-nomultilib-final.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run: 
      - require:
          - cmd: catalyst -f /var/tmp/catalyst/salt/specs/hardened/stage4-libressl-selinux-nomultilib-transitional.spec -c /var/tmp/catalyst/salt/config/catalyst.conf
