
default[:ddnsupdate]  = {
  :zone             => nil, # forward zone
  :reverse_zone     => nil, # reverse zone, e.g. '127.in-addr.arpa'
  :server           => nil, # default looks up /etc/resolv.conf
  :host_config      => '/etc/host_nsupdate', # ddns host RR file
  :rr_config        => '/etc/rr_nsupdate', # ddns RR set file
  :host_nsupdate    => '/usr/local/bin/host_nsupdate',
  :rr_nsupdate      => '/usr/local/bin/rr_nsupdate',
  :ttl              => 60,

  :ddnssec   => {
    :databag    => nil, # read ddnssec key file attribute from data bag
    :key_file   => '/etc/nsupdate.key',
    :key_name   => 'name',
    :algo       => 'HMAC-MD5',
    :secret     => nil
  },

  :cron   => {
    :host => {
      :minute => '*/15',
      :hour   => '*',
      :user   => 'root',
      :action => nil
    }
  },

  :rr     => {
    :create   => {},
    :delete   => {},
    :update   => {}
  } # List of RR to Manage via nsupdate

}
