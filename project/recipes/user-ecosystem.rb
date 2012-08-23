execute "initial-apt-get-update" do
  command "apt-get update"
end

require_recipe "apt"

# http://www.barryodonovan.com/index.php/2012/05/22/ubuntu-12-04-precise-pangolin-and-php-5-4-again
apt_repository "php54" do
  action :add
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
end

node[:apache][:user] = "vagrant"
node[:apache][:group] = "vagrant"

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
require_recipe "composer"

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

server_development = server = {}
server[:server_name]              = "localhost"
server[:server_aliases]           = ["dev.vm"]
server[:docbase]                  = "/home/vagrant/#{node[:domain_name]}"
server[:docroot]                  = "/home/vagrant/#{node[:domain_name]}/www"
server[:server_env]               = "development"
server[:user]                     = "vagrant"
server[:group]                    = "vagrant"
server[:apache_allow_override]    = "None"
node.set[:app][:servers] = [server_development]

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
