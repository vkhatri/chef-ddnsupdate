#
# Cookbook Name:: ddnsupdate
# Resource:: rr
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

require 'resolv'

actions :create, :delete

default_action :create

attribute :type,        :kind_of => String, :regex => /a|ptr|cname|mx/i, :required => true, :default => nil
attribute :ttl,         :kind_of => [String, Integer], :regex => /.*/, :default => node['ddnsupdate']['ttl']
attribute :purge,       :kind_of => [TrueClass, FalseClass], :default => false
attribute :value,       :kind_of => Array,  :required => true, :default => []
attribute :zone,        :kind_of => String, :regex => /.*/, :required => true, :default => nil
attribute :server,      :kind_of => String, :regex => Resolv::IPv4::Regex, :default => node['ddnsupdate']['server']
attribute :priority,    :kind_of => [String, Integer], :regex => /.*/, :default => 10
attribute :ddnssec_key_file,      :kind_of => String, :regex => /.*/, :default => node['ddnsupdate']['ddnssec']['file']
attribute :resolv_conf_file,      :kind_of => String, :regex => /.*/, :default => '/etc/resolv.conf'
