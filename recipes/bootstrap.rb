#
# Author:: Sachin Sagar Rai <millisami@gmail.com>
# Cookbook Name:: errbit
# Recipe:: setup
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

home_dir = "/home/#{node['errbit']['user']}"
current_dir = "#{node['errbit']['deploy_to']}/current"

rbenv_script 'rake db:seed' do
  code 'bundle exec rake db:seed RAILS_ENV=' + node['errbit']['config']['rails_env']
  cwd current_dir
  user node['errbit']['user']

  not_if "#{home_dir}/.rbenv/bin/rbenv exec bundle exec rails runner 'exit User.where(:admin => true).exists?'", {
    :cwd => current_dir,
    :user => node['errbit']['user'],
    :group => node['errbit']['group'],
    :environment => { 'HOME' => home_dir }
  }

  notifies :run, "ruby_block[remove_bootstrap]", :immediately
end

ruby_block "remove_bootstrap" do
  block do
    Chef::Log.info("Database seed/bootstrap completed, removing the destructive recipe[errbit::bootstrap]")
    node.run_list.remove("recipe[errbit::bootstrap]") if node.run_list.include?("recipe[errbit::bootstrap]")
  end
  action :nothing
end
