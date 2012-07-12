#
# Cookbook Name:: composer
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "get-composer" do
  cwd "/home/vagrant/web-app/"
  command "sudo wget http://getcomposer.org/composer.phar"
  creates "composer.phar"
  #creates "/home/vagrant/web-app/composer.phar"
  action :run
end



execute "install-composer" do
  cwd "/home/vagrant/web-app/"
  command "sudo php composer.phar install --prefer-source"
  action :run
end
