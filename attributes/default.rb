#
# Cookbook Name:: errbit
# Attribute:: default
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

default['errbit']['name']         = "errbit"
default['errbit']['user']         = "errbit"
default['errbit']['group']        = node['errbit']['user']
default['errbit']['deploy_to']    = "/home/#{node['errbit']['user']}/#{node['errbit']['name']}"
default['errbit']['repo_url']     = "git://github.com/errbit/errbit.git"
default['errbit']['revision']     = "master"

# Local ruby to install via rbenv
default['errbit']['install_ruby']   = "2.2.2"
default['errbit']['javascript_gem'] = 'therubyracer'
default['rbenv']['user_installs']   = [{ 'user' => node['errbit']['user'] }]

# dotenv file variables
#
## Errbit
default['errbit']['config']['errbit_host']                       = 'errbit.example.com' # Don't default to FQDN, it might fail e-mail validation.
default['errbit']['config']['errbit_protocol']                   = 'http'
default['errbit']['config']['errbit_port']                       = 80
default['errbit']['config']['errbit_enforce_ssl']                = false
default['errbit']['config']['errbit_confirm_err_actions']        = true
default['errbit']['config']['errbit_user_has_username']          = true
default['errbit']['config']['errbit_use_gravatar']               = true
default['errbit']['config']['errbit_gravatar_default']           = 'identicon'
default['errbit']['config']['errbit_email_from']                 = 'errbit@example.com'
default['errbit']['config']['errbit_email_at_notices']           = [1, 10, 100]
default['errbit']['config']['errbit_per_app_email_at_notices']   = false
default['errbit']['config']['errbit_notify_at_notices']          = [0]
default['errbit']['config']['errbit_per_app_notify_at_notices']  = false
#
## GitHub
default['errbit']['config']['github_url']                        = 'https://github.com'
default['errbit']['config']['github_authentication']             = false
default['errbit']['config']['github_client_id']                  = nil
default['errbit']['config']['github_secret']                     = nil
default['errbit']['config']['github_org_id']                     = nil
default['errbit']['config']['github_access_scope']               = ['repo']
#
## SMTP
default['errbit']['config']['smtp_server']                       = nil
default['errbit']['config']['smtp_port']                         = nil
default['errbit']['config']['smtp_authentication']               = nil
default['errbit']['config']['smtp_username']                     = nil
default['errbit']['config']['smtp_password']                     = nil
default['errbit']['config']['smtp_domain']                       = nil
#
## Sendmail
default['errbit']['config']['sendmail_location']                 = nil
default['errbit']['config']['sendmail_arguments']                = nil
#
## Misc
default['errbit']['config']['devise_modules']                    = %w( database_authenticatable recoverable rememberable trackable validatable omniauthable )
default['errbit']['config']['email_delivery_method']             = 'smtp'
default['errbit']['config']['mongo_url']                         = 'mongodb://localhost/errbit'
default['errbit']['config']['rails_env']                         = 'production'
default['errbit']['config']['secret_key_base']                   = nil
default['errbit']['config']['serve_static_assets']               = true

# The cookbook currently only supports Puma on systemd and Unicorn on SysVinit.
default['errbit']['server']['name'] = node['init_package'] == 'systemd' ? 'puma' : 'unicorn'

default['errbit']['server']['backlog']     = 100
default['errbit']['server']['preload_app'] = false
default['errbit']['server']['tcp_nodelay'] = true
default['errbit']['server']['tcp_nopush']  = true
default['errbit']['server']['timeout']     = 60
default['errbit']['server']['workers']     = 2
