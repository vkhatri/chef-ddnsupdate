#
# Cookbook Name:: ddnsupdate
# Library:: ddnsupdate
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

require 'ipaddr'

# helper module
module DDNSUpdate
  def self.rr2ptr(type, rr)
    if type.casecmp('PTR').zero?
      return "#{rr.split('.').reverse.join('.')}.in-addr.arpa"
    else
      return rr
    end
  end

  def self.dig(type, resource, server = nil)
    if server
      o = { :nameserver => server }
      case type.upcase
      when 'A'
        Resolv::DNS.new(o).getaddresses(resource).map(&:to_s)
        # Resolv::DNS.new.getresources(resource, Resolv::DNS::Resource::IN::A).map {|i| i.address.to_s}
      when 'PTR'
        Resolv::DNS.new(o).getnames(resource).map(&:to_s)
      when 'CNAME'
        Resolv::DNS.new(o).getresources(resource, Resolv::DNS::Resource::IN::CNAME).map { |i| i.name.to_s }
      when 'MX'
        Resolv::DNS.new(o).getresources('bsb.in', Resolv::DNS::Resource::IN::MX).map { |i| i.exchange.to_s }
      end
    else
      case type.upcase
      when 'A'
        Resolv.getaddresses(resource).map(&:to_s)
      when 'PTR'
        Resolv.getnames(resource).map(&:to_s)
      when 'CNAME'
        Resolv::DNS.new.getresources(resource, Resolv::DNS::Resource::IN::CNAME).map { |i| i.name.to_s }
      when 'MX'
        Resolv::DNS.new.getresources('bsb.in', Resolv::DNS::Resource::IN::MX).map { |i| i.exchange.to_s }
      end
    end
  end

  def self.resolv_conf(rc_file = '/etc/resolv.conf')
    rc = {
      :nameservers  => [],
      :domain       => nil,
      :search       => []
    }
    if File.exist?(rc_file)
      File.open(rc_file, 'r').each_line do |line|
        next if line =~ /^#|^;/
        case line
        when /domain/
          rc[:domain] = line.strip.split[1]
        when /search/
          rc[:search].push line.strip.split[1]
        when /nameserver/
          begin
            IPAddr.new(line.strip.split[1]).ipv4?
            rc[:nameservers].push line.strip.split[1]
          end
        end
      end
    end
    rc
  end
end
