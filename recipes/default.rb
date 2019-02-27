#
# Author:: Sachin Sagar Rai <millisami@gmail.com>
# Cookbook Name:: errbit
# Recipe:: default
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

include_recipe 'errbit::setup'
include_recipe 'errbit::' + node['errbit']['server']['name']

# Hack to work around systemd creating the socket with the wrong
# context and selinux_policy cookbook only running restorecon once.
execute "restorecon -R #{node['errbit']['deploy_to']}" do
  only_if 'which restorecon'
end
