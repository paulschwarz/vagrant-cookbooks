execute "apt-get-update" do
  command "apt-get update"
end

if node[:development] == true
  node[:apache][:user] = "vagrant"
  node[:apache][:group] = "vagrant"
end

require_recipe "apt"

require_recipe "build-essential"

package "libcurl4-gnutls-dev" do
  action :install
end

apt_repository "squeeze" do
  uri "http://packages.dotdeb.org"
  distribution "squeeze"
  components ["all"]
  action :add
  key "http://www.dotdeb.org/dotdeb.gpg"
end

apt_repository "squeeze-php54" do
  uri "http://packages.dotdeb.org"
  distribution "squeeze-php54"
  components ["all"]
  action :add
  key "http://www.dotdeb.org/dotdeb.gpg"
end

execute "force-apt-get-update" do
  command "apt-get update"
end

require_recipe "mysql::server"
require_recipe "mysql::client"

require_recipe "apache2"
require_recipe "apache2::mod_php5"
require_recipe "apache2::mod_rewrite"
require_recipe "apache2::mod_ssl"
require_recipe "apache2::mod_expires"

require_recipe "php"

package "php5-curl" do
  action :install
end

package "php5-gd" do
  action :install
end


package "php5-memcache" do
  action :install
end

package "php5-sqlite" do
  action :install
end

package "php5-mcrypt" do
  action :install
end

package "php5-mysqlnd" do
  action :install
end



require_recipe "xdebug"

package "git-core"

#gem_package "compass" do
#  action :install
#  version "0.11.5"
#  provider Chef::Provider::Package::Rubygems
#end

# Remove the 000-default site
apache_site "000-default" do
  enable false
end

if node[:development] == true
  server_development = server = {}
  server[:server_name]              = "localhost"
  server[:server_aliases]           = ["*.localhost", "dev.vm"]
  server[:docbase]                  = "/home/vagrant/kcm"
  server[:docroot]                  = "/home/vagrant/kcm/base/www"
  server[:server_env]               = "development"
  server[:user]                     = "vagrant"
  server[:group]                    = "vagrant"
  server[:apache_allow_override]    = "None"
  node.set[:app][:servers] = [server_development]
else
  server_staging = server = {}
  server[:server_name]              = "kenyachambermines.com"
  server[:server_aliases]           = ["*.kenyachambermines.com"]
  server[:docbase]                  = "/home/www-data/kcm"
  server[:docroot]                  = "/home/www-data/kcm/base/www"
  server[:server_env]               = "staging"
  server[:user]                     = node[:apache][:user]
  server[:group]                    = node[:apache][:group]
  server[:apache_allow_override]    = "None"
  server_production = server = {}
  server[:server_name]              = "kenyachambermines.com"
  server[:server_aliases]           = ["*.kenyachambermines.com"]
  server[:docbase]                  = "/home/www-data/kcm/production"
  server[:docroot]                  = "/home/www-data/kcm/production/base/www"
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

