name 'ddnsupdate'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures nsupdate to manage host dynamic dns and other RR'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.1'
source_url 'https://github.com/vkhatri/chef-ddnsupdate/'
issues_url 'https://github.com/vkhatri/chef-ddnsupdate/issues'

depends 'cron', '>= 1.2.0'

supports 'ubuntu', '>=12.04'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'amazon', '>= 6.0'
supports 'fedora'
