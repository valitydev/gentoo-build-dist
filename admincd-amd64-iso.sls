{% import slspath+"/env.jinja" as env %}

include:
    - {{slspath}}.envsetup

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


catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run:
    - require:
      - file: /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec
      - file: /var/tmp/catalyst/salt/portage
      - pkg: dev-util/catalyst
      - pkg: stage1-pkgs

catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage2.spec -c /var/tmp/catalyst/salt/config/catalyst.conf:
  cmd.run:
    - require:
      - pkg: stage2-pkgs
      - cmd: catalyst -f /var/tmp/catalyst/salt/specs/admincd-amd64{{ catalyst.stage3_suffix }}-stage1.spec -c /var/tmp/catalyst/salt/config/catalyst.conf

