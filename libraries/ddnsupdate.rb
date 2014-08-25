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

#
# ddnsupdate cookbook /etc/resolv.conf parser helper module
#
module DDNSUpdate
  def self.resolv_conf(rc_file = '/etc/resolv.conf')
    rc = {
      :nameservers  => [],
      :domain       => nil,
      :search       => []
    }

    if File.exist?(rc_file)
      File.open(rc_file, 'r').each_line do |line|
        unless line =~ /^#|^;/
          case line
          when /domain/
            rc[:domain] = line.strip.split[1]
          when /search/
            rc[:search].push line.strip.split[1]
          when /nameserver/
            begin
              IPAddr.new(line.strip.split[1]).ipv4?
              rc[:nameservers].push line.strip.split[1]
            rescue
            end
          else
          end
        end
      end
    end
  end
end
