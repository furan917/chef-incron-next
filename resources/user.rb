# Modern custom resource for incron user allow/deny lists
resource_name :incron_next_user
provides :incron_next_user

property :username, String, name_property: true
property :cookbook, String, default: 'incron-next'

action :allow do
  update_config('allow')
end

action :deny do
  update_config('deny')
end

action_class do
  def update_config(list_type = 'allow')
    # Get a list of allowed and denied users
    case list_type
    when 'allow'
      users = node['incron']['allowed_users'].dup
    when 'deny'
      users = node['incron']['denied_users'].dup
    else
      return false
    end

    users << new_resource.username unless users.include?(new_resource.username)

    run_context.resource_collection.each do |res|
      # Match both incron_user and incron_next_user resource names
      if res.resource_name.to_s == 'incron_user' || res.resource_name.to_s == 'incron_next_user'
        if res.action == new_resource.action
          users << res.username unless users.include?(res.username)
        end
      end
    end

    template "/etc/incron.#{list_type}" do
      cookbook new_resource.cookbook
      source 'incron.users.erb'
      mode '0644'
      variables(
        users: users
      )
      action :create
      notifies node['incron']['reload_method'], 'service[incrond]'
    end
  end
end
