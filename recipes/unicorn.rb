#
# Author:: Sachin Sagar Rai <millisami@gmail.com>
# Cookbook Name:: errbit
# Recipe:: unicorn
#
# Copyright (C) 2013 Millisami
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'unicorn'

node.default[:unicorn][:worker_timeout]   = 60
node.default[:unicorn][:worker_processes] = 2 #[node[:cpu][:total].to_i * 4, 8].min
node.default[:unicorn][:preload_app]      = false
node.default[:unicorn][:tcp_nodelay]      = true
node.default[:unicorn][:backlog]          = 100
node.default[:unicorn][:tcp_nopush]       = true
node.default[:unicorn][:tries]            = 3
# node.default[:unicorn][:delay]            = 100

Chef::Log.info "-" * 70
Chef::Log.info "Unicorn Config"

template "#{node['errbit']['deploy_to']}/shared/config/unicorn.conf" do
  source "unicorn.conf.erb"
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 00644
end

template "/etc/init.d/unicorn_#{node['errbit']['name']}" do
  source "unicorn.service.erb"
  owner "root"
  group "root"
  mode 00755
end

service "unicorn_#{node['errbit']['name']}" do
  provider Chef::Provider::Service::Init::Debian
  start_command   "/etc/init.d/unicorn_#{node['errbit']['name']} start"
  stop_command    "/etc/init.d/unicorn_#{node['errbit']['name']} stop"
  restart_command "/etc/init.d/unicorn_#{node['errbit']['name']} restart"
  status_command  "/etc/init.d/unicorn_#{node['errbit']['name']} status"
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end


# Restarting the unicorn
service "unicorn_#{node['errbit']['name']}" do
  action :restart
end
