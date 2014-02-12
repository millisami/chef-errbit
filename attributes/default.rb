#
# Cookbook Name:: errbit
# Attribute:: default
#
# Copyright (C) 2013 Millisami
#
# All rights reserved - Do Not Redistribute
#

default['errbit']['name']         = "errbit"
default['errbit']['user']         = "deployer"
default['errbit']['password']     = "$1$qqO27xay$dtmwY9NMmJiSa47xhUZm0." #errbit
default['errbit']['group']        = node['errbit']['user']
default['errbit']['deploy_to']    = "/home/#{default['errbit']['user']}/#{node['errbit']['name']}"
default['errbit']['repo_url']     = "git://github.com/errbit/errbit.git"
default['errbit']['revision']     = "master"
default['errbit']['environment']  = "production"

# errbit config.yml
default['errbit']['config']['host']                               = "errbit.example.com"
default['errbit']['config']['port']                               = 80
default['errbit']['config']['https']                              = false
default['errbit']['config']['enforce_ssl']                        = false
default['errbit']['config']['email_from']                         = "errbit@example.com"
default['errbit']['config']['per_app_email_at_notices']           = false
default['errbit']['config']['email_at_notices']                   = [1, 10, 100]
default['errbit']['config']['per_app_notify_at_notices']          = false
default['errbit']['config']['notify_at_notices']                  = [0]
default['errbit']['config']['confirm_err_actions']                = true
default['errbit']['config']['user_has_username']                  = false
default['errbit']['config']['allow_comments_with_issue_tracker']  = true
default['errbit']['config']['display_internal_errors']            = true
default['errbit']['config']['use_gravatar']                       = true
default['errbit']['config']['gravatar_default']                   = "identicon"

# errbit github integration
default['errbit']['config']['github_authentication']  = false
default['errbit']['config']['github_client_id']       = "github_client_id"
default['errbit']['config']['github_secret']          = "github_secret"
default['errbit']['config']['github_access_scope']    = ['repo']

# mongodb creds
default['errbit']['db']['host']                  = "localhost"
default['errbit']['db']['port']                  = "27017"
default['errbit']['db']['database']              = "errbit"
default['errbit']['db']['username']              = ""
default['errbit']['db']['password']              = ""
default['errbit']['db']['identity_map_enabled']  = true
default['errbit']['db']['use_utc']               = true

# app server (Optional: More info in README)
default['errbit']['server'] = "unicorn" # or use others like puma

default['errbit']['secret_token'] = '1505bf435970a11dc892d434eb69bc07190ff42e6f3fe4db8b158f56d5f7c6c1861dfd018e499a4ca120c9881684ad985f98cb1f48f3b76cbea9c85d5465bbce'

