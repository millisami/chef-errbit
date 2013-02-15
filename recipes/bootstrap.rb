

Chef::Log.info "-" * 70
Chef::Log.info "Checking to bootstrap the admin user"
execute "check whether to bootstrap admin user" do
  command "bundle exec rake db:seed -t"
  cwd "#{node['errbit']['deploy_to']}/current"
  environment ({'RAILS_ENV' => 'production'})
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
