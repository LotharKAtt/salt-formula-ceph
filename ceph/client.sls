{%- from "ceph/map.jinja" import client with context %}
{%- if client.enabled %}

{%- for keyring_name, keyring in client.keyring.iteritems() %}

/etc/ceph/ceph.client.{{ keyring_name }}.keyring:
  ini.options_present:
  - sections:
      client.{{ keyring_name }}: {{ keyring|yaml }}

{%- endfor %}

{%- load_yaml as config %}
{{ client.config|yaml }}
{%- for keyring_name, keyring in client.keyring.iteritems() %}
client.{{ keyring_name }}:
  keyring: /etc/ceph/ceph.client.{{ keyring_name }}.keyring
{%- endfor %}
{%- endload %}

/etc/ceph/ceph.conf:
  ini.options_present:
  - sections: {{ config|yaml }}

{%- endif %}