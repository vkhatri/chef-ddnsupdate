
default[:ddnsupdate][:host] = {
  :cron => {
    :minute => '*/15',
    :hour   => '*',
    :user   => 'root',
    :action => 'create'
  },
  :zone     => node.domain,
  :auto_fqdn_zone   => true,
  :reverse_zone     => nil,
  :config           => '/etc/nsupdate', # ddns host RR file
  :nsupdate_bin     => '/usr/local/bin/host_nsupdate'
}


