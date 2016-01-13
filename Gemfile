source 'https://rubygems.org'

gem 'net-ssh', '~> 2.9' # net-ssh 3.0 requires ruby 2.x

group :development, :test do
  gem 'rake'
  gem 'rspec', "~> 2.11.0", :require => false
  gem 'mocha', "~> 0.10.5", :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-puppet', :require => false
  gem 'puppet-lint'
end

facterversion = ENV['GEM_FACTER_VERSION']
if facterversion
    gem 'facter', facterversion
else
    gem 'facter', :require => false
end

ENV['GEM_PUPPET_VERSION'] ||= ENV['PUPPET_GEM_VERSION']
if puppetversion = ENV['GEM_PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', :require => false
end
