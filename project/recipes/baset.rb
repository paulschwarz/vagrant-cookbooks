# For some reason, a fresh copy of my VM has issues booting up until this runs
execute "initial-sudo-apt-get-update" do
  command "apt-get update"
end

# Making apache run as the vagrant user simplifies things when you ssh in
node.set["apache"]["user"] = "baset"
node.set["apache"]["group"] = "baset"

require_recipe "apt"

require_recipe "apache2"
require_recipe "apache2::mod_php5"
require_recipe "apache2::mod_rewrite"
require_recipe "apache2::mod_ssl"

require_recipe "php"
require_recipe "php::module_curl"
#require_recipe "php::module_fileinfo"
require_recipe "php::module_gd"
require_recipe "php::module_memcache"
require_recipe "php::module_mysql"
require_recipe "php::module_sqlite3"

require_recipe "mysql::server"

#require_recipe "xdebug"

package "git-core"

# Remove the 000-default site
apache_site "000-default" do
  enable false
end

directory node[:app][:staging][:docroot] do
  owner "baset"
  group "baset"
  mode "0755"
  action :create
  recursive true
end
web_app node[:app][:staging][:server_name] do
  server_name node[:app][:staging][:server_name]
  server_aliases node[:app][:staging][:server_aliases]
  docroot node[:app][:staging][:docroot]
  SERVER_ENV node[:app][:staging][:server_env]
end

directory node[:app][:production][:docroot] do
  owner "baset"
  group "baset"
  mode "0755"
  action :create
  recursive true
end
web_app node[:app][:production][:server_name] do
  server_name node[:app][:production][:server_name]
  server_aliases node[:app][:production][:server_aliases]
  docroot node[:app][:production][:docroot]
  SERVER_ENV node[:app][:production][:server_env]
end

gem_package "compass" do
  action :install
  version "0.11.5"
  provider Chef::Provider::Package::Rubygems
end
