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

use_inline_resources

def whyrun_supported?
  true
end

action :delete do
  rr_name   = DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)
  rr_value  = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("INFO action=delete, server=#{new_resource.server}, zone=#{new_resource.zone}, type=#{new_resource.type}, \
  rname=#{rr_name}, old-rvalue=#{rr_value.inspect}, new-rvalue=#{new_resource.value.inspect}")
  new_resource.value.each do |rvalue|
    raise "MISSING MX RR priority #{new_resource.name}(#{new_resource.type.upcase})=#{rvalue}" if new_resource.type.casecmp('MX').zero? \
     && !new_resource.priority && !(new_resource.purge || rr.count == 1)
    ruby_block "DELETE #{rr_name}(#{new_resource.type.upcase})=#{rvalue}" do
      block do
        IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
          io.puts "server #{new_resource.server}"
          io.puts "zone #{new_resource.zone}"
          if new_resource.purge
            io.puts "update delete #{rr_name} #{new_resource.type.upcase}"
          else
            io.puts "update delete #{rr_name} #{new_resource.type.upcase} #{new_resource.priority if new_resource.type.casecmp('MX').zero?} #{rvalue}"
          end
          io.puts 'send'
          io.close_write
          Chef::Log.info io.read
        end
      end
      only_if { rr_value.include?(rvalue) || new_resource.purge }
    end
  end
end

action :create do
  rr_name   = DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)
  rr_value  = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("INFO action=create, server=#{new_resource.server}, zone=#{new_resource.zone}, type=#{new_resource.type}, \
  rname=#{rr_name}, old-rvalue=#{rr_value.inspect}, new-rvalue=#{new_resource.value.inspect}")
  new_resource.value.each do |rvalue|
    raise "MISSING MX RR priority #{new_resource.name}(#{new_resource.type.upcase})=#{rvalue}" if new_resource.type.casecmp('MX').zero? && !new_resource.priority

    ruby_block "CREATE #{rr_name}(#{new_resource.type.upcase})=#{rvalue}" do
      block do
        IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
          io.puts "server #{new_resource.server}"
          io.puts "zone #{new_resource.zone}"
          io.puts "update add #{rr_name} #{new_resource.ttl} #{new_resource.type.upcase} #{new_resource.priority if new_resource.type.casecmp('MX').zero?} #{rvalue}"
          io.puts 'send'
          io.close_write
          Chef::Log.info io.read
        end
      end
      not_if { rr_value.include?(rvalue) }
    end
  end
end
