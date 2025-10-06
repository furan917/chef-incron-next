# Backward compatibility wrapper for incron_d
# Delegates to incron_next_d
resource_name :incron_d
provides :incron_d
unified_mode true

property :path, String, required: true
property :mask, String, required: true
property :command, String, required: true
property :cookbook, String, default: 'incron-next'

action :create do
  incron_next_d new_resource.name do
    path new_resource.path
    mask new_resource.mask
    command new_resource.command
    cookbook new_resource.cookbook
    action :create
  end
end

action :delete do
  incron_next_d new_resource.name do
    action :delete
  end
end
