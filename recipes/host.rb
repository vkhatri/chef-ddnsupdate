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

include_recipe "ddnsupdate::install"

# Command for host nsupdate
template node.ddnsupdate.host_nsupdate do
  mode      0755
  owner     'root'
  group     'root'
  source    'host_nsupdate.erb'
  notifies  :run, 'execute[host_nsupdate]'
end

# host nsupdate config file
template node.ddnsupdate.host_config do
  mode    0655
  owner   'root'
  group   'root'
  source  'host_nsupdate_config.erb'
  variables ({
    :server   => node.ddnsupdate.server,
    :zone     => node.ddnsupdate.zone,
    :fqdn     => node.fqdn,
    :ttl      => node.ddnsupdate.ttl,
    :ptr      => "#{node.ipaddress.split('.').reverse.join('.')}.in-addr.arpa",
    :ip       => node.ipaddress,
    :reverse_zone   => node.ddnsupdate.reverse_zone
  })
  notifies  :run, 'execute[host_nsupdate]'
end

# Create / Update fqdn - ip A and PTR RR immediately
execute 'host_nsupdate' do
  cwd     '/tmp'
  command node.ddnsupdate.host_nsupdate
  action  :nothing
end

# fqdn - ip A and PTR RR cron schedule
cron_d "host_nsupdate" do
  minute      node.ddnsupdate.cron.host.minute
  hour        node.ddnsupdate.cron.host.hour
  user        node.ddnsupdate.cron.host.user
  command     node.ddnsupdate.host_nsupdate
  action      node.ddnsupdate.cron.host.action
end

