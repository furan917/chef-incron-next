#
# Cookbook Name:: incron-next
# Recipe:: default
#

include_recipe 'incron-next::install'

# Create systemd service file
template "/etc/systemd/system/#{node['incron']['service_name']}.service" do
  source 'incron.service.erb'
  mode '0644'
  variables(
    install_prefix: node['incron']['install_prefix']
  )
  action :create
  notifies :run, 'execute[systemd-daemon-reload]', :immediately
  notifies node['incron']['reload_method'], 'service[incrond]'
end

execute 'systemd-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

service 'incrond' do
  service_name node['incron']['service_name']
  supports :status => true, :restart => true, :reload => node['incron']['reload_method'] == :reload
  action [:enable, :start]
end

template '/etc/incron.conf' do
  source 'incron.conf.erb'
  mode '0644'
  action :create
  notifies node['incron']['reload_method'], 'service[incrond]'
end
