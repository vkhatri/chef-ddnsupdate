#
# Cookbook Name:: ddnsupdate
# Recipe:: default
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

temp_resolv_conf = DDNSUpdate.resolv_conf

node.default['ddnsupdate']['resolv_conf']['nameservers'] = temp_resolv_conf[:nameservers].first
node.default['ddnsupdate']['resolv_conf']['search'] = temp_resolv_conf[:search].first
node.default['ddnsupdate']['resolv_conf']['domain'] = if temp_resolv_conf[:domain]
                                                        temp_resolv_conf[:domain]
                                                      else
                                                        temp_resolv_conf[:search]
                                                      end

node.default['ddnsupdate']['server'] = node['ddnsupdate']['resolv_conf']['nameservers'] if node['ddnsupdate']['use_resolv_conf']

raise "node['ddnsupdate']['server'] must be configured or enable node['ddnsupdate']['use_resolv_conf']" unless node['ddnsupdate']['server']
