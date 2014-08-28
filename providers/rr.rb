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

action :update do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("EXISTING #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{rr.inspect}")
  raise "MISSING MX RR priority #{new_resource.name}(#{new_resource.type.upcase})=#{new_resource.value}" if new_resource.type.upcase == 'MX' and not new_resource.priority

  ruby_block "UPDATE #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{new_resource.value}" do
    block do
      IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
        io.puts "server #{new_resource.server}"
        io.puts "zone #{new_resource.zone}"
        if new_resource.purge
          io.puts "update delete #{new_resource.name} #{new_resource.type.upcase}"
        else
          io.puts "update delete #{new_resource.name} #{new_resource.type.upcase} #{new_resource.priority} #{new_resource.value}"
        end
        io.puts "update add #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.ttl} #{new_resource.type.upcase} #{new_resource.priority} #{new_resource.value}"
        io.puts 'send'
        io.close_write
        Chef::Log.info io.read
      end
    end
    not_if { rr.include?(new_resource.value) }
  end
end

action :delete do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("EXISTING #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{rr.inspect}")
  new_resource.value.each do |rvalue|
    raise "MISSING MX RR priority #{new_resource.name}(#{new_resource.type.upcase})=#{rvalue}" if new_resource.type.upcase == 'MX' and not new_resource.priority and not (new_resource.purge or rr.count == 1)
    ruby_block "DELETE #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{rvalue}" do
      block do
        IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
          io.puts "server #{new_resource.server}"
          io.puts "zone #{new_resource.zone}"
          io.puts "update delete #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.type.upcase} #{new_resource.priority} #{rvalue}"
          io.puts 'send'
          io.close_write
          Chef::Log.info io.read
        end
      end
      only_if { rr.include?(rvalue) }
    end
  end
end

action :create do
  rr = DDNSUpdate.dig(new_resource.type, new_resource.name, new_resource.server)
  Chef::Log.info("EXISTING #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{rr.inspect}")
  new_resource.value.each do |rvalue|
    raise "MISSING MX RR priority #{new_resource.name}(#{new_resource.type.upcase})=#{rvalue}" if new_resource.type.upcase == 'MX' and not new_resource.priority
    ruby_block "CREATE #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)}(#{new_resource.type.upcase})=#{rvalue}" do
      block do
        IO.popen("nsupdate -k #{new_resource.ddnssec_key_file} -v", 'r+') do |io|
          io.puts "server #{new_resource.server}"
          io.puts "zone #{new_resource.zone}"
          io.puts "update add #{DDNSUpdate.rr2ptr(new_resource.type, new_resource.name)} #{new_resource.ttl} #{new_resource.type.upcase} #{new_resource.priority} #{rvalue}"
          io.puts 'send'
          io.close_write
          Chef::Log.info io.read
        end
      end
      not_if { rr.include?(rvalue) }
    end
  end
end
