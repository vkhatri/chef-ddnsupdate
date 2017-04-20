ddnsupdate Cookbook
===================

[![Build Status](https://travis-ci.org/vkhatri/chef-ddnsupdate.svg?branch=master)](https://travis-ci.org/vkhatri/chef-ddnsupdate)

This is a [Chef] cookbook for Managing BIND DNS Resource Records using nsupdate.

This cookbook was primarily developed to Manage an Internal BIND DNS Domain Dynamic Records for Instances
in Amazon EC2 infrastructure (where DHCP could not perform DNS Dynamic Records Updates, this
might change in the future), but this cookbook is not limited just to Amazon EC2 and could be
used to manage ant BIND DNS Domain Dynamic Records.

Currently it supports common RR types `[A PTR CNAME MX]`, more
features and attributes will be added over time, **feel free to contribute**
what you find missing!


## Cookbook Repository

https://github.com/vkhatri/chef-ddnsupdate

# Requirements
## Platforms
The following platforms are supported via test kitchen.
* Ubuntu 12.04
* Centos 6.8
* Centos 7.2

It may work with or without modification on other platforms.

## Chef
* Chef 12

## Cookbooks

- `ddnsupdate::install`   - install bind utils package and setup DDNSSEC Key file

- `ddnsupdate::host`  		- configure nsupdate to manage Host DDNS A & PTR RR

- `ddnsupdate::rr`   			- manage DDNS RR via node attribute using LWRP

## Cookbook Dependencies

None

## Supported DDNS Resource Record Types

- A
- PTR
- CNAME
- MX (limited support for MX RR priority)

## Non-Secure DDNS Update
Dynamic DNS by default requires a name/security key to update DNS.  There are times however when one disables this feature to allow updates without a DDNSSEC key. This feature allows one to turn off the requirement for DDNSSEC.

 * `default['ddnsupdate']['no_ddnssec']  # default zone access is controlled by ddnssec` (default: `false`)

## Cookbook rr LWRP

**LWRP - ddnsupdate_rr*

rr LWRP is used to create/delete Dynamic DNS RR.

**LWRP example**

*RR via node attribute:*

    "default_attributes": {
      "ddnsupdate": {
        "rr": {
          "create": {
            "resource record name": {
              "type": "A",
              "value": [
                "resource record ip address 1",
                "resource record ip address 2"
              ],
              "ttl": 300 # override default ttl value
            },
            "resource record ip": {
              "type": "PTR",
              "value": [
                "resource record name 1",
                "resource record name 2"
              ],
              "ttl": 900
            },
            "resource record zone": {
              "type": "MX",
              "priority": 10,
              "value": [
                "resource record name"
              ]
            }
          },
          "delete": {
            "resource record name": {
              "type": "type",
              "value": "resource record value",
              "purge": false
            }
          }
        }
      }
    }


*Create a RR using LWRP*

    ddnsupdate_rr rr_name_description
      option option_name
    end

*Delete a RR using LWRP*

    ddnsupdate_rr rr_name_description
      option option_name
      action :delete
    end

*Delete a RR with Purge using LWRP*

A RR like A or PTR could point to more than one record value. To delete RR entirely
set RR attribute `purge`.

    ddnsupdate_rr rr_name_description
      option option_name
      purge  true
      action :delete
    end

**LWRP Options**

nsupdate Reference: `man nsupdate`

Parameters:

- *type (required)*					- RR type, e.g. A PTR CNAME MX
- *ttl (default: `node.ddnsupdate.ttl`)*				- RR ttl value
- *purge (default: false)*	- delete all RR record values, in conjunction with action :delete
- *value (default: `[]`, required)*				- array of RR value(s)
- *server (default: `node.ddnsupdate.server`)*	- RR server to create/delete
- *zone (require)*								- RR zone
- *priority (default: 10)*	- MX RR priority
- *ddnssec_key_file (default: `node.ddnsupdate.ddnssec.file`)*	- RR ddnssec key file
- *resolv_conf_file (default: `/etc/resolv.conf`)*				- resolv conf file

## Cookbook core Attributes

 * `default[:ddnsupdate][:server]` (default: `nil`): ddns server, overrides /etc/resolv.conf dns server lookup, required if `default[:ddnsupdate][:use_resolv_conf]` is not set
 * `default[:ddnsupdate][:use_resolv_conf]` (default: `false`): if set, sets `default[:ddnsupdate][:resolv_conf]` & `default[:ddnsupdate][:server]` attributes

        If there is no server ip address configured via attribute
        default[:ddnsupdate][:server], this attribute will use
        first nameserver entry from /etc/resolv.conf file.

 * `default[:ddnsupdate][:ttl]` (default: `300`): RR TTL value

## Cookbook ddnssec Attributes

 * `default[:ddnsupdate][:ddnssec][:manage]` (default: `true`): if true manages bind ddnssec configuration file `node[:ddnsupdate][:ddnssec][:key_file]`
 * `default[:ddnsupdate][:ddnssec][:file]` (default: `/etc/nsupdate.key`): bind ddnssec key configuration file
 * `default[:ddnsupdate][:ddnssec][:name]` (default: `nil`): bind ddnssec key name
 * `default[:ddnsupdate][:ddnssec][:algo]` (default: `HMAC-MD5`): bind ddnssec key algo
 * `default[:ddnsupdate][:ddnssec][:secret]` (default: `nil`): bind dnssec secret
 * `default[:ddnsupdate][:ddnssec][:template_cookbook]` (default: `ddnsupdate`): bind dnssec configuration file template cookbook
 * `default[:ddnsupdate][:ddnssec][:template_source]` (default: `nsupdate.key.erb`): bind dnssec key configuration file template


## Cookbook host Attributes

 * `default[:ddnsupdate][:host][:manage]` (default: `true`): whether to run ddnsupdate to update dynamic dns record
 * `default[:ddnsupdate][:host][:config]` (default: `/etc/nsupdate`): ddnsupdate host config file
 * `default[:ddnsupdate][:host][:nsupdate_bin]` (default: `/usr/local/bin/host_nsupdate`): host ddnsupdate script location
 * `default[:ddnsupdate][:host][:zone]` (default: `node.domain`): ddnsupdate forward zone, default to `node[:domain]`
 * `default[:ddnsupdate][:host][:reverse_zone]` (default: `nil`, required): ddnsupdate reverse zone, required as it might varies from standard host subnet/network
 * `default[:ddnsupdate][:host][:auto_fqdn_zone]` (default: `true`): use `node['fqdn']` & `node['domain']`


## Cookbook host nsupdate crond Attributes

 * `default[:ddnsupdate][:host][:manage]` (default: `true`): whether to register node ddns record with dns server, will always setup node ddnsupdate nsupdate scripts
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:minute]` (default: `*/15`): host nsupdate cron schedule minutes interval
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:hour]` (default: `*`): host nsupdate cron schedule hour interval
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:user]` (default: `root`): host nsupdate cron schedule user
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:action]` (default: `create`): crond resource action, set it to delete to prevent cron schedule


## Cookbook rr nsupdate Attributes

 * `default[:ddnsupdate][:rr][:create]` (default: `{}`): create dynamic dns records via nsupdate
 * `default[:ddnsupdate][:rr][:delete]` (default: `{}`): delete dynamic dns records via nsupdate

    Note: Check & LWRP Examples for advanced attributes.


## Cookbook host Recipe Usage

Include recipe `ddnsupdate::host` to node run_list to manage Host DDNS A & PTR Records.


## Cookbook rr Recipe Usage

Include recipe `ddnsupdate::rr` to a node run_list to manage DDNS RR via node attribute `default[:ddnsupdate][:rr]`.

Note: This recipe does not require to be added to all the nodes, adding to one node or two is sufficient to manage RRs.


*RR Create*

Creating a RR is simple, but it is important to point out that RR value is an array and every time a value is added to a RR, it
will keep appending it to existing RR.

May be in future purge will be added to action :create like :delete


*RR Delete*

Deleting a RR is also simple. Like action :create, :delete will only delete defined RR(s).


*RR Delete with Purge*

To purge all the RR values completely enable `purge` attribute for RR as defined in the LWRP examples.


## Chef role to manage node ddns and RR

Below Chef role is a sample to manage host and other RR.

This sample uses first nameserver defined in /etc/resolv.conf file.

    "default_attributes": {
      "ddnsupdate": {
        "use_resolv_conf": true,
		"ttl": 300,

        "ddnssec": {
          "name": "internal.domain.com",
          "secret": "XYZXYZ....."
					},

        "host": {
          "reverse_zone": "10.in-addr.arpa"
        },

        "rr": {
          "create": {
            "test00.internal.domain.com": {
              "type": "A",
              "zone": "internal.domain.com",
              "value": [
                "10.0.0.101",
                "10.0.0.102"
              ]
            },
            "10.0.0.101": {
              "type": "PTR",
              "zone": "10.in-addr.arpa",
              "value": [
                "test00.internal.domain.com"
              ]
            },
            "10.0.0.102": {
              "type": "PTR",
              "zone": "10.in-addr.arpa",
              "value": [
                "test00.internal.domain.com"
              ]
            },
            "test02.internal.domain.com": {
              "server": "10.0.1.2",
              "type": "cname",
              "zone": "internal.domain.com",
              "value": [
                "test00.internal.domain.com"
              ]
            }
          },
          "delete": {
            "test01.internal.domain.com": {
              "purge": false,
              "type": "cname",
              "ttl": 300,
              "zone": "internal.domain.com",
              "value": [
                "test00.internal.domain.com"
              ]
            }
          }
        }
      }
    }


To use a differenet DNS server, update below attributes:

    "default_attributes": {
      "ddnsupdate": {
        "use_resolv_conf": false,
        "server": "10.0.0.1",
				...


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>

[Chef]: https://www.getchef.com/chef/
[Contributors]: https://github.com/vkhatri/chef-ddnsupdate/graphs/contributors
