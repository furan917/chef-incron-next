# Modern custom resource for incron.d entries
resource_name :incron_next_d
provides :incron_next_d

property :name, String, name_property: true
property :path, String, required: true
property :mask, String, required: true
property :command, String, required: true
property :cookbook, String, default: 'incron-next'

action :create do
  template "/etc/incron.d/#{new_resource.name}" do
    cookbook new_resource.cookbook
    source 'incron.d.erb'
    mode '0644'
    variables(
      path: new_resource.path,
      mask: new_resource.mask,
      command: new_resource.command
    )
    action :create
    notifies node['incron']['reload_method'], 'service[incrond]'
  end
end

action :delete do
  file "/etc/incron.d/#{new_resource.name}" do
    action :delete
    notifies node['incron']['reload_method'], 'service[incrond]'
  end
end
