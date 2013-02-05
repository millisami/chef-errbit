#
# Cookbook Name:: errbit
# Recipe:: default
#
# Copyright (C) 2013 Millisami
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'unicorn'

node.default[:unicorn][:worker_timeout] = 60
node.default[:unicorn][:preload_app] = false
node.default[:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
node.default[:unicorn][:preload_app] = false
node.default[:unicorn][:before_fork] = 'sleep 1'
node.default[:unicorn][:port] = '8080'
node.set[:unicorn][:options] = { :tcp_nodelay => true, :backlog => 100 }

unicorn_config "/etc/unicorn/#{node['errbit']['name']}.rb" do
  listen({ node[:unicorn][:port] => node[:unicorn][:options] })
  working_directory ::File.join(node['errbit']['deploy_to'], 'current')
  worker_timeout node[:unicorn][:worker_timeout]
  preload_app node[:unicorn][:preload_app]
  worker_processes node[:unicorn][:worker_processes]
  before_fork node[:unicorn][:before_fork]
end
