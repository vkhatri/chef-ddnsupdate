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

include_recipe "ddnsupdate::install"

node.ddnsupdate.rr.each do |_resource, _resource_option|
  ddnsupdate_rr _resource do
    type    _resource_option[:type]
    ttl     _resource_option[:ttl]
    value   _resource_option[:value]
    zone    _resource_option[:zone]   ||  node.ddnsupdate.zone
    server  _resource_option[:server] ||  node.ddnsupdate.server
    ddnssec_key_file  _resource_option[:ddnssec_key_file] || node.ddnsupdate.ddnssec.key_file
    action  _resource_option[:action] || :create
  end
end
