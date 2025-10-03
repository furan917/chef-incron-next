# Backward compatibility wrapper for incron_user
# Delegates to incron_next_user
resource_name :incron_user
provides :incron_user

property :username, String, name_property: true

action :allow do
  incron_next_user new_resource.username do
    action :allow
  end
end

action :deny do
  incron_next_user new_resource.username do
    action :deny
  end
end
