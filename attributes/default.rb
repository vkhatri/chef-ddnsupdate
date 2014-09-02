
default[:ddnsupdate]  = {
  :server           => nil, # default looks up /etc/resolv.conf
  :use_resolv_conf  => false, # use first dns server entry from /etc/resolv.conf
  :ttl              => 300, # default ttl

  :rr     => {
    :create   => {},
    :delete   => {}
  },

# These attributes are set by cookbook.
  :resolv_conf  => {
    :nameservers  => [],
    :domain       => nil,
    :search       => []
  }

}

