execute "apt-get-update" do
  command "apt-get update"
end

if node[:development] == true
  node[:apache][:user] = "vagrant"
  node[:apache][:group] = "vagrant"
end

require_recipe "apt"

require_recipe "apache2"
require_recipe "apache2::mod_php5"
require_recipe "apache2::mod_rewrite"
require_recipe "apache2::mod_ssl"
require_recipe "apache2::mod_expires"

require_recipe "php"
require_recipe "php::module_curl"
require_recipe "php::module_gd"
require_recipe "php::module_memcache"
require_recipe "php::module_mysql"
require_recipe "php::module_sqlite3"

require_recipe "mysql::client"

require_recipe "xdebug"

package "git-core"

gem_package "compass" do
  action :install
  version "0.11.5"
  provider Chef::Provider::Package::Rubygems
end

# Remove the 000-default site
apache_site "000-default" do
  enable false
end

if node[:development] == true
  server_development = server = {}
  server[:server_name]              = "localhost"
  server[:server_aliases]           = ["*.localhost", "dev.vm"]
  server[:docbase]                  = "/home/vagrant/diveinkenya.com/development"
  server[:docroot]                  = "/home/vagrant/diveinkenya.com/development/current/base/www"
  server[:server_env]               = "development"
  server[:user]                     = "vagrant"
  server[:group]                    = "vagrant"
  server[:apache_allow_override]    = "None"
  node.set[:app][:servers] = [server_development]
else
  server_staging = server = {}
  server[:server_name]              = "aquav.mss.co.ke"
  server[:server_aliases]           = ["*.aquav.mss.co.ke"]
  server[:docbase]                  = "/home/www-data/diveinkenya.com/staging"
  server[:docroot]                  = "/home/www-data/diveinkenya.com/staging/current/base/www"
  server[:server_env]               = "staging"
  server[:user]                     = node[:apache][:user]
  server[:group]                    = node[:apache][:group]
  server[:apache_allow_override]    = "None"
  server_production = server = {}
  server[:server_name]              = "diveinkenya.com"
  server[:server_aliases]           = ["*.diveinkenya.com"]
  server[:docbase]                  = "/home/www-data/diveinkenya.com/production"
  server[:docroot]                  = "/home/www-data/diveinkenya.com/production/current/base/www"
  server[:server_env]               = "production"
  server[:user]                     = node[:apache][:user]
  server[:group]                    = node[:apache][:group]
  server[:apache_allow_override]    = "None"
  node.set[:app][:servers] = [server_staging, server_production]
end

node[:app][:servers].each do |server|
  print "Setting up: #{server[:server_name]}"
  directory               server[:docbase] do
    owner                 server[:user]
    group                 server[:group]
    mode                  "750"
    action                :create
    recursive             true
  end
  web_app                 server[:server_name] do
    server_name           server[:server_name]
    server_aliases        server[:server_aliases]
    docroot               server[:docroot]
    server_environment    server[:server_env]
    apache_allow_override server[:apache_allow_override]
  end
end