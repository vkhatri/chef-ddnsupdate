#! Gemfile
source 'https://rubygems.org'

gem 'berkshelf'
gem 'chefspec'
gem 'foodcritic', '~> 3.0'
gem 'rake'
gem 'rubocop'

# gem 'fauxhai'

group :integration do
  gem 'kitchen-docker'
  gem 'kitchen-vagrant'
  gem 'test-kitchen'
end

group :test do
  gem 'coveralls', require: false
end

group :development do
  gem 'chef'
  gem 'knife-spec'
  gem 'knife-spork', '~> 1.0.17'
end

# Uncomment these lines if you want to live on the Edge:
#
# group :development do
#   gem "berkshelf", github: "berkshelf/berkshelf"
#   gem "vagrant", github: "mitchellh/vagrant", tag: "v1.6.3"
# end
#
# group :plugins do
#   gem "vagrant-berkshelf", github: "berkshelf/vagrant-berkshelf"
#   gem "vagrant-omnibus", github: "schisamo/vagrant-omnibus"
# end
