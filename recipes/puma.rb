#
# Author:: Sachin Sagar Rai <millisami@gmail.com>
# Cookbook Name:: errbit
# Recipe:: puma
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

template "#{node['errbit']['deploy_to']}/shared/config/puma.rb" do
  source 'puma.rb.erb'
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 0644
end

['socket', 'service'].each do |unit|
  template "/lib/systemd/system/puma-#{node['errbit']['name']}.#{unit}" do
    source "puma.#{unit}.erb"
    owner 'root'
    group 'root'
    mode 0644
  end
end

service "puma-#{node['errbit']['name']}" do
  supports [:reload, :restart, :status]
  action :nothing

  subscribes :reload, "template[/lib/systemd/system/puma-#{node['errbit']['name']}.service]"
  subscribes :reload, "template[#{node['errbit']['deploy_to']}/shared/config/puma.rb]"
  subscribes :reload, "file[#{node['errbit']['deploy_to']}/shared/config/env]"
  subscribes :reload, "deploy_revision[#{node['errbit']['deploy_to']}]"
end

service "puma-#{node['errbit']['name']}.socket" do
  supports [:restart, :status]
  action [:enable, :start]
end
