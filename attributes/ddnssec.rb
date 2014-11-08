
default['ddnsupdate']['ddnssec']['manage'] = true
default['ddnsupdate']['ddnssec']['file'] = '/etc/nsupdate.key'
default['ddnsupdate']['ddnssec']['name'] = nil
default['ddnsupdate']['ddnssec']['algo'] = 'HMAC-MD5'
default['ddnsupdate']['ddnssec']['secret'] = nil
default['ddnsupdate']['ddnssec']['template_cookbook'] = 'ddnsupdate'
default['ddnsupdate']['ddnssec']['template_source'] = 'nsupdate.key.erb'
