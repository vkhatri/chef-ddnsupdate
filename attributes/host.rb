
default['ddnsupdate']['host']['manage'] = true

default['ddnsupdate']['host']['cron']['minute'] = '*/15'
default['ddnsupdate']['host']['cron']['hour'] = '*'
default['ddnsupdate']['host']['cron']['user'] = 'root'
default['ddnsupdate']['host']['cron']['action'] = 'create'
default['ddnsupdate']['host']['zone'] = node.attribute?('domain') ? node['domain'] : nil # not always set
default['ddnsupdate']['host']['auto_fqdn_zone'] = true
default['ddnsupdate']['host']['reverse_zone'] = nil
default['ddnsupdate']['host']['config'] = '/etc/nsupdate' # ddns host RR file
default['ddnsupdate']['host']['nsupdate_bin'] = '/usr/local/bin/host_nsupdate'
