

Chef::Log.info "-" * 70
Chef::Log.info "Checking to bootstrap the admin user"

rbenv_script 'rake db:seed' do
  code 'bundle exec rake db:seed RAILS_ENV=' + node['errbit']['environment']
  cwd "#{node['errbit']['deploy_to']}/current"
  user node['errbit']['user']
  # not_if "bundle exec rails runner 'p User.where(admin: true).first'"
  notifies :create, "ruby_block[remove_bootstrap]", :immediately
  # notifies :restart, "service[unicorn_#{app['id']}]"
end

ruby_block "remove_bootstrap" do
  block do
    Chef::Log.info("Database seed/bootstrap completed, removing the destructive recipe[errbit::bootstrap]")
    node.run_list.remove("recipe[errbit::bootstrap]") if node.run_list.include?("recipe[errbit::bootstrap]")
  end
  action :nothing
end
