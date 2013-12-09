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

Chef::Log.info "-" * 70
Chef::Log.info "Unicorn Config"

template "#{node['errbit']['deploy_to']}/shared/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 00644
end

template "/etc/init.d/unicorn_#{node['errbit']['name']}" do
  source "unicorn.init.erb"
  owner "root"
  group "root"
  mode 00755
  variables(
    :user => node['errbit']['user'],
    :deploy_to => node['errbit']['deploy_to'],
    :env => node['errbit']['environment']
  )
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
  action :nothing
  subscribes :restart, "template[#{node['errbit']['deploy_to']}/shared/config/config.yml]"
  subscribes :restart, "template[/etc/init.d/unicorn_#{node['errbit']['name']}]"
  subscribes :restart, "template[#{node['errbit']['deploy_to']}/shared/config/unicorn.rb]"
  subscribes :restart, "template[#{node['errbit']['deploy_to']}/shared/config/config.yml]"
  subscribes :restart, "template[#{node['errbit']['deploy_to']}/shared/config/mongoid.yml]"
  subscribes :restart, "deploy_revision[#{node['errbit']['deploy_to']}]"
end
