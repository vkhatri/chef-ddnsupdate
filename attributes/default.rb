
default[:ddnsupdate]  = {
  :zone             => nil, # forward zone
  :reverse_zone     => nil, # reverse zone, e.g. '127.in-addr.arpa'
  :server           => nil, # default looks up /etc/resolv.conf
  :host_config      => '/etc/nsupdate', # ddns host RR file
  :rr_config        => '/etc/rrnsupdate', # ddns RR set file
  :host_nsupdate    => '/usr/local/bin/host_nsupdate',
  :rr_nsupdate      => '/usr/local/bin/rr_nsupdate',
  :ttl              => 300,

  :ddnssec   => {
    :databag    => nil, # read ddnssec key file attribute from data bag
    :manage     => true,
    :key_file   => '/etc/nsupdate.key',
    :key_name   => nil,
    :algo       => 'HMAC-MD5',
    :secret     => nil,
    :template_cookbook  => 'ddnsupdate',
    :template_source    => 'nsupdate.key.erb'
  },

  :cron   => {
    :host => {
      :minute => '*/15',
      :hour   => '*',
      :user   => 'root',
      :action => 'create'
    }
  },

  :rr     => {
    :create   => {},
    :delete   => {},
    :update   => {}
  } # List of RR to Manage via nsupdate

}
