#
# Cookbook Name:: ddnsupdate
# Recipe:: install
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

case node['platform_family']
when 'debian'
  package 'dnsutils'
when 'rhel'
  package 'bind-utils'
end

unless node['ddnsupdate']['no_ddnssec']
  if node['ddnsupdate']['ddnssec']['manage']
    raise "node['ddnsupdate']['ddnssec']['secret'] must be configured" unless node['ddnsupdate']['ddnssec']['secret']
    raise "node['ddnsupdate']['ddnssec']['name'] must be configured" unless node['ddnsupdate']['ddnssec']['name']
  end
end

# ddnssec key file
template node['ddnsupdate']['ddnssec']['file'] do
  mode 0o400
  owner 'root'
  group 'root'
  source node['ddnsupdate']['ddnssec']['template_source']
  only_if { (node['ddnsupdate']['ddnssec']['manage'] && !node['ddnsupdate']['no_dsec']) }
end
