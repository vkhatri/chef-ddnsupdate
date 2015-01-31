#
# Cookbook Name:: ddnsupdate
# Recipe:: rr
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

node['ddnsupdate']['rr'].each do |r_action, r|
  r.each do |resource_rr, resource_rr_option|
    ddnsupdate_rr resource_rr do
      type resource_rr_option['type']
      ttl resource_rr_option['ttl']
      value resource_rr_option['value']
      zone resource_rr_option['zone']
      server resource_rr_option['server'] || node['ddnsupdate']['server']
      purge resource_rr_option['purge']
      priority resource_rr_option['priority']
      ddnssec_key_file resource_rr_option['ddnssec_key_file']
      resolv_conf_file resource_rr_option['resolv_conf_file']
      action r_action
    end
  end
end
