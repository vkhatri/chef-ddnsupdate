ddnsupdate Cookbook
===================

This is an [OpsCode Chef] cookbook for Managing BIND DNS Resource Records using nsupdate.

This cookbook was primarily developed to Manage an Internal DNS Domain Records for Instances
in Amazon EC2 infrastructure (where DHCP could not perform DNS Dynamic Records Updates, this
could change in the future), but this cookbook is not limited just to Amazon EC2 and could be 
used to manage a usual BIND DNS Domain Dynamic Records. 

Currently it supports common RR types `[A PTR CNAME MX]`, more
features and attributes will be added over time, **feel free to contribute**
what you find missing!


## Supported DDNS Resource Record Types

- A
- PTR
- CNAME
- MX (limited support for MX RR priority)


## Cookbook Recipes

- `ddnsupdate::install`   - install bind utils package and setup DDNSSEC Key file

- `ddnsupdate::host`  		- configure nsupdate to manage Host DDNS A & PTR RR

- `ddnsupdate::rr`   			- manage DDNS RR via node attrbute using LWRP


## Cookbook Repository

https://github.com/vkhatri/ddnsupdate


## Cookbook Dependencies

None


## Cookbook rr LWRP 

**LWRP - ddnsupdate_rr* 

rr LWRP can create/delete/update Dynamic DNS RR.

**LWRP example**

*RR via node attribute:*

    "default_attributes": {
      "ddnsupdate": {
        "rr": {
          "create": {
            "resource record name": {
							"type": "A",
							"value": "resource record ip address"
						},
            "resource record ip": {
							"type": "PTR",
							"value": "resource record name",
							"ttl": 900
						},		
            "resource record zone": {
							"type": "MX",
							"priority": 10
							"value": "resource record name"
						}													
          },
          "delete": {
            "resource record name": {
							"type": "type",
							"value": "resource record value"
						}	        	
          }
          "update": {
            "resource record name": {
							"type": "type",
							"value": "resource record value",
							"purge": true
						}	 
          }					
        }
      }
    }


*Create a RR using LWRP*

*Delete a RR using LWRP*

*Update a RR using LWRP*

*Purge a RR using LWRP*


**LWRP Options**

nsupdate Reference: `man nsupdate`

Parameters:

- *type (required)*			- dns record type, e.g. A PTR



## Cookbook core Attributes

 * `default[:ddnsupdate][:zone]` (default: `nil`, required: `false`): ddnsupdate forward zone, default forward zone for LWRP RR management
 * `default[:ddnsupdate][:reverse_zone]` (default: `nil`, required: `false`): ddnsupdate reverse zoen, default reverse zone for LWRP RR management
 * `default[:ddnsupdate][:server]` (default: `nil`, required: `true`): ddnsupdate dns server ip address
 * `default[:ddnsupdate][:host_config]` (default: `/etc/nsupdate`, required: `true`): ddnsupdate host nsupdate config file
 * `default[:ddnsupdate][:rr_config]` (default: `/etc/rrnsupdate`, required: `false`): this attribute is for future usage
 * `default[:ddnsupdate][:host_nsupdate]` (default: `/usr/local/bin/host_nsupdate`, required: `true`): nsupdate script for host
 * `default[:ddnsupdate][:rr_nsupdate]` (default: `/usr/local/bin/rr_nsupdate`, required: `true`): this attribute is for future usage
 * `default[:ddnsupdate][:ttl]` (default: `300`, required: `true`): RR TTL value
 
 
## Cookbook ddnssec Attributes
 
 * `default[:ddnsupdate][:ddnssec][:databag]` (default: `nil`, required: `false`): this attribute is for future usage
 * `default[:ddnsupdate][:ddnssec][:manage]` (default: `true`, required: `true`): if true manages bind ddnsec configuration file `node[:ddnsupdate][:ddnssec][:key_file]`
 * `default[:ddnsupdate][:ddnssec][:key_file]` (default: `/etc/nsupdate.key`, required: `true`): bind ddnsec key configuration file
 * `default[:ddnsupdate][:ddnssec][:key_name]` (default: `nil`, required: `true`): bind ddnsec key name
 * `default[:ddnsupdate][:ddnssec][:algo]` (default: `HMAC-MD5`, required: `true`): bind ddnsec key algo
 * `default[:ddnsupdate][:ddnssec][:secret]` (default: `nil`, required: `true`): bind dnssec secret
 * `default[:ddnsupdate][:ddnssec][:template_cookbook]` (default: `ddnsupdate`, required: `true`): bind dnssec configuration file template
 * `default[:ddnsupdate][:ddnssec][:template_source]` (default: `nsupdate.key.erb`, required: `true`): bind dnssec configuration file template


## Cookbook host nsupdate crond Attributes
 
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:minute]` (default: `*/15`, required: `false`): host nsupdate cron schedule minutes interval
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:hour]` (default: `*`, required: `false`): host nsupdate cron schedule hour interval
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:user]` (default: `root`, required: `false`): host nsupdate cron schedule user
 * `default[:ddnsupdate][:ddnssec][:cron][:host][:action]` (default: `create`, required: `false`): crond resource action, set it to delete to prevent cron schedule


## Cookbook rr nsupdate Attributes
 
 * `default[:ddnsupdate][:rr][:create]` (default: `[]`, required: `false`): create dynamic dns records via nsupdate
 * `default[:ddnsupdate][:rr][:delete]` (default: `[]`, required: `false`): delete dynamic dns records via nsupdate, 
 * `default[:ddnsupdate][:rr][:update]` (default: `[]`, required: `false`): update dynamic dns records via nsupdate
 
    Note: Check LWRP Examples for advanced attributes.
			 

## Cookbook host Recipe Usage

Include this recipe to node run_list to manage Host A & PTR Records.


## Cookbook rr Recipe Usage

Include this recipe to node run_list to manage Resource Records via node attribute `default[:ddnsupdate][:rr]`.

## Contributing

1. Fork the repository on Github 
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Write description about changes
7. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri (vir.khatri@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[Opscode Chef]: https://wiki.opscode.com/display/chef/Home
