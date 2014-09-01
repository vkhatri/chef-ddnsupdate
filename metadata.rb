name             'ddnsupdate'
maintainer       'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures nsupdate to manage host dynamic dns and other RR'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends 'cron', '>= 1.2.0'

%w{ubuntu centos redhat fedora amazon}.each do |os|
  supports os
end

