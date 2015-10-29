
default['ddnsupdate']['server'] = nil # default looks up /etc/resolv.conf
default['ddnsupdate']['use_resolv_conf'] = false # use first dns server entry from /etc/resolv.conf
default['ddnsupdate']['ttl'] = 300 # default ttl
default['ddnsupdate']['no_ddnssec'] = false # default zone access is controlled by dsec

default['ddnsupdate']['rr']['create'] = {}
default['ddnsupdate']['rr']['delete'] = {}

# These attributes are set by cookbook.
default['ddnsupdate']['resolv_conf']['nameservers'] = []
default['ddnsupdate']['resolv_conf']['domain'] = nil
default['ddnsupdate']['resolv_conf']['search'] = []
