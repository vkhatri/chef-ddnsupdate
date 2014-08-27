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

# require 'resolv'

use_inline_resources

def whyrun_supported?
  true
end

action :update do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("existing RR #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} type #{new_resource.type} value #{rr.inspect}")
  ruby_block "update_rr_#{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}_#{new_resource.type}_#{new_resource.value}" do
    block do
      IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
        io.puts "server #{new_resource.server}"
        io.puts "zone #{new_resource.zone}"
        # io.puts "update delete #{new_resource.name} #{new_resource.type}" # Require Testing for multiple value RR
        io.puts "update add #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.ttl} #{new_resource.type} #{new_resource.priority} #{new_resource.value}"
        io.puts 'send'
        io.close_write
        Chef::Log.info io.read
      end
    end
    not_if { rr.include?(new_resource.value) }
    # Need to verify whether delete a value delete all multiple values
    # Need more robust check for update RR, forcing by default for now
  end
end

action :delete do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("existing RR #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} type #{new_resource.type} value #{rr.inspect}")
  ruby_block "delete_rr_#{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}_#{new_resource.type}_#{new_resource.value}" do
    block do
      IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
        io.puts "server #{new_resource.server}"
        io.puts "zone #{new_resource.zone}"
        io.puts "update delete #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.type} #{new_resource.priority} #{new_resource.value}"
        io.puts 'send'
        io.close_write
        Chef::Log.info io.read
      end
    end
    only_if { rr.include?(new_resource.value) }
  end
end

action :create do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("existing RR #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} type #{new_resource.type} value #{rr.inspect}")
  ruby_block "create_rr_#{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}_#{new_resource.type}_#{new_resource.value}" do
    block do
      IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
        io.puts "server #{new_resource.server}"
        io.puts "zone #{new_resource.zone}"
        io.puts "update add #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.ttl} #{new_resource.type} #{new_resource.priority} #{new_resource.value}"
        io.puts 'send'
        io.close_write
        Chef::Log.info io.read
      end
    end
    not_if { rr.include?(new_resource.value) }
  end
end
