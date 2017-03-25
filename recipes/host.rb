#
# Cookbook Name:: ddnsupdate
# Recipe:: host
#
# Copyright 2014, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ddnsupdate::default'
include_recipe 'ddnsupdate::install'

raise "node['ddnsupdate']['host']['reverse_zone'] must be configured" unless node['ddnsupdate']['host']['reverse_zone']
raise "need at least node['ddnsupdate']['host']['auto_fqdn_zone'] or node['ddnsupdate']['host']['zone'] to configure host" \
  if !node['ddnsupdate']['host']['auto_fqdn_zone'] && !node['ddnsupdate']['host']['zone']

# Command for host nsupdate
template node['ddnsupdate']['host']['nsupdate_bin'] do
  mode 0o755
  owner 'root'
  group 'root'
  source 'host_nsupdate.erb'
  notifies :run, 'execute[host_nsupdate]'
  only_if { !node['ddnsupdate']['no_ddnssec'] }
end

# Command for host nsupdate
template node['ddnsupdate']['host']['nsupdate_bin'] do
  mode 0o755
  owner 'root'
  group 'root'
  source 'host_nsupdate_nodsec.erb'
  notifies :run, 'execute[host_nsupdate]'
  only_if { node['ddnsupdate']['no_ddnssec'] }
end

node_domain = node['ddnsupdate']['host']['auto_fqdn_zone'] && node['domain'] ? node['domain'] : node['ddnsupdate']['host']['zone']
node_fqdn = node['ddnsupdate']['host']['auto_fqdn_zone'] && node['fqdn'] ? node['fqdn'] : (node['hostname'] + '.' + node['ddnsupdate']['host']['zone'])

Chef::Log.warn('unable to determine node fqdn') unless node_fqdn
Chef::Log.warn('unable to determine node domain / zone') unless node_domain

# host nsupdate config file
template node['ddnsupdate']['host']['config'] do
  mode 0o655
  owner 'root'
  group 'root'
  source 'host_nsupdate_config.erb'
  variables(:server   => node['ddnsupdate']['server'],
            :zone     => node_domain,
            :fqdn     => node_fqdn,
            :ttl      => node['ddnsupdate']['ttl'],
            :ptr      => "#{node['ipaddress'].split('.').reverse.join('.')}.in-addr.arpa",
            :ip       => node['ipaddress'],
            :reverse_zone => node['ddnsupdate']['host']['reverse_zone'])
  notifies :run, 'execute[host_nsupdate]'
end

# Create / Update fqdn - ip A and PTR RR immediately
execute 'host_nsupdate' do
  cwd '/tmp'
  command node['ddnsupdate']['host']['nsupdate_bin']
  only_if { node['ddnsupdate']['host']['manage'] }
  action :nothing
end

# fqdn - ip A and PTR RR cron schedule
cron_d 'host_nsupdate' do
  minute node['ddnsupdate']['host']['cron']['minute']
  hour node['ddnsupdate']['host']['cron']['hour']
  user node['ddnsupdate']['host']['cron']['user']
  command node['ddnsupdate']['host']['nsupdate_bin']
  action node['ddnsupdate']['host']['cron']['action']
  only_if { node['ddnsupdate']['host']['manage'] }
end
