#
# Cookbook Name:: incron-next
# Recipe:: install
#
# Installs incron-next from source
#

node['incron']['build_dependencies'].each do |pkg|
  package pkg do
    action :install
  end
end

build_dir = "#{Chef::Config[:file_cache_path]}/incron-next-#{node['incron']['version']}"
tarball_path = "#{Chef::Config[:file_cache_path]}/incron-next-#{node['incron']['version']}.tar.gz"

if node['incron']['use_local_source']
  # Use archives added as cookbook file
  cookbook_file tarball_path do
    source "incron-next-#{node['incron']['version']}.tar.gz"
    mode '0644'
    action :create
    not_if { ::File.exist?("#{node['incron']['install_prefix']}/sbin/incrond") }
  end
else
  # Download from GitHub
  remote_file tarball_path do
    source node['incron']['source_url']
    mode '0644'
    action :create
    not_if { ::File.exist?("#{node['incron']['install_prefix']}/sbin/incrond") }

    retries 6
    retry_delay 5
  end
end

# Extract tarball
bash 'extract_incron_next' do
  code <<-EOH
    tar -xzf #{tarball_path} -C #{Chef::Config[:file_cache_path]}
  EOH
  creates build_dir
  not_if { ::File.exist?("#{node['incron']['install_prefix']}/sbin/incrond") }
end

# Build and install
bash 'build_incron_next' do
  cwd build_dir
  code <<-EOH
    make -j$(nproc) && make install PREFIX=#{node['incron']['install_prefix']}
  EOH
  creates "#{node['incron']['install_prefix']}/sbin/incrond"
  not_if { ::File.exist?("#{node['incron']['install_prefix']}/sbin/incrond") }
end

# Defensive Unmask of old service if it exists (may have been masked from old incron package)
bash 'unmask_incron_service' do
  code 'systemctl unmask incron'
  only_if 'systemctl list-unit-files | grep -q "incron.*masked"'
  ignore_failure true
end
