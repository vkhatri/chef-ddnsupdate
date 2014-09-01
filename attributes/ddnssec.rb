
default[:ddnsupdate][:ddnssec]   = {
  :manage     => true,
  :file   => '/etc/nsupdate.key',
  :name   => nil,
  :algo       => 'HMAC-MD5',
  :secret     => nil,
  :template_cookbook  => 'ddnsupdate',
  :template_source    => 'nsupdate.key.erb'
}
