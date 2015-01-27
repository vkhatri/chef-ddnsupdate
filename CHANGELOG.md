ddnsupdate CHANGELOG
====================

This file is used to list changes made in each version of the ddnsupdate cookbook.

0.1.8
-----

- Virender Khatri - fixed missing ohai node attribute fqdn/domain issue, now
                    falls back to provided zone if node['domain'] is missing.
                    same fix applied for missing node['fqdn']

- Virender Khatri - disabled knife lint check temporarily

0.1.5
-----

- Virender Khatri - added rubocop, food critic, knife, rspec lint test

- Virender Khatri - added support for travis ci


0.1.2
-----

- Virender Khatri - initial release of ddnsupdate

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
