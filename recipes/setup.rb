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

node.set['build_essential']['compiletime'] = true
include_recipe "build-essential"

include_recipe "git"
include_recipe "nginx"

group node['errbit']['group']

user node['errbit']['user'] do
  action :create
  comment "Errbit user"
  gid node['errbit']['group']
  shell "/bin/bash"
  home "/home/#{node['errbit']['user']}"
  supports :manage_home => true
  system false
end

# Exporting the SECRET_TOKEN env var
secret_token = rand(8**256).to_s(36).ljust(8,'a')[0..150]
execute "set SECRET_TOKEN var" do
  user node['errbit']['user']
  command "echo 'export SECRET_TOKEN=#{secret_token}' >> /home/#{node['errbit']['user']}/.bash_profile"
  not_if "grep SECRET_TOKEN /home/#{node['errbit']['user']}/.bash_profile"
end

# setup rbenv (after git user setup)
%w{ ruby_build rbenv::user_install }.each do |requirement|
  include_recipe requirement
end

# Install appropriate Ruby with rbenv
rbenv_ruby node['errbit']['install_ruby'] do
  action :install
  user node['errbit']['user']
end

# Set as the rbenv default ruby
rbenv_global node['errbit']['install_ruby'] do
  user node['errbit']['user']
end

# Install required Ruby Gems(via rbenv)
rbenv_gem "bundler" do
  action :install
  user node['errbit']['user']
  rbenv_version node['errbit']['install_ruby']
end

execute "update sources list" do
  command "apt-get update"
  action :nothing
end.run_action(:run)

%w(libxml2-dev libxslt1-dev libcurl4-gnutls-dev).each do |pkg|
  r = package pkg do
    action :nothing
  end
  r.run_action(:install)
end

directory node['errbit']['deploy_to'] do
  owner node['errbit']['user']
  group node['errbit']['group']
  action :create
  recursive true
end

directory "#{node['errbit']['deploy_to']}/shared" do
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 00755
end

%w{ log pids system tmp vendor_bundle scripts config sockets }.each do |dir|
  directory "#{node['errbit']['deploy_to']}/shared/#{dir}" do
    owner node['errbit']['user']
    group node['errbit']['group']
    mode 0775
    recursive true
  end
end

# errbit config.yml
template "#{node['errbit']['deploy_to']}/shared/config/config.yml" do
  source "config.yml.erb"
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 00644
  variables(params: {
    host: node['errbit']['config']['host'],
    enforce_ssl: node['errbit']['config']['enforce_ssl'],
    email_from: node['errbit']['config']['email_from'],
    per_app_email_at_notices: node['errbit']['config']['per_app_email_at_notices'],
    email_at_notices: node['errbit']['config']['email_at_notices'],
    confirm_resolve_err: node['errbit']['config']['confirm_resolve_err'],
    user_has_username: node['errbit']['config']['user_has_username'],
    allow_comments_with_issue_tracker: node['errbit']['config']['allow_comments_with_issue_tracker'],
    use_gravatar: node['errbit']['config']['use_gravatar'],
    gravatar_default: node['errbit']['config']['gravatar_default'],
    github_authentication: node['errbit']['config']['github_authentication'],
    github_client_id: node['errbit']['config']['github_client_id'],
    github_secret: node['errbit']['config']['github_secret'],
    github_access_scope: node['errbit']['config']['github_access_scope']
  })
end

template "#{node['errbit']['deploy_to']}/shared/config/mongoid.yml" do
  source "mongoid.yml.erb"
  owner node['errbit']['user']
  group node['errbit']['group']
  mode 00644
  variables( params: {
    environment: node['errbit']['environment'],
    host: node['errbit']['db']['host'],
    port: node['errbit']['db']['port'],
    database: node['errbit']['db']['database']
    # username: node['errbit']['db']['username'],
    # password: node['errbit']['db']['password']
  })
end

deploy_revision node['errbit']['deploy_to'] do
  repo node['errbit']['repo_url']
  revision node['errbit']['revision']
  user node['errbit']['user']
  group node['errbit']['group']
  enable_submodules false
  migrate false
  before_migrate do
    link "#{release_path}/vendor/bundle" do
      to "#{node['errbit']['deploy_to']}/shared/vendor_bundle"
    end
    common_groups = %w{development test cucumber staging production}
    execute "bundle install --deployment --without #{(common_groups - ([node['errbit']['environment']])).join(' ')}" do
      ignore_failure true
      cwd release_path
    end
  end

  symlink_before_migrate nil
  symlinks(
    "config/config.yml" => "config/config.yml",
    "config/mongoid.yml" => "config/mongoid.yml"
  )
  environment 'RAILS_ENV' => node['errbit']['environment'], 'SECRET_TOKEN' => node['errbit']['secret_token']
  shallow_clone true
  action :deploy #:deploy or :rollback or :force_deploy

  before_restart do

    Chef::Log.info "*" * 20 + "COMPILING ASSETS" + "*" * 20
    execute "asset_precompile" do
      cwd release_path
      user node['errbit']['user']
      group node['errbit']['group']
      command "bundle exec rake assets:precompile --trace"
      environment ({'RAILS_ENV' => node['errbit']['environment']})
    end
  end
  # git_ssh_wrapper "wrap-ssh4git.sh"
  scm_provider Chef::Provider::Git
end

template "#{node['nginx']['dir']}/sites-available/#{node['errbit']['name']}" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 00644
  # variables( server_names: ['example.com', 'www.example.com'] )
end

nginx_site node['errbit']['name'] do
  enable true
end

