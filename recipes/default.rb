#
# Cookbook Name:: errbit
# Recipe:: default
#
# Copyright (C) 2013 Millisami
#
# All rights reserved - Do Not Redistribute
#

include_recipe "errbit::setup"
server = node['errbit']['server']

include_recipe "errbit::#{server}"
