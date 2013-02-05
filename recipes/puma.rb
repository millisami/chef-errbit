#
# Cookbook Name:: errbit
# Recipe:: default
#
# Copyright (C) 2013 Millisami
#
# All rights reserved - Do Not Redistribute
#

execute "puma app server" do
  cwd "#{node['errbit']['deploy_to']}/current"
  command "bundle exec puma -D"
  # creates "/tmp/something"
  action :run
end
